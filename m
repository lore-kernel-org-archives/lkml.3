Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775AbaDGEVl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 00:21:41 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:28498 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbaDGEVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 00:21:37 -0400
X-AuditID: cbfee68f-b7f156d00000276c-3f-534227ca59a5
Message-id: <1396844374.24638.9.camel@kjgkr>
Subject: [GIT PULL] f2fs updates for v3.15
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Linux F2FS DEV, Mailing List" 
	<linux-f2fs-devel@lists.sourceforge.net>,
        "Linux FS DEV, Mailing List" <linux-fsdevel@vger.kernel.org>,
        "Linux Kernel, Mailing List" <linux-kernel@vger.kernel.org>
Date: Mon, 07 Apr 2014 13:19:34 +0900
Organization: Samsung
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMIsWRmVeSWpSXmKPExsVy+t8zI91T6k7BBuu2CFtcWuRusWfvSRaL
	y7vmsFk86nvL7sDicWLGbxaP3Qs+M3l83iQXwBzFZZOSmpNZllqkb5fAlXHrTgNzwQLjiq/b
	3jA1MP5S6WLk5JAQMJF4tWw7O4QtJnHh3nq2LkYuDiGBZYwSJw/uZIYp+ve3kR0iMZ1RYv6c
	u0wgCSGBV4wS59sCQWxeAR2JT5s3MnYxcnAIC2hJLPzBB2KyCWhLbN5vAFGtKPF2/11WEFtE
	wEji84srrCAjmQVOMUpcfXMOLMEioCqx4Pl2sL38AqIShxdC2MwC6hKT5i2CukdJYnd7JztE
	XF5i85q3zBAnCEr8mHyPBWSohMA6domm1fPYIYYKSHybfIgF5CAJAVmJTQeg5khKHFxxg2UC
	o9gsJCtmIRk7C8nYBYzMqxhFUwuSC4qT0ouM9YoTc4tL89L1kvNzNzFCIqh/B+PdA9aHGJOB
	Vk5klhJNzgdGYF5JvKGxmZGFqYmpsZG5pRlpwkrivPcfJgUJCaQnlqRmp6YWpBbFF5XmpBYf
	YmTi4JRqYJypJhbOmJmbfiBMfIL32y3fs9N/Mxr8zbomrRo/+//1nrIPa25NtJQOPsW2+9V7
	Lp5tnTG1vxapeU/MuMPzcKpPkcTGm4rL6o41HLmXt2D/UdNNJxd7f58qEf3C+0WMoFnHvILl
	Uj9nany+IlYuaB+r69zy4+X2Ha3zVmS8Y3gWfJ5tVd7vlSeUWIozEg21mIuKEwGpoqLxtgIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgleLIzCtJLcpLzFFi42I5/e+xoO4pdadgg5kf+SwuLXK32LP3JIvF
	5V1z2Cwe9b1ld2DxODHjN4vH7gWfmTw+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8y4daeBuWCBccXXbW+YGhh/qXQxcnJICJhI/PvbyA5hi0lcuLeerYuRi0NI
	YDqjxPw5d5lAEkICrxglzrcFgti8AjoSnzZvZOxi5OAQFtCSWPiDD8RkE9CW2LzfAKJaUeLt
	/rusILaIgJHE5xdXWEFGMgucYpS4+uYcWIJFQFViwfPtzCA2v4CoxOGFEDazgLrEpHmLmCHu
	UZLY3d7JDhGXl9i85i0zxAmCEj8m32OZwCgwC0nLLCRls5CULWBkXsUomlqQXFCclJ5rpFec
	mFtcmpeul5yfu4kRHJ/PpHcwrmqwOMQowMGoxMMbeMAxWIg1say4MvcQowQHs5II7252p2Ah
	3pTEyqrUovz4otKc1OJDjMlAX0xklhJNzgemjrySeENjEzMjSyMzCyMTc3PShJXEeQ+2WgcK
	CaQnlqRmp6YWpBbBbGHi4JRqYGzaOqNkjtTqlG05Xz9zTxFsvh4atcPbtFP+4tW5N/J6mW7x
	XWZdfundwQRtbpXkdT6Pnl851Lxpl1uIwWq9vUfqrqqkJKqr/zdPfTlZ6LVah9ehY+2vU1bb
	3o65ernLetXbtLnsZx9nS9/Mvs26TS0m4l1DcF76UsZXnXPDS899Y/minJZosUWJpTgj0VCL
	uag4EQB31KKUEwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is a pull request on f2fs updates for v3.15.

In this round, a couple of sysfs entries were introduced to tune the
f2fs at runtime. In addition, f2fs starts to support large directory and
f2fs_issue_flush thread to improve the performance under some server
workloads.
Most of the other patches are related to bug fixes and clean-ups.

Thank you very much.

The following changes since commit
6d0abeca3242a88cab8232e4acd7e2bf088f3bc2:

  Linux 3.14-rc3 (2014-02-16 13:30:25 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs.git
tags/for-f2fs-3.15

for you to fetch changes up to 48b230a583965d33c32b4e3c29a1e5e15d7e55de:

  f2fs: fix wrong statistics of inline data (2014-04-07 12:40:58 +0900)

----------------------------------------------------------------
f2fs updates for v3.15

This patch-set includes the following major enhancement patches.
 o introduce large directory support
 o introduce f2fs_issue_flush to merge redundant flush commands
 o merge write IOs as much as possible aligned to the segment
 o add sysfs entries to tune the f2fs configuration
 o use radix_tree for the free_nid_list to reduce in-memory operations
 o remove costly bit operations in f2fs_find_entry
 o enhance the readahead flow for CP/NAT/SIT/SSA blocks

The other bug fixes are as follows.
 o recover xattr node blocks correctly after sudden-power-cut
 o fix to calculate the maximum number of node ids
 o enhance to handle many error cases

And, there are a bunch of cleanups.

----------------------------------------------------------------
Changman Lee (1):
      f2fs: show counts of checkpoint in status

Chao Yu (18):
      f2fs: use inode mutex to keep atomicity of f2fs_falloc
      f2fs: introduce ra_meta_pages to readahead CP/NAT/SIT pages
      f2fs: readahead contiguous SSA blocks for f2fs_gc
      f2fs: use existing macro to clean up some codes
      f2fs: fix dirty page accounting when redirty
      f2fs: recover inline xattr data in roll-forward process
      f2fs: introduce f2fs_has_inline_xattr for better readability
      f2fs: check upper bound of ino value in f2fs_nfs_get_inode
      f2fs: print type for each segment in segment_info's show
      f2fs: introduce f2fs_has_xattr_block for better readability
      f2fs: avoid to return incorrect errno of read_normal_summaries
      f2fs: fix incorrect parsing with option string
      f2fs: avoid unnecessary bio submit when wait page writeback
      f2fs: avoid unneeded lookup when xattr name length is too long
      f2fs: avoid free slab cache under spinlock
      f2fs: use list_for_each_entry{_safe} for simplyfying code
      f2fs: fix error path when fail to read inline data
      f2fs: fix wrong statistics of inline data

Gu Zheng (5):
      f2fs: introduce help macro on_build_free_nids()
      f2fs: update start nid only once each circle
      f2fs: remove the unused ctor argument of f2fs_kmem_cache_create()
      f2fs: format segment_info's show for better legibility
      f2fs: optimize restore_node_summary slightly

Jaegeuk Kim (37):
      f2fs: update_inode_page should be done all the time
      f2fs: handle dirty segments inside refresh_sit_entry
      f2fs: fix to recover xattr node block
      f2fs: remove the ugly pointer conversion
      f2fs: fix the potential mismatch between dir's i_size and i_blocks
      f2fs: clean up with a macro
      f2fs: fix a build warning
      f2fs: fix to truncate dentry pages in the error case
      f2fs: fix f2fs_write_meta_page at no checkpoint status
      f2fs: clean up redundant function call
      f2fs: fix the calculation of max_nids
      f2fs: fix not to write data pages on the page reclaiming path
      f2fs: fix to do build_stat prior to the recovery procedure
      f2fs: fix to mark the checkpointed nat entry correctly
      f2fs: introduce a radix_tree for the free_nid list
      f2fs: implement a lock-free stat_show
      f2fs: remove costly bit operations for f2fs_find_entry
      f2fs: introduce large directory support
      f2fs: add an sysfs entry to control the directory level
      f2fs: fix to write node pages with WRITE_SYNC
      f2fs: fix wrong kernel coding style
      f2fs: introduce get_dirty_dents for readability
      f2fs: avoid small data writes by skipping writepages
      f2fs: increase pages_skipped when skipping writepages
      f2fs: introduce nr_pages_to_write for segment alignment
      f2fs: call f2fs_wait_on_page_writeback instead of native function
      f2fs: avoid to drop nat entries due to the negative nr_shrink
      f2fs: throttle the memory footprint with a sysfs entry
      f2fs: remove unnecessary threshold
      f2fs: add missing documentation for dir_level
      f2fs: change reclaim rate in percentage
      f2fs: introduce fi->i_sem to protect fi's info
      f2fs: skip unnecessary node writes during fsync
      f2fs: avoid RECLAIM_FS-ON-W warning
      f2fs: return -EIO when node id is not matched
      f2fs: fix to cover io->bio with io_rwsem
      f2fs: introduce f2fs_issue_flush to avoid redundant flush issue

ZhangZhen (1):
      f2fs: check the acl's validity before setting

 Documentation/ABI/testing/sysfs-fs-f2fs |  12 ++
 Documentation/filesystems/f2fs.txt      |  29 ++-
 fs/f2fs/acl.c                           |   8 +-
 fs/f2fs/checkpoint.c                    | 208 ++++++++++++++------
 fs/f2fs/data.c                          | 106 +++++-----
 fs/f2fs/debug.c                         |  12 +-
 fs/f2fs/dir.c                           |  85 ++++----
 fs/f2fs/f2fs.h                          | 105 +++++++---
 fs/f2fs/file.c                          |  31 ++-
 fs/f2fs/gc.c                            |  16 +-
 fs/f2fs/inline.c                        |   4 +-
 fs/f2fs/inode.c                         |  27 ++-
 fs/f2fs/namei.c                         |   9 +
 fs/f2fs/node.c                          | 334
+++++++++++++++++++-------------
 fs/f2fs/node.h                          |  25 ++-
 fs/f2fs/recovery.c                      |  37 ++--
 fs/f2fs/segment.c                       | 222 ++++++++++++++-------
 fs/f2fs/segment.h                       |  75 ++++---
 fs/f2fs/super.c                         |  97 ++++++----
 fs/f2fs/xattr.c                         |   7 +-
 include/linux/f2fs_fs.h                 |   2 +-
 21 files changed, 939 insertions(+), 512 deletions(-)


-- 
Jaegeuk Kim
Samsung

