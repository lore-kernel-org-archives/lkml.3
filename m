Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922Ab3GBAvd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 20:51:33 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:10716 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304Ab3GBAvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 20:51:31 -0400
X-AuditID: cbfee691-b7fef6d000002d62-49-51d22411bfa3
Message-id: <1372726289.736.22.camel@kjgkr>
Subject: [GIT PULL] f2fs updates for v3.11
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Linux Kernel, Mailing List" <linux-kernel@vger.kernel.org>,
        "Linux FS DEV, Mailing List" <linux-fsdevel@vger.kernel.org>,
        "Linux F2FS DEV, Mailing List" 
	<linux-f2fs-devel@lists.sourceforge.net>
Date: Tue, 02 Jul 2013 09:51:29 +0900
Organization: Samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-Rjio3iB0AEcgmA7Lp6NH"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPIsWRmVeSWpSXmKPExsVy+t8zfV1BlUuBBt2TlSwuLXK32LP3JIvF
	5V1z2Cwe9b1ld2DxODHjN4vH7gWfmTw+b5ILYI7isklJzcksSy3St0vgyjjVeYa1YJFFxb3X
	DewNjP3aXYycHBICJhJL751mhLDFJC7cW8/WxcjFISSwjFFi++Ur7F2MHGBFu/+LQMQXMUo8
	27KfFcJ5zSjx9t9EdpBuXgFtic8PzzCD2MICWhKrLrxnAWlmA4pv3m8AEhYSUJR4u/8uK4gt
	ImAk8fnFFbA5zAKnGCWWf/gF1ssioCpx7O50NhCbX0BU4vDC7WBxZoEqifknL0FdqiSxu70T
	aq+gxI/J91hABkkIPGKX+HK6mwVikIDEt8mHWCA+kJXYdIAZoldS4uCKGywTGEVnIRk7C8ko
	iLimROv23+wQtrbEsoWvmSFsW4l1695D1dhIbLq6gBHClpfY/nYO8wJG9lWMoqkFyQXFSelF
	pnrFibnFpXnpesn5uZsYIbE4cQfj/QPWhxirgE6cyCwlmpwPjOW8knhDYzMjC1MTU2Mjc0sz
	qggrifOqt1gHCgmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamAs48/h8eNS0U538n69LKNu8ULG
	jEOObSu55OM3FWQFHWv+f6JgbmVFkbl7tHGXzq8PLUrnW0Ul+tJ/Hl1rysdSsvTNBaupDffN
	HC8UbvwUYbhmttTG+jObPDQW3L/Urv5/0e8LbCdFN3C7XeFhTZb3/fv62EYeTQnND+eUnu/t
	XaayyLR+5U8lluKMREMt5qLiRAC8Jr3W8gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAKsWRmVeSWpSXmKPExsVy+t9jAV1BlUuBBndfy1hcWuRusWfvSRaL
	y7vmsFk86nvL7sDicWLGbxaP3Qs+M3l83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5hxqvMMa8Eii4p7rxvYGxj7tbsYOTgkBEwkdv8X6WLkBDLFJC7cW8/WxcjF
	ISSwiFHi2Zb9rBDOa0aJt/8msoNU8QpoS3x+eIYZxBYW0JJYdeE9C8ggNqD45v0GIGEhAUWJ
	t/vvsoLYIgJGEp9fXAGbwyxwilFi+YdfYL0sAqoSx+5OZwOx+QVEJQ4v3A4WZxaokph/8hIj
	xEVKErvbO6H2Ckr8mHyPZQIj/ywkZbOQpCDimhKt23+zQ9jaEssWvmaGsG0l1q17D1VjI7Hp
	6gJGCFteYvvbOcwLGNlXMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgRH+jOpHYwrGywOMQpw
	MCrx8CrMuxgoxJpYVlyZe4hRBWjOow2rLzBKseTl56UqifDe9AZK86YkVlalFuXHF5XmpBYf
	YpzICPT2RGYp0eR8YHrKK4k3NDYxM7I0MrMwMjE3p6WwkjjvgVbrQCGB9MSS1OzU1ILUIpij
	mDg4pRoYG4Oubd6z6ta6lEc85oE+sVc+pTxoX8dW3vdzxxVbvn83Hu+b+O1xg9mpHS2nN5d0
	2hYdPBMZ0aJXpsDEc1SCa2ML65VZZffjP/Q/VhEIXelVzOK7V0pm7dl/526vN24zquxc8rqz
	6t3d/osGyoJa70rDf4tcXFix8Y5N02+hBRubG4MKn75fosRSnJFoqMVcVJwIAJp36/hzAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Rjio3iB0AEcgmA7Lp6NH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Here is the pull request on f2fs updates for v3.11.
Most of patches in this patch-set have been proposed to fix the
roll-forward mechanism significantly.

One of major fixes is related to little and big endian conversion, and
its errorneous symptom on powerpc was initially reported by Oded Gabbay.

Another one is that it has been revealed the pgbench regression reported
by phoronix was caused by one of fsync bug fixes in 3.10-rc1. In order
to restore the performance, one enhancement patch was introduced in this
patch-set, which is f2fs: recover wrong pino after checkpoint during
fsync.

One of new features is *xattr security labels* which is essential to the
SEandroid system.

Please consider pulling the following tag.
Thank you,

The following changes since commit
e4aa937ec75df0eea0bee03bffa3303ad36c986b:

  Linux 3.10-rc3 (2013-05-26 16:00:47 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs.git
tags/for-f2fs-3.11

for you to fetch changes up to a1dd3c13ce65b726fddfe72b9d2f1009db983ce6:

  f2fs: fix to recover i_size from roll-forward (2013-07-02 08:48:16
+0900)

----------------------------------------------------------------
This patch-set includes the following major enhancement patches.
 o remount_fs callback function
 o restore parent inode number to enhance the fsync performance
 o xattr security labels
 o reduce the number of redundant lock/unlock data pages
 o avoid frequent write_inode calls

The other minor bug fixes are as follows.
 o endian conversion bugs
 o various bugs in the roll-forward recovery routine

----------------------------------------------------------------
Dan Carpenter (1):
      f2fs: dereferencing an ERR_PTR

Gu Zheng (3):
      f2fs: set sb->s_fs_info before calling parse_options()
      f2fs: code cleanup and simplify in func {find/add}_gc_inode
      f2fs: remove the unused argument "sbi" of func
destroy_fsync_dnodes()

Haicheng Li (4):
      f2fs: remove unecessary variable and code
      f2fs: remove unnecessary parameter "offset" from __add_sum_entry()
      f2fs: make locate_dirty_segment() as static
      f2fs: optimize do_write_data_page()

Jaegeuk Kim (35):
      f2fs: fix inconsistency of block count during recovery
      f2fs: fix the inconsistent state of data pages
      f2fs: remove redundant assignment
      f2fs: fix por_doing variable coverage
      f2fs: fix BUG_ON during f2fs_evict_inode(dir)
      f2fs: remove unnecessary por_doing check
      f2fs: skip get_node_page if locked node page is passed
      f2fs: change get_new_data_page to pass a locked node page
      f2fs: update inode page after creation
      f2fs: add debug msgs in the recovery routine
      f2fs: remove unnecessary kmap/kunmap operations
      f2fs: fix to unlock page before exit
      f2fs: don't do checkpoint if error is occurred
      f2fs: avoid RECLAIM_FS-ON-W: deadlock
      f2fs: add f2fs_readonly()
      f2fs: fix wrong condition check
      f2fs: reuse the locked dnode page and its inode
      f2fs: fix to handle do_recover_data errors
      f2fs: should not make_bad_inode on f2fs_link failure
      f2fs: use ihold
      f2fs: align data types between on-disk and in-memory block
addresses
      f2fs: iput only if whole data blocks are flushed
      f2fs: fix dentry recovery routine
      f2fs: fix incorrect iputs during the dentry recovery
      f2fs: cover cp_file information with ilock
      f2fs: fix iget/iput of dir during recovery
      f2fs: support xattr security labels
      f2fs: fix i_blocks translation on various types of files
      f2fs: sync dir->i_size with its block allocation
      f2fs: avoid freqeunt write_inode calls
      f2fs: recover wrong pino after checkpoint during fsync
      f2fs: fix crc endian conversion
      f2fs: fix an endian conversion bug detected by sparse
      f2fs: remove reusing any prefree segments
      f2fs: fix to recover i_size from roll-forward

Jason Hrycay (1):
      f2fs: handle errors from get_node_page calls

Namjae Jeon (10):
      f2fs: reorganize f2fs_vm_page_mkwrite
      f2fs: push some variables to debug part
      f2fs: remove unneeded initializations in f2fs_parent_dir
      f2fs: optimize several routines in node.h
      f2fs: return proper error from start_gc_thread
      f2fs: reorganise the function get_victim_by_default
      f2fs: use the F2FS specific flags in f2fs_ioctl()
      f2fs: optimise the truncate_data_blocks_range() range
      f2fs: add remount_fs callback support
      f2fs: optimize the init_dirty_segmap function

Peter Zijlstra (1):
      f2fs, lockdep: annotate mutex_lock_all()

majianpeng (1):
      f2fs: use list_for_each_entry rather than list_for_each_entry_safe

 Documentation/filesystems/f2fs.txt |   9 +-
 fs/f2fs/Kconfig                    |  12 ++
 fs/f2fs/acl.c                      |   2 +-
 fs/f2fs/checkpoint.c               |  99 +++++++++++----
 fs/f2fs/data.c                     |  68 +++++++---
 fs/f2fs/debug.c                    |   4 +-
 fs/f2fs/dir.c                      | 109 +++++++++-------
 fs/f2fs/f2fs.h                     |  66 +++++++---
 fs/f2fs/file.c                     |  58 +++++++--
 fs/f2fs/gc.c                       |  42 +++---
 fs/f2fs/inode.c                    |  13 +-
 fs/f2fs/namei.c                    |  17 +--
 fs/f2fs/node.c                     |  34 ++---
 fs/f2fs/node.h                     |  68 ++++------
 fs/f2fs/recovery.c                 | 150 ++++++++++++++--------
 fs/f2fs/segment.c                  | 101 ++++-----------
 fs/f2fs/super.c                    | 253
++++++++++++++++++++++++-------------
 fs/f2fs/xattr.c                    |  68 +++++++++-
 fs/f2fs/xattr.h                    |  24 ++--
 include/linux/f2fs_fs.h            |   4 +-
 20 files changed, 750 insertions(+), 451 deletions(-)

--=20
Jaegeuk Kim
Samsung

--=-Rjio3iB0AEcgmA7Lp6NH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJR0iQRAAoJEEAUqH6CSFDSwK0QAI5SscUdvfoqPLsSVdER+nwS
ZJOCYMQZvu9GXJYeCfPGFhUk4uwmxZSXrphVdyarQq2EXABuxWNBrDOfxxi9MQpi
aZP+23CgruMRvW/KLqG+447bLUnjYWvJsqeqRcxnBDnJytFHYWLR2+kZscmmiPsN
QefOT1ZG3/86KvIrFFbipHEKJJZKJ92OaxcmAOkcW/FMp/MlJucM6Rw2oqKolfLE
ifu6sPtXSq8Pnlj4ET6PpsQ1gfvb7kOzV3sMfQtN9amaq1Jbhixdbcw7FxB5knYC
lsjzi4HqFClXTgVrj7WcjUIHTMXlRzSYIqKhMV9dr/m8lSc/v8s4IoR6r7A1S7Yk
71GGLwXhehJ4fy0rAbDC7nACSwUUV80v6dEZ8RRm09x//d9QPHMQo/SGv6OmZFjT
jONBfIZe+2eJmTYpw8DKvJnasGTTgT4zjTX8nEOCvzSemY6KUpuoHxbaznsbqa6K
RHDB+mG3eM1D6MrPxRSsRKlBhFVdImstJ+L9ma5ChpZVbJbxiRUOuYdpd+ZdoQqE
p96CZXU9xl+V3yQ7hbFZ/hQp+jkKbK2N6rUVYxk005Mg8IAXtYcgdlwFyF3LpJo1
dE+1tzvLd3sXXZCSaWe1iAHzEIzZOSZYhvt+o2EpA3+Hop3fwkISDXoweW26+Izb
zAqGGXeMO2l4bgnVE1fu
=FBwl
-----END PGP SIGNATURE-----

--=-Rjio3iB0AEcgmA7Lp6NH--

