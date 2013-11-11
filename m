Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab3KKMNX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 07:13:23 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:45725 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059Ab3KKMNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 07:13:14 -0500
X-AuditID: cbfee68f-b7f836d000001b39-69-5280c9d82510
Message-id: <1384171947.14041.95.camel@kjgkr>
Subject: [GIT PULL] f2fs updates for v3.13
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Linux Kernel, Mailing List" <linux-kernel@vger.kernel.org>,
        "Linux FS DEV, Mailing List" <linux-fsdevel@vger.kernel.org>,
        "Linux F2FS DEV, Mailing List" 
	<linux-f2fs-devel@lists.sourceforge.net>
Date: Mon, 11 Nov 2013 21:12:27 +0900
Organization: Samsung
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsVy+t8zY92bJxuCDM6pWFxa5G6xZ+9JFovL
	u+awWTzqe8vuwOJxYsZvFo/dCz4zeXzeJBfAHMVlk5Kak1mWWqRvl8CV0fRlDltBh2bF/SU7
	GRsY++W6GDk5JARMJPafuc0OYYtJXLi3nq2LkYtDSGAZo8TTba2sMEUXNh5mgUgsYpRYOesV
	lPOKUWJ/73rmLkYODl4BXYmtE9JBTGEBLYmmZQogJpuAtsTm/QYgY4QEFCXe7r8LNlJEwEji
	84srrCBTmAVOMUos//CLGSTBIqAq8fp9I5jNLyAqcXjhdjCbWUBdYtK8RcwQ9yhJ7G7vZIeI
	y0tsXvMWLM4rICjxY/I9sNMkBNaxSzRf3sQIMVRA4tvkQywgB0kIyEpsOgA1R1Li4IobLBMY
	xWYhWTELydhZSMYuYGRexSiaWpBcUJyUXmSsV5yYW1yal66XnJ+7iRESP/07GO8esD7EmAy0
	ciKzlGhyPjD+8kriDY3NjCxMTUyNjcwtzUgTVhLnvf8wKUhIID2xJDU7NbUgtSi+qDQntfgQ
	IxMHp1QDY7CKvE6dZ8O6/POFDrpZ8lv11qXZntbqi1K9Z3ChVXjXgk0L7uhsOu+++abZHtdu
	hqnT7188nqNl8KW3Tzzy5QsZN4vbYo8OTjp8rtzrv4Gd2zXWr828j4uP7ru4TbLJ7k370Z9/
	WCJbmixtZr3b46V/OWWJ5ddagw+PtoofqJ1/7un2pr7A9UosxRmJhlrMRcWJACOqLwK1AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgleLIzCtJLcpLzFFi42I5/e+xgO6Nkw1BBuf3W1hcWuRusWfvSRaL
	y7vmsFk86nvL7sDicWLGbxaP3Qs+M3l83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5jR9GUOW0GHZsX9JTsZGxj75boYOTkkBEwkLmw8zAJhi0lcuLeerYuRi0NI
	YBGjxMpZr1ggnFeMEvt71zN3MXJw8AroSmydkA5iCgtoSTQtUwAx2QS0JTbvNwAZIySgKPF2
	/11WEFtEwEji84srrCBTmAVOMUos//CLGSTBIqAq8fp9I5jNLyAqcXjhdjCbWUBdYtK8RcwQ
	9yhJ7G7vZIeIy0tsXvMWLM4rICjxY/I9lgmMArOQtMxCUjYLSdkCRuZVjKKpBckFxUnpuUZ6
	xYm5xaV56XrJ+bmbGMHx+Ux6B+OqBotDjAIcjEo8vBEKDUFCrIllxZW5hxglOJiVRHg/HAcK
	8aYkVlalFuXHF5XmpBYfYkwG+mIis5Rocj4wdeSVxBsam5gZWRqZWRiZmJuTJqwkznuw1TpQ
	SCA9sSQ1OzW1ILUIZgsTB6dUA6PL3r9vAn7fsNs2//9tQ7GvHxhmmHXqnhL6dbGyWl1pTntm
	imTPBqs5HUJtb0sXCBbd23Jakjfo87acI+cFRfynyLnW6fNPSdQ16JzHm/HSW9RlI9Mk3wR9
	i7lGnw8yN3nbW0n85QhfNSGk91Dcm+DSgoht+xtnXdL9ZXbg3mO1R7X/366WFVFiKc5INNRi
	LipOBAAPvQfnEwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is a pull request on f2fs updates for v3.13.

In this round, a couple of patches were introduced to improve GC and
checkpoint overheads.
In addition, a sysfs entry and some tracepoints were added for users to
maintain the f2fs filesystem.
And there are a number of clean-ups and bug fixes.

Thank you very much.

The following changes since commit 4a10c2ac2f368583138b774ca41fac4207911983:

  Linux 3.12-rc2 (2013-09-23 15:41:09 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs.git tags/for-f2fs-3.13

for you to fetch changes up to 29e59c14ae5c21d25db1580d9651b5855d656a30:

  f2fs: issue more large discard command (2013-11-11 09:36:32 +0900)

----------------------------------------------------------------
f2fs updates for v3.13

This patch-set includes the following major enhancement patches.
o add a sysfs to control reclaiming free segments
o enhance the f2fs global lock procedures
o enhance the victim selection flow
o wait for selected node blocks during fsync
o add some tracepoints
o add a config to remove abundant BUG_ONs

The other bug fixes are as follows.
o fix deadlock on acl operations
o fix some bugs with respect to orphan inodes

And, there are a bunch of cleanups.

----------------------------------------------------------------
Changman Lee (3):
      f2fs: remove unnecessary segment bitmap updates
      f2fs: cleanup waiting routine for writeback pages in cp
      f2fs: issue more large discard command

Chao Yu (8):
      f2fs: avoid allocating failure in bio_alloc
      f2fs: remove unneeded write checkpoint in recover_fsync_data
      f2fs: remove redundant set_page_dirty from write_compacted_summaries
      f2fs: fix calculating incorrect free size when update xattr in __f2fs_setxattr
      f2fs: check all ones or zeros bitmap with bitops for better mount performance
      f2fs: remove unnecessary TestClearPageError when wait pages writeback
      f2fs: avoid to use a NULL point in destroy_segment_manager
      f2fs: fix memory leak after kobject init failed in fill_super

Fan Li (1):
      f2fs: change the method of calculating the number summary blocks

Gu Zheng (4):
      f2fs: use rw_sem instead of fs_lock(locks mutex)
      f2fs: introduce function read_raw_super_block()
      f2fs: avoid wait if IO end up when do_checkpoint for better performance
      f2fs: introduce f2fs_kmem_cache_alloc to hide the unfailed, kmem cache allocation

Haicheng Li (3):
      f2fs: use true and false for boolean value
      f2fs: no need to check other dirty_segmap when the seg has been found
      f2fs: use bool for booleans

Jaegeuk Kim (17):
      f2fs: avoid unnecessary checkpoints
      f2fs: fix writing incorrect orphan blocks
      f2fs: fix to store and retrieve i_rdev correctly
      f2fs: fix the starvation problem on cp_rwsem
      f2fs: avoid to write during the recovery
      f2fs: clean up several status-related operations
      f2fs: reclaim prefree segments periodically
      f2fs: introduce f2fs_balance_fs_bg for some background jobs
      f2fs: add reclaiming control by sysfs
      f2fs: add tracepoint for set_page_dirty
      f2fs: add tracepoint for vm_page_mkwrite
      f2fs: clean up acl flow for better readability
      f2fs: fix a deadlock during init_acl procedure
      f2fs: introduce CONFIG_F2FS_CHECK_FS for BUG_ON control
      f2fs: add an option to avoid unnecessary BUG_ONs
      f2fs: avoid to wait all the node blocks during fsync
      f2fs: update f2fs document

Jin Xu (1):
      f2fs: optimize the victim searching loop slightly

Kelly Anderson (1):
      f2fs: handle remount options correctly

Russ Knize (1):
      f2fs: don't GC or take an fs_lock from f2fs_initxattrs()

Russ W. Knize (2):
      f2fs: don't let the orphan inode counter underflow
      f2fs: account for orphan inodes during recovery

Yu Chao (1):
      f2fs: optimize fs_lock for better performance

 Documentation/filesystems/f2fs.txt |   7 ++
 fs/f2fs/Kconfig                    |   8 +++
 fs/f2fs/acl.c                      |  36 +++++-----
 fs/f2fs/acl.h                      |   9 +--
 fs/f2fs/checkpoint.c               |  75 +++++++++----------
 fs/f2fs/data.c                     |  29 ++++----
 fs/f2fs/dir.c                      |   4 +-
 fs/f2fs/f2fs.h                     | 117 ++++++++++++++++--------------
 fs/f2fs/file.c                     |  45 ++++++------
 fs/f2fs/gc.c                       |  31 ++++----
 fs/f2fs/inode.c                    |  62 +++++++++-------
 fs/f2fs/namei.c                    |  52 +++++++-------
 fs/f2fs/node.c                     | 142 +++++++++++++++++++++++-------------
 fs/f2fs/recovery.c                 |  45 +++++++-----
 fs/f2fs/segment.c                  | 133 ++++++++++++++++++----------------
 fs/f2fs/segment.h                  |  38 +++++++---
 fs/f2fs/super.c                    | 143 ++++++++++++++++++++++++++-----------
 fs/f2fs/xattr.c                    |  36 ++++++----
 include/trace/events/f2fs.h        |  51 +++++++++++++
 19 files changed, 651 insertions(+), 412 deletions(-)


-- 
Jaegeuk Kim
Samsung

