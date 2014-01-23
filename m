Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417AbaAWB4p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 20:56:45 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:12762 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbaAWB4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 20:56:42 -0500
X-AuditID: cbfee68f-b7f156d00000276c-89-52e076d3d616
Message-id: <1390442113.25542.11.camel@kjgkr>
Subject: [GIT PULL] f2fs updates for v3.14
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Linux F2FS DEV, Mailing List" 
	<linux-f2fs-devel@lists.sourceforge.net>,
        "Linux FS DEV, Mailing List" <linux-fsdevel@vger.kernel.org>,
        "Linux Kernel, Mailing List" <linux-kernel@vger.kernel.org>
Date: Thu, 23 Jan 2014 10:55:13 +0900
Organization: Samsung
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCIsWRmVeSWpSXmKPExsVy+t8zA93LZQ+CDC6el7O4tMjdYs/ekywW
	l3fNYbN41PeW3YHF48SM3yweuxd8ZvL4vEkugDmKyyYlNSezLLVI3y6BK+PTj6iCnc4V03t7
	2RsY7xt0MXJySAiYSJy50c8GYYtJXLi3Hsjm4hASWMYo0TF3IitM0apV6xkhEtMZJbbveM0K
	4bxklLg47yELSBWvgK7EydaXTCC2sICWxNvbR4GKODjYBLQlNu8H2yYkoCjxdv9dsKEiAkYS
	n19cAZvDLHCKUeLqm3NgCRYBVYmjXXeZQWx+AVGJwwu3g9nMAuoSk+YtYoa4SElid3snO0Rc
	XmLzmrfMEDcISvyYfI8FZKiEwCp2iT0rrzNDDBWQ+Db5EAvIQRICshKbDkDNkZQ4uOIGywRG
	sVlIVsxCMnYWkrELGJlXMYqmFiQXFCelFxnrFSfmFpfmpesl5+duYoTEUP8OxrsHrA8xJgOt
	nMgsJZqcD4zBvJJ4Q2MzIwtTE1NjI3NLM9KElcR57z9MChISSE8sSc1OTS1ILYovKs1JLT7E
	yMTBKdXAaDpzYqGeXN+qDenZdcmTHgcu+XbxsDK/6f9L3QfuruIJv5s6I+s71+z6zRt41C9U
	bfqrsyVB91zR+/Oi734x3rl01FdJ6JeOzUb2CV2LPLYZxufFPeyYM0Pwp1jUErPCqOLb/VM5
	QptVWWbrOCWf0Uh9Eio6Jeqkecbazxr1oaf0M8x5P95rVGIpzkg01GIuKk4EAECHop63AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkleLIzCtJLcpLzFFi42I5/e+xoO7lsgdBBvuXS1lcWuRusWfvSRaL
	y7vmsFk86nvL7sDicWLGbxaP3Qs+M3l83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5jx6UdUwU7nium9vewNjPcNuhg5OSQETCRWrVrPCGGLSVy4t56ti5GLQ0hg
	OqPE9h2vWSGcl4wSF+c9ZAGp4hXQlTjZ+pIJxBYW0JJ4e/soUBEHB5uAtsTm/WBDhQQUJd7u
	v8sKYosIGEl8fnEFbA6zwClGiatvzoElWARUJY523WUGsfkFRCUOL9wOZjMLqEtMmreIGeIi
	JYnd7Z3sEHF5ic1r3jJD3CAo8WPyPZYJjAKzkLTMQlI2C0nZAkbmVYyiqQXJBcVJ6bmGesWJ
	ucWleel6yfm5mxjBEfpMagfjygaLQ4wCHIxKPLwJX+4HCbEmlhVX5h5ilOBgVhLhPZn0IEiI
	NyWxsiq1KD++qDQntfgQYzLQFxOZpUST84HJI68k3tDYxMzI0sjMwsjE3Jw0YSVx3gOt1oFC
	AumJJanZqakFqUUwW5g4OKUaGENj5IJbKxV0p3KHXblxmC/jlmPJ89bzm5Yc6ZVasmhBf+9E
	75Q/pWKuN18Z1lzYzxfzZpHvDNWtybPsf/hlNuXpfn/rqi2q+FtP6/39RwFnfH+sNrq65qVu
	rNTyKzwpU3Q8PvrIb7Htq913KrFITKS9fOrW+6em7q+Z0c90WTd9muqCxNXLEpRYijMSDbWY
	i4oTAfj69wsUAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is a pull request on f2fs updates for v3.14.

In this round, a couple of sysfs entries were introduced to tune the
f2fs at runtime.
In addition, f2fs starts to support inline_data and improves the
read/write performance in some workloads by refactoring bio-related
flows.
This patch-set also includes a number of clean-ups and several bug
fixes.

Thank you very much.

The following changes since commit
413541dd66d51f791a0b169d9b9014e4f56be13c:

  Linux 3.13-rc5 (2013-12-22 13:08:32 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs.git
tags/for-f2fs-3.14

for you to fetch changes up to bf39c00a9a7f3cdb5ce7d6695d9f044daf8f0b53:

  f2fs: drop obsolete node page when it is truncated (2014-01-23
08:04:21 +0900)

----------------------------------------------------------------
f2fs updates for v3.14

This patch-set includes the following major enhancement patches.
o support inline_data
o refactor bio operations such as merge operations and rw type
assignment
o enhance the direct IO path
o enhance bio operations
o truncate a node page when it becomes obsolete
o add sysfs entries: small_discards, max_victim_search, and
in-place-update
o add a sysfs entry to control max_victim_search

The other bug fixes are as follows.
o fix a bug in truncate_partial_nodes
o avoid warnings during sparse and build process
o fix error handling flows
o fix potential bit overflows

And, there are a bunch of cleanups.

----------------------------------------------------------------
Changman Lee (7):
      f2fs: introduce __find_rev_next(_zero)_bit
      f2fs: improve searching speed of __next_free_blkoff
      f2fs: simplify IS_DATASEG and IS_NODESEG macro
      f2fs: send REQ_META or REQ_PRIO when reading meta area
      f2fs: missing kmem_cache_destroy for discard_entry
      f2fs: add delimiter to seperate name and value in debug phrase
      f2fs: missing REQ_META and REQ_PRIO when
sync_meta_pages(META_FLUSH)

Chao Yu (20):
      f2fs: use f2fs_put_page to release page for uniform style
      f2fs: add a new function to support for merging contiguous read
      f2fs: adds a tracepoint for submit_read_page
      f2fs: adds a tracepoint for f2fs_submit_read_bio
      f2fs: read contiguous sit entry pages by merging for mount
performance
      f2fs: remove unneeded code in punch_hole
      f2fs: avoid to calculate incorrect max orphan number
      f2fs: correct type of wait in struct bio_private
      f2fs: use true and false for boolean variable
      f2fs: check return value of f2fs_readpage in find_data_page
      f2fs: convert recover_orphan_inodes to void
      f2fs: readahead contiguous pages for restore_node_summary
      f2fs: use inner macro GFP_F2FS_ZERO for simplification
      f2fs: avoid unneeded page release for correct _count of page
      f2fs: add unlikely() macro for compiler optimization
      f2fs: update several comments
      f2fs: avoid to set wrong pino of inode when rename dir
      f2fs: check filename length in recover_dentry
      f2fs: avoid to left uninitialized data in page when read inline
data
      f2fs: avoid to read inline data except first page

Chris Fries (1):
      f2fs: clean checkpatch warnings

Fan Li (1):
      f2fs: merge pages with the same sync_mode flag

Gu Zheng (14):
      f2fs: convert remove_inode_page to void
      f2fs: convert dev_valid_block_count to void
      f2fs: convert inc/dec_valid_node_count to inc/dec one count
      f2fs: simplify write_orphan_inodes for better readable
      f2fs: move the list_head initialization into the lock protection
region
      f2fs: fix a potential out of range issue
      f2fs: move all the bio initialization into __bio_alloc
      f2fs: remove the rw_flag domain from f2fs_io_info
      f2fs: convert max_orphans to a field of f2fs_sb_info
      f2fs: move grabing orphan pages out of protection region
      f2fs: move alloc new orphan node out of lock protection region
      f2fs: use spinlock rather than mutex for better speed
      f2fs: add help function META_MAPPING
      f2fs: remove the orphan block page array

Huajun Li (6):
      f2fs: add a new function: f2fs_reserve_block()
      f2fs: add flags and helpers to support inline data
      f2fs: add a new mount option: inline_data
      f2fs: key functions to handle inline data
      f2fs: handle inline data operations
      f2fs: update f2fs Documentation

Jaegeuk Kim (42):
      f2fs: add a slab cache entry for small discards
      f2fs: add key functions for small discards
      f2fs: add a sysfs entry to control max_discards
      f2fs: introduce f2fs_issue_discard() to clean up
      f2fs: add a tracepoint for f2fs_issue_discard
      f2fs: clean up the do_submit_bio flow
      f2fs: use sbi->write_mutex for write bios
      f2fs: disable the extent cache ops on high fragmented files
      f2fs: introduce a bio array for per-page write bios
      f2fs: merge read IOs at ra_nat_pages()
      f2fs: avoid lock debugging overhead
      f2fs: add detailed information of bio types in the tracepoints
      f2fs: remove unnecessary return value
      f2fs: bug fix on bit overflow from 32bits to 64bits
      f2fs: remove unnecessary condition checks
      f2fs: remove the own bi_private allocation
      f2fs: refactor bio-related operations
      f2fs: add unlikely() macro for compiler more aggressively
      f2fs: refactor bio->rw handling
      f2fs: fix the location of tracepoint
      f2fs: introduce sysfs entry to control in-place-update policy
      f2fs: introduce a new direct_IO write path
      f2fs: write dirty meta pages collectively
      f2fs: add description about small_discards in document
      f2fs: introduce F2FS_INODE macro to get f2fs_inode
      f2fs: should put the dnode when NEW_ADDR is detected
      f2fs: check the blocksize before calling generic_direct_IO path
      f2fs: don't need to get f2fs_lock_op for the inline_data test
      f2fs: convert inline_data for punch_hole
      f2fs: call f2fs_put_page at the error case
      f2fs: refactor f2fs_convert_inline_data
      f2fs: add the number of inline_data files to status info
      f2fs: add inline_data recovery routine
      f2fs: handle errors correctly during f2fs_reserve_block
      f2fs: improve write performance under frequent fsync calls
      f2fs: add a sysfs entry to control max_victim_search
      f2fs: update documents and a MAINTAINERS entry
      f2fs: avoid f2fs_balance_fs call during pageout
      f2fs: call mark_inode_dirty to flush dirty pages
      f2fs: move a branch for code redability
      f2fs: introduce NODE_MAPPING for code consistency
      f2fs: drop obsolete node page when it is truncated

Younger Liu (2):
      f2fs: remove debufs dir if debugfs_create_file() failed
      f2fs: replace the debugfs_root with f2fs_debugfs_root

Yuan Zhong (1):
      f2fs: remove the needless parameter of f2fs_wait_on_page_writeback

shifei10.ge (1):
      f2fs: fix truncate_partial_nodes bug

 Documentation/ABI/testing/sysfs-fs-f2fs |  31 ++
 Documentation/filesystems/f2fs.txt      |  24 ++
 MAINTAINERS                             |   1 +
 fs/f2fs/Makefile                        |   2 +-
 fs/f2fs/checkpoint.c                    | 195 +++++-----
 fs/f2fs/data.c                          | 621
++++++++++++++++++++++++--------
 fs/f2fs/debug.c                         |  53 ++-
 fs/f2fs/dir.c                           |  47 +--
 fs/f2fs/f2fs.h                          | 195 +++++++---
 fs/f2fs/file.c                          |  84 ++---
 fs/f2fs/gc.c                            |  22 +-
 fs/f2fs/gc.h                            |   2 +-
 fs/f2fs/inline.c                        | 222 ++++++++++++
 fs/f2fs/inode.c                         |  23 +-
 fs/f2fs/namei.c                         |   5 +
 fs/f2fs/node.c                          | 272 ++++++++------
 fs/f2fs/node.h                          |   8 +-
 fs/f2fs/recovery.c                      |  49 ++-
 fs/f2fs/segment.c                       | 584
+++++++++++++++++++-----------
 fs/f2fs/segment.h                       |  81 +++--
 fs/f2fs/super.c                         |  72 +++-
 fs/f2fs/xattr.c                         |   2 +-
 include/linux/f2fs_fs.h                 |   7 +
 include/trace/events/f2fs.h             | 107 ++++--
 24 files changed, 1884 insertions(+), 825 deletions(-)
 create mode 100644 fs/f2fs/inline.c

-- 
Jaegeuk Kim
Samsung

