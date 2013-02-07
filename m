Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758676Ab3BGAVj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 19:21:39 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:36516 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758552Ab3BGAVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 19:21:33 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-ec-5112f38b2d0c
Message-id: <1360196464.26950.65.camel@kjgkr>
Subject: [GIT PULL] f2fs fixes for v3.8-rc7
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Linux F2FS DEV, Mailing List" 
	<linux-f2fs-devel@lists.sourceforge.net>,
        "Linux Kernel, Mailing List" <linux-kernel@vger.kernel.org>,
        "Linux FS DEV, Mailing List" <linux-fsdevel@vger.kernel.org>
Date: Thu, 07 Feb 2013 09:21:04 +0900
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-+mUHQeMJI66asyW5L+Kj"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjleLIzCtJLcpLzFFi42I5/e+Zvm73Z6FAgxd/zC327D3JYnF51xw2
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDI2Ld7OVLBLueLh1KdsDYzTZLsYOTkkBEwktnzdxg5h
	i0lcuLeerYuRi0NIYBmjxM1fr5hgimZ/uMQOkVjEKPHzxGsWCOc1o8TDx3dYQKp4BXQlju16
	AdTOwSEsoC3RfdobxGQDMjfvNwCpEBJQlHi7/y4riC0iYCTx+cUVVpAxzAKnGCV2/XkPlmAR
	UJWYcLsFbCS/gKjEydZPjCA2s0CVxPWVp1khDlKS2N3eyQ6xVlDix+R7YPdICBxjl7jxqZkF
	YpCAxLfJh1hAjpAQkJXYdIAZoldS4uCKGywTGEVnIRk7C8koiLimROv23+wQtrbEsoWvmSFs
	W4l1695D1dhIbLq6gBHClpfY/nYO8wJG9lWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYIVEm
	tYNxZYPFIUYBDkYlHt4bS4UChVgTy4orcw8xqgDNebRh9QVGKZa8/LxUJRHe7KdAad6UxMqq
	1KL8+KLSnNTiQ4xVQM9NZJYSTc4HJoa8knhDY2MTMxNTE3NLU3NTqggrifMynnoSICSQnliS
	mp2aWpBaBLOciYNTCph8lq7a3RV67OZ0RnFTgyuOG4uLdf2Pmb7es4zr42rZ1DDhcI6uOZJV
	XSIdvyo/zk/f6+Tq+FdCT/NYctPBiydb7k166d9zYg3v4sknmX5FtT01zjJ4t3GaYfK+U0Hs
	W+10jlx0e2D46XYnC6vU8qPbN7qbqOjta/WOmBDq9/qNxhYNr6mpIpeVWIozEg21mIuKEwHP
	BvkMGQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLKsWRmVeSWpSXmKPExsVy+t9jAd3uz0KBBgufGFjs2XuSxeLyrjls
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmbFq8nalgl3LF
	w6lP2RoYp8l2MXJySAiYSMz+cIkdwhaTuHBvPVsXIxeHkMAiRomfJ16zQDivGSUePr7DAlLF
	K6ArcWzXC6AqDg5hAW2J7tPeICYbkLl5vwFIhZCAosTb/XdZQWwRASOJzy+usIKMYRY4xSix
	6897sASLgKrEhNstYCP5BUQlTrZ+YgSxmQWqJK6vPM0KcZCSxO72TnaItYISPybfY5nAyD8L
	SdksJCmIuKZE6/bf7BC2tsSyha+ZIWxbiXXr3kPV2EhsurqAEcKWl9j+dg7zAkb2VYyiqQXJ
	BcVJ6bmGesWJucWleel6yfm5mxjBMfxMagfjygaLQ4wCHIxKPLw3lgoFCrEmlhVX5h5iVAGa
	82jD6guMUix5+XmpSiK82U+B0rwpiZVVqUX58UWlOanFhxgnMgK9PZFZSjQ5H5h48kriDY1N
	zIwsjcwsjEzMzWkprCTOy3jqSYCQQHpiSWp2ampBahHMUUwcnFINjBc9JP+qq7pJP3T69PDH
	a6EbU8MdJ8quvyb9oTNnCYPg9I/sqV/cnGOmcHl6pVo8+3hcQOfEYxttscgl2d5eilNLu4zS
	vjxbYxQg028Rcfvd+db7t6aWOB3o89tbci5S51bio3/qwXysL4/fu6zz52pMkLLQp3MN0vck
	73UpG3omN8+u+WyzW4mlOCPRUIu5qDgRAIrA1ZZgAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-+mUHQeMJI66asyW5L+Kj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Here are four patches which are critical bug fixes on f2fs, three
enhancement patches, and a number of trivial patches.
Please pull the following tag. Sorry for the late request.

Thanks,

The following changes since commit
6abb7c25775b7fb2225ad0508236d63ca710e65f:

  Merge tag 'regulator-3.8-rc5' of
git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator
(2013-01-28 22:44:53 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs.git
tags/f2fs-for-v3.8

for you to fetch changes up to 1efc6d3277f59b764384781c0f8dfc821f229380:

  f2fs: add compat_ioctl to provide backward compatability (2013-02-06
17:38:59 +0900)

----------------------------------------------------------------
f2fs fixes for v3.8

[Major bug fixes]
o Store device file information correctly
o Fix -EIO handling with respect to power-off-recovery
o Allocate blocks with global locks
o Fix wrong calculation of the SSR cost

[Enhancement]
o Support (un)freeze_fs
o Enhance the f2fs_gc flow
o Support 32-bit binary execution on 64-bit kernel

----------------------------------------------------------------
Alejandro Martinez Ruiz (1):
      f2fs: fix disable_ext_identify option spelling

Changman Lee (5):
      f2fs: save device node number into f2fs_inode
      f2fs: add un/freeze_fs into super_operations
      f2fs: stop repeated checking if cp is needed
      f2fs: remove repeated F2FS_SET_SB_DIRT call
      f2fs: remove unnecessary gc option check and balance_fs

Jaegeuk Kim (6):
      f2fs: prevent checkpoint once any IO failure is detected
      f2fs: cover global locks for reserve_new_block
      f2fs: remove the use of page_cache_release
      f2fs: avoid balanc_fs during evict_inode
      f2fs: clarify and enhance the f2fs_gc flow
      f2fs: fix calculation of max. gc cost in the SSR case

Namjae Jeon (8):
      f2fs: avoid redundant call to has_not_enough_free_secs in f2fs_gc
      f2fs: reorganize code for ra_node_page
      f2fs: fix typo mistake for data_version description
      f2fs: name gc task as per the block device
      f2fs: mark gc_thread as NULL when thread creation is failed
      f2fs: make an accessor to get sections for particular block type
      f2fs: optimize the return condition for has_not_enough_free_secs
      f2fs: add compat_ioctl to provide backward compatability

majianpeng (4):
      f2fs: clean up the add_orphan_inode func
      f2fs: add device name in debugfs
      f2fs: use F2FS_BLKSIZE to judge bloksize and page_cache_size
      f2fs: when check superblock failed, try to check another
superblock

 fs/f2fs/checkpoint.c |  63 +++++++++++---------------
 fs/f2fs/debug.c      |   4 +-
 fs/f2fs/f2fs.h       |  32 ++++++++++---
 fs/f2fs/file.c       |  35 ++++++++++++---
 fs/f2fs/gc.c         | 124
++++++++++++++++++++++-----------------------------
 fs/f2fs/gc.h         |  21 ---------
 fs/f2fs/inode.c      |  53 +++++++++-------------
 fs/f2fs/node.c       |  14 +++---
 fs/f2fs/recovery.c   |   4 +-
 fs/f2fs/segment.c    |  29 ++++++++----
 fs/f2fs/segment.h    |  23 +++-------
 fs/f2fs/super.c      |  92 +++++++++++++++++++++++++++++---------
 12 files changed, 262 insertions(+), 232 deletions(-)

--=20
Jaegeuk Kim
Samsung

--=-+mUHQeMJI66asyW5L+Kj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJREvNwAAoJEEAUqH6CSFDSDU4P/jlo85z2ymk5oBboD2xs3FTn
dDuaU0PjP6GslrA5yfMnDWWqxDi+m5jJDA/jNzKmYwyn+0EOyuM2MANT9dKpn17h
TH5ac7T3yLnUq0zyGYyDPGOQvlcdm1iXJsvwECLclLqHYzFh9K1n1mgjU/ToVv/z
7PvZdh8aPL3qNgRwf86Er5QfCI+o0WaO+VM/4JHyj94tcuo3QsXKjS+j0TTu1ttt
4zoXBVd5IENuQwHN01O7JlB9Lv4PXsKkAsS/eguL2BMYyccRxWTH3CBLZi2/roNo
R+RvAKNNfSi3m7wpY+GUODXncod4powGTHakUJheOMHMKRjRA4oQb8sB9kzSGYbL
gxnurHNGw9CD7uZ7XaooJablp4duGyvEuA2u/ovGQjKPYqZvZwudQrWqPBFHoivB
7eZsHUXSYuE6SDd3HHJO1bgmbF2yacNPKRwrNuKzyicwajAMS1eHrzL8olRJvbfi
wDW5x/ANKFLWE6MgtEIeFw9aiEnodp2NLgWOpU4PI6/EAaQSghGrb1JWtySwRJTE
iZ//V+WVT0h4VjTgZ9hPdQFzIuuMx5q9qCF1zME8ZQhypIO86oFUM2wYGr0YIUe9
/L13MJO6GDRbrJMa0dDNEK7jKNnT03bdShhyX1imc5JXB9m2LRv8hbtdA68W7G1i
SuUx2wVjqx2Jr7X8gO60
=KrOj
-----END PGP SIGNATURE-----

--=-+mUHQeMJI66asyW5L+Kj--

