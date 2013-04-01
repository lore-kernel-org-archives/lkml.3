Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910Ab3DAJRJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 05:17:09 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:53992 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757885Ab3DAJRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 05:17:07 -0400
X-AuditID: cbfee68e-b7f946d000001e37-f7-51595091ca63
Date: Mon, 01 Apr 2013 09:17:05 +0000 (GMT)
From: Jongman Heo <jongman.heo@samsung.com>
Subject: [3.9-rc5] INFO: task umount:29671 blocked for more than 120 seconds
To: linux-kernel@vger.kernel.org
Reply-to: jongman.heo@samsung.com
MIME-version: 1.0
X-MTR: 20130401091237811@jongman.heo
Msgkey: 20130401091237811@jongman.heo
X-EPLocale: ko_KR.utf-8
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130401091237811@jongman.heo
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <31775765.508251364807825241.JavaMail.weblogic@epml02>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42JZI2JSpDsxIDLQ4ECDjMXlXXPYHBg9Pm+S
	C2CM4rJJSc3JLEst0rdL4Mpo3zqFtaBPraL1WVwDY49qFyMnh5CAmsTNz4cYQWwJAROJDb/3
	sUHYYhIX7q0HsrmAapYySuztWMgMU7T+9VomiMR8RonJUzeAdbAIqEis3jORFcRmE9CR6Pi/
	H8wWFvCRWH7mHhOILSKgKrHj7Ap2iM2KEteWLgbr5RUQlDg58wlLFyMH0AIVibN7oMKqEt9/
	34LaKy5xYe4ldgibV2JG+1MWCFtOYtrXNVA10hLnZ21ghHlg8ffHUHF+iWO3dzBBjOeVeHI/
	GGbM7s1foP4VkJh65iBUq6bErdM7oFr5JNYsfMsCM2bXqeXMML33t8wF+4oZ6JMp3Q/ZQcYz
	A/Wu36WP7ileASeJXdOrQIEmIdDLIdHSt5FlAqPSLCRls5BMmoUwCVnJAkaWVYyiqQXJBcVJ
	6UVGesWJucWleel6yfm5mxiBCeH0v2d9OxhvHrA+xJgMjI+JzFKiyfnAhJJXEm9obGZkYWpi
	amxkbmlGmrCSOK9ai3WgkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBkb+fcvNy6d8Ep4999rz
	nnmTzr25vjkiQ8qiykPTcGrpnO0z3py5UVy8Z67O7pTZ6hu5OJ2PxayRu7XkzuMkGW+ftfOc
	5iz5z7mH9/HHtifGB1gu6G+ZuN7pVu32JQms8inL717REXic7NhS82Mb27LJHnPaj5zoPbp4
	XU1XdZ+4+065gkf3xaIblViKMxINtZiLihMBjWNVuh4DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPKsWRmVeSWpSXmKPExsVy+t/tmboTAyIDDaZeFrW4vGsOmwOjx+dN
	cgGMUWk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StGG5kZ6RgZ6pkZ6hsaxVoYGBkamQDUJaRnt
	W6ewFvSpVbQ+i2tg7FHtYuTkEBJQk7j5+RAjiC0hYCKx/vVaJghbTOLCvfVsXYxcQDXzGSUm
	T93ABpJgEVCRWL1nIiuIzSagI9Hxfz+YLSzgI7H8zD2wZhEBVYkdZ1ewQyxQlLi2dDFYL6+A
	oMTJmU9Yuhg5gBaoSJzdAxVWlfj++xYzxF5xiQtzL7FD2LwSM9qfskDYchLTvq6BqpGWOD9r
	AyPMnYu/P4aK80scu72DCWI8r8ST+8EwY3Zv/sIGYQtITD1zEKpVU+LW6R1QrXwSaxa+ZYEZ
	s+vUcmaY3vtb5oJ9xQz0yZTuh+wg45mBetfv0kf3FK+Ak8Su6VUTGGVnIcnMQtI8C6EZWckC
	RpZVjKKpBckFxUnpFcZ6xYm5xaV56XrJ+bmbGMHJ59niHYz/z1sfYhTgYFTi4Y24EBEoxJpY
	VlyZe4hRgoNZSYTX5xtQiDclsbIqtSg/vqg0J7X4EGMyMMImMkuJJucDE2NeSbyhsbGJmYmp
	pYmFgak5acJK4rzPWq0DhQTSE0tSs1NTC1KLYLYwcXBKNTC2e3lcTllS+iDvRKf052nOciqc
	ky0ZA69MXX3bZlqRmtza5lfPqiepMMUzpbClK81NvB6+WyIj314jKCyKZZHlHrf1Qlf9ZFj6
	X0/iCpTo3+PCkW/39VzN05T/L5Ie1B6uWd0w5VRu22M/U57QZY3im47ZPHB7v/K3kI/ck/iN
	mW9ePwhpTVFiKc5INNRiLipOBABCTlpMggMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r319HD3i008772


Hi guys,

I hit following warning with 3.9-rc5, during unmount (the device was mounted via loop device, in case it matters).

Jongman.

[ 3600.583547] INFO: task umount:29671 blocked for more than 120 seconds.
[ 3600.583552] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 3600.583555] umount          D 0000000000000001     0 29671  29632 0x00000000
[ 3600.583561]  ffff88011ecb5c98 0000000000000086 ffff880130ccade0 0000000000013e40
[ 3600.583566]  ffff88011ecb5fd8 ffff88011ecb4010 0000000000013e40 0000000000013e40
[ 3600.583571]  ffff88011ecb5fd8 0000000000013e40 ffff880132518000 ffff880130ccade0
[ 3600.583575] Call Trace:
[ 3600.583583]  [<ffffffff816fb669>] schedule+0x29/0x70
[ 3600.583589]  [<ffffffff816fb98e>] schedule_preempt_disabled+0xe/0x10
[ 3600.583593]  [<ffffffff816fa0af>] __mutex_lock_slowpath+0xdf/0x160
[ 3600.583598]  [<ffffffff811e433e>] ? release_sysfs_dirent+0x7e/0x100
[ 3600.583603]  [<ffffffff816f9fab>] mutex_lock+0x2b/0x50
[ 3600.583607]  [<ffffffff8149a8aa>] loop_clr_fd+0x24a/0x2e0
[ 3600.583612]  [<ffffffff816fce3e>] ? _raw_spin_lock+0xe/0x20
[ 3600.583617]  [<ffffffff8149a9b8>] lo_release+0x78/0x90
[ 3600.583622]  [<ffffffff811a94e4>] __blkdev_put+0x194/0x1d0
[ 3600.583628]  [<ffffffff811a957d>] blkdev_put+0x5d/0x160
[ 3600.583633]  [<ffffffff811719bd>] kill_block_super+0x4d/0x80
[ 3600.583638]  [<ffffffff81171f35>] deactivate_locked_super+0x45/0x70
[ 3600.583643]  [<ffffffff81172dda>] deactivate_super+0x4a/0x70
[ 3600.583648]  [<ffffffff8118e538>] mntput_no_expire+0xf8/0x150
[ 3600.583653]  [<ffffffff8118eded>] sys_umount+0xcd/0x3e0
[ 3600.583659]  [<ffffffff817058d9>] system_call_fastpath+0x16/0x1b
[ 3600.583663] INFO: task blkid:29673 blocked for more than 120 seconds.
[ 3600.583665] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 3600.583667] blkid           D ffffffff81807f20     0 29673      1 0x00000000
[ 3600.583672]  ffff88011338fa88 0000000000000082 ffff880130ccc4d0 0000000000013e40
[ 3600.583677]  ffff88011338ffd8 ffff88011338e010 0000000000013e40 0000000000013e40
[ 3600.583681]  ffff88011338ffd8 0000000000013e40 ffff880132b416f0 ffff880130ccc4d0
[ 3600.583686] Call Trace:
[ 3600.583691]  [<ffffffff816fb669>] schedule+0x29/0x70
[ 3600.583695]  [<ffffffff816fb98e>] schedule_preempt_disabled+0xe/0x10
[ 3600.583700]  [<ffffffff816fa0af>] __mutex_lock_slowpath+0xdf/0x160
[ 3600.583704]  [<ffffffff816f9fab>] mutex_lock+0x2b/0x50
[ 3600.583709]  [<ffffffff811a9723>] __blkdev_get+0x73/0x480
[ 3600.583714]  [<ffffffff811a9e90>] ? blkdev_get+0x360/0x360
[ 3600.583719]  [<ffffffff811a9b81>] blkdev_get+0x51/0x360
[ 3600.583724]  [<ffffffff816fce3e>] ? _raw_spin_lock+0xe/0x20
[ 3600.583729]  [<ffffffff811a9e90>] ? blkdev_get+0x360/0x360
[ 3600.583734]  [<ffffffff811a9ef2>] blkdev_open+0x62/0x80
[ 3600.583739]  [<ffffffff8116d82e>] do_dentry_open+0x23e/0x2c0
[ 3600.583743]  [<ffffffff8116d9c5>] finish_open+0x35/0x50
[ 3600.583748]  [<ffffffff8117c7b6>] do_last+0x696/0xe50
[ 3600.583752]  [<ffffffff81166984>] ? kmem_cache_alloc_trace+0xc4/0x120
[ 3600.583757]  [<ffffffff8117f7c8>] path_openat+0xb8/0x490
[ 3600.583762]  [<ffffffff8117fcd9>] do_filp_open+0x49/0xa0
[ 3600.583767]  [<ffffffff816fce3e>] ? _raw_spin_lock+0xe/0x20
[ 3600.583772]  [<ffffffff8118c4e5>] ? __alloc_fd+0xb5/0x160
[ 3600.583777]  [<ffffffff8116d498>] do_sys_open+0x108/0x1f0
[ 3600.583781]  [<ffffffff8116d5c1>] sys_open+0x21/0x30
[ 3600.583786]  [<ffffffff817058d9>] system_call_fastpath+0x16/0x1bˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
