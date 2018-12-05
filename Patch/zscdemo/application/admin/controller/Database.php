<?php


namespace app\admin\controller;
use app\common\controller\Admin;

class Database extends Admin {

	public function index($type = null) {
		switch ($type) {
		/* 数据还原 */
		case 'import':
			//列出备份文件列表
			$path = config('data_backup_path');
			if (!is_dir($path)) {
				mkdir($path, 0755, true);
			}
			$path = realpath($path);
			$flag = \FilesystemIterator::KEY_AS_FILENAME;
			$glob = new \FilesystemIterator($path, $flag);

			$list = array();
			foreach ($glob as $name => $file) {
				if (preg_match('/^\d{8,8}-\d{6,6}-\d+\.sql(?:\.gz)?$/', $name)) {
					$name = sscanf($name, '%4s%2s%2s-%2s%2s%2s-%d');

					$date = "{$name[0]}-{$name[1]}-{$name[2]}";
					$time = "{$name[3]}:{$name[4]}:{$name[5]}";
					$part = $name[6];

					if (isset($list["{$date} {$time}"])) {
						$info         = $list["{$date} {$time}"];
						$info['part'] = max($info['part'], $part);
						$info['size'] = $info['size'] + $file->getSize();
					} else {
						$info['part'] = $part;
						$info['size'] = $file->getSize();
					}
					$extension        = strtoupper(pathinfo($file->getFilename(), PATHINFO_EXTENSION));
					$info['compress'] = ($extension === 'SQL') ? '-' : $extension;
					$info['time']     = strtotime("{$date} {$time}");

					$list["{$date} {$time}"] = $info;
				}
			}
			$title = '数据还原';
			break;
		/* 数据备份 */
		case 'export':
			$Db    = \think\Db::connect();
			$list  = $Db->query('SHOW TABLE STATUS');
			$list  = array_map('array_change_key_case', $list);
			$title = '数据备份';
			break;
		default:
			return $this->error('参数错误！');
		}
		//渲染模板
		$this->setMeta($title);
		$this->assign('list', $list);
		return $this->fetch($type);
	}