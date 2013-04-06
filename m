Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856Ab3DFGtp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 02:49:45 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:27797 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756102Ab3DFGtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 02:49:43 -0400
X-AuditID: cbfee68e-b7f946d000001e37-14-515fc586b14a
Date: Sat, 06 Apr 2013 06:49:42 +0000 (GMT)
From: Jongman Heo <jongman.heo@samsung.com>
Subject: [3.9-rc5 regression, BISECTED] INFO: task umount:29671 blocked for
 more than 120 seconds
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: jongman.heo@samsung.com
MIME-version: 1.0
X-MTR: 20130406063522867@jongman.heo
Msgkey: 20130406063522867@jongman.heo
X-EPLocale: ko_KR.utf-8
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130406063522867@jongman.heo
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <12072206.85601365230982200.JavaMail.weblogic@epml02>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42JZI2JSrNt2ND7Q4N43OYvLu+awOTB6fN4k
	F8AYxWWTkpqTWZZapG+XwJWxYt1BtoIjQRXzV1xhbWDcENDFyMkhJKAmcfPzIUYQW0LARGLT
	rZlMELaYxIV769m6GLmAapYySnzafp8Vpmji972sEM3zGSWO/tUGsVkEVCT2db4Ai7MJ6Eh0
	/N8PZgsLJEqcPDUPzBYRcJTYcfArG0SvosS1pYvBbF4BQYmTM5+wdDFyAM1XkTh62QwirCqx
	tuEHM8RacYkLcy+xQ9i8EjPan7JA2HIS076ugaqRljg/awMjzP2Lvz+GivNLHLu9gwliPK/E
	k/vBMGN2b/7CBmELSEw9cxCqVVPi2PE9UOP5JNYsfMsCM2bXqeXMML33t8wFBxUz0CdTuh+y
	g4xnBupdv0sf1VMgtqPErVUtUKs6OSSWzrGdwKg0C0nZLCSTZiFMQlaygJFlFaNoakFyQXFS
	epGRXnFibnFpXrpecn7uJkZgQjj971nfDsabB6wPMSYD42Mis5Rocj4woeSVxBsamxlZmJqY
	GhuZW5qRJqwkzqvWYh0oJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgbFHyP/BVjaNmx+kgib0
	tm9w9/zvPuWTu4tc36s3aq1155rlHcxv6L4OPCE97yv/aqb3Ja3Tj9reaQ5JMlumslvakp/n
	zbW7auf3XX0gw9JTOe3X61Xcy/e4Sjo983PsiVnqUBAWtH3a72erNTt8+Fo8Xha5TWCWOL/n
	7P9FRzad8Cjek3PjqJASS3FGoqEWc1FxIgCQTHsoHgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAKsWRmVeSWpSXmKPExsVy+t/tmbptR+MDDSadF7e4vGsOmwOjx+dN
	cgGMUWk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StGG5kZ6RgZ6pkZ6hsaxVoYGBkamQDUJaRkr
	1h1kKzgSVDF/xRXWBsYNAV2MnBxCAmoSNz8fYgSxJQRMJCZ+38sKYYtJXLi3ng2iZj6jxNG/
	2iA2i4CKxL7OF2A1bAI6Eh3/94PZwgKJEidPzQOzRQQcJXYc/ArVqyhxbeliMJtXQFDi5Mwn
	LF2MHEDzVSSOXjaDCKtKrG34wQyxVlziwtxL7BA2r8SM9qcsELacxLSva6BqpCXOz9rACHPm
	4u+PoeL8Esdu72CCGM8r8eR+MMyY3Zu/sEHYAhJTzxyEatWUOHZ8D9R4Pok1C9+ywIzZdWo5
	M0zv/S1zmUBsZqBPpnQ/ZAcZzwzUu36XPqqnQGxHiVurWtgmMMrOQpKahaR7FkI3spIFjCyr
	GEVTC5ILipPSK0z0ihNzi0vz0vWS83M3MYLTz7MlOxgbLlgfYhTgYFTi4bW4HRcoxJpYVlyZ
	e4hRgoNZSYRX9jlQiDclsbIqtSg/vqg0J7X4EGMyMMYmMkuJJucDU2NeSbyhsbGJmYmppYmF
	gak5acJK4rzPWq0DhQTSE0tSs1NTC1KLYLYwcXBKNTBOtrNRklV1imzs3GXmLK5R+WT1o94Z
	VbnvwgXilq/Sfmc/U1D9OOu5/R42EQeMbdcV1K+Q2bFQ63HlrLWb97RLlQvMrD38Yt2H3IJS
	85o3iyf3l3TaH1kxpSW2XfNU3E7dh1P+CDZ6q+470D138yqFH5FrnsyTLdv5/Gf4h1D3yyYR
	XL+9pzxXYinOSDTUYi4qTgQAJTFwjoMDAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r366nmdr013498

Hi guys,

Once I reported this issue (on 1st Apr), and have just done git bisect.

I hit kernel hang with 3.9-rc5, during unmount (the device was mounted via loop device, in case it matters).

Steps to reproduce :
    # mount <ISO-9660_iso_image> /mnt -o loop
    # umount /mnt

It's bisected to commit 8761a3dc ("loop: cleanup partitions when detaching loop device").
Reverting the commit fixes my issue.

8761a3dc1f07b163414e2215a2cadbb4cfe2a107 is the first bad commit
commit 8761a3dc1f07b163414e2215a2cadbb4cfe2a107
Author: Phillip Susi <psusi@ubuntu.com>
Date:   Fri Mar 22 12:21:53 2013 -0600
    loop: cleanup partitions when detaching loop device
    
    Any partitions added by user space to the loop device were being
    left in place after detaching the loop device.  This was because
    the detach path issued a BLKRRPART to clean up partitions if
    LO_FLAGS_PARTSCAN was set, meaning that the partitions were auto
    scanned on attach.  Replace this BLKRRPART with code that
    unconditionally cleans up partitions on detach instead.
    
    Signed-off-by: Phillip Susi <psusi@ubuntu.com>
    
    Modified by Jens to export delete_partition().
    
    Signed-off-by: Jens Axboe <axboe@kernel.dk>
:040000 040000 cb9c85a6b877831e7bb964903de3a01366759ff1 20541f4b522f91861ed02c43e559d0a53252827a M      block
:040000 040000 928d75dba61e6e83fd42fabf5465de56aef9c5b1 f9f4cc9b35c001297740d1d7769e81f8abd3e17d M      drivers

# git bisect log
git bisect start
# bad: [53f63189b1110559dce8c1ee29e8abc3e31f7630] Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
git bisect bad 53f63189b1110559dce8c1ee29e8abc3e31f7630
# good: [19f949f52599ba7c3f67a5897ac6be14bfcb1200] Linux 3.8
git bisect good 19f949f52599ba7c3f67a5897ac6be14bfcb1200
# good: [9afa3195b96da7d2320ec44d19fbfbded7a15571] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial
git bisect good 9afa3195b96da7d2320ec44d19fbfbded7a15571
# good: [9626357371b519f2b955fef399647181034a77fe] Merge tag 'xtensa-next-20130225' of git://github.com/czankel/xtensa-linux
git bisect good 9626357371b519f2b955fef399647181034a77fe
# good: [56a79b7b021bf1b08334e63c2c14b280e2dbf47a] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs
git bisect good 56a79b7b021bf1b08334e63c2c14b280e2dbf47a
# good: [ea4a0ce11160200410abbabd44ec9e75e93a95be] Merge git://git.kernel.org/pub/scm/virt/kvm/kvm
git bisect good ea4a0ce11160200410abbabd44ec9e75e93a95be
# good: [630a216da662ba4197e330118fc55d772a2d7ec9] Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless into for-davem
git bisect good 630a216da662ba4197e330118fc55d772a2d7ec9
# bad: [f8e9248dbb2bddfaed86a14254b7ca2409ef68ff] Merge branch 'for-3.9' of git://linux-nfs.org/~bfields/linux
git bisect bad f8e9248dbb2bddfaed86a14254b7ca2409ef68ff
# good: [3615db41c4b82896de450b6b4e3dab2420dcae51] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs
git bisect good 3615db41c4b82896de450b6b4e3dab2420dcae51
# bad: [a7b436d356d0bdc6156e286f9c251beed1961d2d] Merge branch 'v4l_for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media
git bisect bad a7b436d356d0bdc6156e286f9c251beed1961d2d
# bad: [d8d595dfce7925627de78b9eecc8598a6ffda610] block: removes dynamic allocation on stack
git bisect bad d8d595dfce7925627de78b9eecc8598a6ffda610
# good: [b1173e316bf2ff3c11f46247417f0f5789a4ea0c] xen-blkfront: remove frame list from blk_shadow
git bisect good b1173e316bf2ff3c11f46247417f0f5789a4ea0c
# good: [351a2c6e7d265f97799ec7f6b1dde7fc7cb4b92d] rsxx: fix missing unlock on error return in rsxx_eeh_remap_dmas()
git bisect good 351a2c6e7d265f97799ec7f6b1dde7fc7cb4b92d
# good: [183cfb5720dfc393641b87710ce78561af3db6cd] loop: fix error return code in loop_add()
git bisect good 183cfb5720dfc393641b87710ce78561af3db6cd
# bad: [d2b805d89510737ea80c1469f854a16480d19778] cciss: fix invalid use of sizeof in cciss_find_cfgtables()
git bisect bad d2b805d89510737ea80c1469f854a16480d19778
# bad: [8761a3dc1f07b163414e2215a2cadbb4cfe2a107] loop: cleanup partitions when detaching loop device
git bisect bad 8761a3dc1f07b163414e2215a2cadbb4cfe2a107


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
[ 3600.583786]  [<ffffffff817058d9>] system_call_fastpath+0x16/0x1b

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
