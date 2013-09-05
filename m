Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763544Ab3IEIJ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 04:09:27 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:40632 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763486Ab3IEIIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 04:08:55 -0400
X-AuditID: cbfee68f-b7f656d0000058e3-db-52283c152f53
Message-id: <1378368526.2354.96.camel@kjgkr>
Subject: [GIT PULL] f2fs updates for v3.12
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Linux Kernel, Mailing List" <linux-kernel@vger.kernel.org>,
        "Linux FS DEV, Mailing List" <linux-fsdevel@vger.kernel.org>,
        "Linux F2FS DEV, Mailing List" 
	<linux-f2fs-devel@lists.sourceforge.net>
Date: Thu, 05 Sep 2013 17:08:46 +0900
Organization: Samsung
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsVy+t8zI11RG40ggzkzVS0uLXK32LP3JIvF
	5V1z2Cwe9b1ld2DxODHjN4vH7gWfmTw+b5ILYI7isklJzcksSy3St0vgythy4TtbwWGNiq9b
	DzA2MLbKdjFyckgImEicbV3IBGGLSVy4t56ti5GLQ0hgGaPE/M1/WWCK/j69wwiRWMQocfjR
	BKiq10BVD1aCVfEK6EjsnvWEEcQWFtCS2NrRBDSWg4NNQFti834DkLCQgKLE2/13WUFsEQEj
	ic8vrrCCzGEWOMUosfzDL2aQBIuAqsSMd+fBTuIXEJU4vHA7WJxZQF1i0rxFzBAXKUnsbu9k
	h4jLS2xe85YZ4gZBiR+T77GADJUQWMcusfvCFHaIoQIS3yYfYgE5SEJAVmLTAag5khIHV9xg
	mcAoNgvJillIxs5CMnYBI/MqRtHUguSC4qT0ImO94sTc4tK8dL3k/NxNjJAo6t/BePeA9SHG
	ZKCVE5mlRJPzgVGYVxJvaGxmZGFqYmpsZG5pRpqwkjivWot1oJBAemJJanZqakFqUXxRaU5q
	8SFGJg5OqQbGwFnPYiKyJnw/KrbLpO/by7ZNN7f1bWRxsrkUcuPnyet/6rafqfVu1r8rqiC9
	20PqI+NkzaXebQFmk1dNd1f5uut41OpZlc4LxDU+l4cV9SZFXXXM1ry+tX6p4EO5+Q18Ha+5
	an02NRhdXyH7L+xHqZ9/zUk9Md6jnE/22DUb+P1LPpP5t3iSEktxRqKhFnNRcSIAZtxZJLgC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42I5/e+xgK6ojUaQweWjChaXFrlb7Nl7ksXi
	8q45bBaP+t6yO7B4nJjxm8Vj94LPTB6fN8kFMEc1MNpkpCampBYppOYl56dk5qXbKnkHxzvH
	m5oZGOoaWlqYKynkJeam2iq5+AToumXmAG1TUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesb
	EgTXY2SABhLWMWZsufCdreCwRsXXrQcYGxhbZbsYOTkkBEwk/j69wwhhi0lcuLeerYuRi0NI
	YBGjxOFHE6Cc14wS8x+sZAGp4hXQkdg96wlYh7CAlsTWjiamLkYODjYBbYnN+w1AwkICihJv
	999lBbFFBIwkPr+4wgoyh1ngFKPE8g+/mEESLAKqEjPenWcCsfkFRCUOL9wOFmcWUJeYNG8R
	M8RFShK72zvZIeLyEpvXvGWGuEFQ4sfkeywTGAVmIWmZhaRsFpKyBYzMqxhFUwuSC4qT0nON
	9IoTc4tL89L1kvNzNzGCY/SZ9A7GVQ0WhxgFOBiVeHgbjNWDhFgTy4orcw8xSnAwK4nwWqwE
	CvGmJFZWpRblxxeV5qQWH2JMBvpiIrOUaHI+MH3klcQbGpuYGVkamVkYmZibkyasJM57sNU6
	UEggPbEkNTs1tSC1CGYLEwenVANj5LrWS5pBuoyyX2vOCZxgz0j6KN0uWP7DKz2IJbh4t9Y3
	0Yszd707tmuxk1f51hMWIgwHZJkfbXvzNPNKyWQvvVkhT3X2+a+aGSxw7kFV29IoDT/B1+yP
	F51WFBLrlV+h7HL+Ru+8g15ByvX3j11hXXSm/N43s6ISYbXeSE8JgTeqx7nruUyUWIozEg21
	mIuKEwGZpXuvFQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here is the pull request on f2fs updates for v3.12.
This patch-set includes several enhancements such as inline-xattrs, sysfs,
proc entry, and performance improvement at worst case scenarios.
It also includes some bug fixes.
Thank you very much.

The following changes since commit 36f571e9ed0419e73d127e18aa8992ced867268c:

  Merge tag 'firewire-fix' of git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394 (2013-07-29 17:08:22 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs.git tags/for-f2fs-3.12

for you to fetch changes up to a26b7c8a0149ce1e3b6a10f2801aada6e447e4e7:

  f2fs: optimize gc for better performance (2013-09-05 13:50:32 +0900)

----------------------------------------------------------------
f2fs updates for v3.12

This patch-set includes the following major enhancement patches.
o support inline xattrs
o add sysfs support to control GCs explicitly
o add proc entry to show the current segment usage information
o improve the GC/SSR performance

The other bug fixes are as follows.
o avoid the overflow on status calculation
o fix some error handling routines
o fix inconsistent xattr states after power-off-recovery
o fix incorrect xattr node offset definition
o fix deadlock condition in fsync
o fix the fdatasync routine for power-off-recovery

----------------------------------------------------------------
Changman Lee (1):
      f2fs: add description for fsck.f2fs and dump.f2fs

Dan Carpenter (2):
      f2fs: remove an unneeded kfree(NULL)
      f2fs: alloc_page() doesn't return an ERR_PTR

Gu Zheng (8):
      f2fs: add a help func F2FS_STAT() to get the f2fs_stat_info
      f2fs: introduce help function F2FS_NODE()
      f2fs: use seq_puts()/seq_putc() rather than seq_printf() where possible
      f2fs: use list_for_each rather than list_for_each_safe, in remove_orphan_inode()
      f2fs: move bio_private allocation out of f2fs_bio_alloc()
      f2fs: clean up the needless end 'return' of void function
      f2fs: fix a compound statement label error
      f2fs: use strncasecmp() simplify the string comparison

Jaegeuk Kim (21):
      f2fs: recover date requested by fdatasync
      f2fs: add proc entry to monitor current usage of segments
      f2fs: update file name in the inode block during f2fs_rename
      f2fs: fix i_name during f2fs_sync_file
      f2fs: fix handling orphan inodes
      f2fs: fix a build failure due to missing the kobject header
      f2fs: fix the use of XATTR_NODE_OFFSET
      f2fs: fix inconsistency between xattr node blocks and its inode
      f2fs: introduce cur_cp_version function to reduce code size
      f2fs: check the free space first in new_node_page
      f2fs: should cover i_xattr_nid with its xattr node page lock
      f2fs: fix wrong BUG_ON condition
      f2fs: add flags for inline xattrs
      f2fs: reserve the xattr space dynamically
      f2fs: introduce __find_xattr for readability
      f2fs: add the truncate_xattr_node function
      f2fs: support the inline xattrs
      f2fs: fix omitting to update inode page
      f2fs: trigger GC when there are prefree segments
      f2fs: avoid an overflow during utilization calculation
      f2fs: merge more bios of node block writes

Jin Xu (3):
      f2fs: fix a deadlock in fsync
      f2fs: avoid writing inode redundantly when creating a file
      f2fs: optimize gc for better performance

Namjae Jeon (3):
      f2fs: add sysfs support for controlling the gc_thread
      f2fs: add sysfs entries to select the gc policy
      f2fs: remove redundant code from f2fs_write_begin

Wei Yongjun (1):
      f2fs: fix error return code in init_f2fs_fs()

Zhao Hongjiang (1):
      f2fs: fix memory leak when init f2fs filesystem fail

 Documentation/ABI/testing/sysfs-fs-f2fs |  26 +++
 Documentation/filesystems/f2fs.txt      |  75 ++++++++-
 fs/f2fs/checkpoint.c                    |  24 ++-
 fs/f2fs/data.c                          |  28 ++--
 fs/f2fs/debug.c                         |  34 ++--
 fs/f2fs/dir.c                           |  19 ++-
 fs/f2fs/f2fs.h                          | 106 +++++++++---
 fs/f2fs/file.c                          |  25 ++-
 fs/f2fs/gc.c                            |  58 ++++---
 fs/f2fs/gc.h                            |  38 +++--
 fs/f2fs/inode.c                         |  15 +-
 fs/f2fs/namei.c                         |  33 ++--
 fs/f2fs/node.c                          | 100 +++++++----
 fs/f2fs/node.h                          |  44 +++--
 fs/f2fs/recovery.c                      |  29 ++--
 fs/f2fs/segment.c                       |  41 +++--
 fs/f2fs/segment.h                       |   6 +-
 fs/f2fs/super.c                         | 209 ++++++++++++++++++++++-
 fs/f2fs/xattr.c                         | 289 ++++++++++++++++++++------------
 fs/f2fs/xattr.h                         |  15 +-
 include/linux/f2fs_fs.h                 |  20 ++-
 21 files changed, 890 insertions(+), 344 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-fs-f2fs

-- 
Jaegeuk Kim
Samsung

