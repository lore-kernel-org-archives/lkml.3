Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514Ab3AVDjl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 22:39:41 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:52380 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755594Ab3AVDjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 22:39:36 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-52-50fe09f6f720
Message-id: <1358825969.17605.6.camel@kjgkr>
Subject: [GIT PULL] f2fs fixes for v3.8-rc5
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Linux F2FS DEV, Mailing List" 
	<linux-f2fs-devel@lists.sourceforge.net>,
        "Linux FS DEV, Mailing List" <linux-fsdevel@vger.kernel.org>,
        "Linux Kernel, Mailing List" <linux-kernel@vger.kernel.org>
Date: Tue, 22 Jan 2013 12:39:29 +0900
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-XUtZs4emqGndQWLgi1AM"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjleLIzCtJLcpLzFFi42I5/e+Zge53zn8BBotbOC327D3JYnF51xw2
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDL2P53OVvBHseLrfdYGxqtSXYycHBICJhIzNj1kg7DF
	JC7cWw9kc3EICSxjlLg7aSszTNH6P8+YIRLTGSWOvuuFqnrNKPG8aQYjSBWvgI7Eme0PwWxh
	AW2JV33/WboYOTjYgOzN+w1AwkICihJv999lBbFFBIwkPr+4wgoyh1ngFKPE1TfnwBIsAqoS
	3U8ngp3ELyAqcbL1E9hMZoEqienfXkJdpCSxu72THWKvoMSPyfdYQAZJCBxjlzh9o5UFYpCA
	xLfJh8COkBCQldh0AKpXUuLgihssExhFZyEZOwvJKIi4pkTr9t/sELa2xLKFr5khbFuJdeve
	Q9XYSGy6uoARwpaX2P52DvMCRvZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGCFRJrWDcWWD
	xSFGAQ5GJR5ei0d/A4RYE8uKK3MPMaoAzXm0YfUFRimWvPy8VCUR3v5/QGnelMTKqtSi/Pii
	0pzU4kOMVUDPTWSWEk3OByaGvJJ4Q2NjEzMTUxNzS1NzU6oIK4nzMp56EiAkkJ5YkpqdmlqQ
	WgSznImDU6qBsW1Nd19g++mj0vZveHjYmpewLuNm981gybmjfyGHe0riqplXM214Dk/s0/1u
	Ol8ztFN05eIL03oXTNvzdnb83mfHjgS+uKTIY9halNF108+L+ZRL0Pz5f0+s4rnmNP3L1IZU
	/i5HTplS5lkZifK+T1kS/hyL3SCuMf/62grLSz+377CPYPlxQImlOCPRUIu5qDgRAFnxKkgZ	AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLKsWRmVeSWpSXmKPExsVy+t9jQd1vnP8CDGavMLLYs/cki8XlXXPY
	HJg8Pm+SC2CMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAEaraRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPM2P90OlvBH8WK
	r/dZGxivSnUxcnJICJhIrP/zjBnCFpO4cG89WxcjF4eQwHRGiaPveqGc14wSz5tmMIJU8Qro
	SJzZ/hDMFhbQlnjV95+li5GDgw3I3rzfACQsJKAo8Xb/XVYQW0TASOLziyusIHOYBU4xSlx9
	cw4swSKgKtH9dCIbiM0vICpxsvUT2ExmgSqJ6d9eQl2kJLG7vZMdYq+gxI/J91gmMPLPQlI2
	C0kKIq4p0br9NzuErS2xbOFrZgjbVmLduvdQNTYSm64uYISw5SW2v53DvICRfRWjaGpBckFx
	UnquoV5xYm5xaV66XnJ+7iZGcAw/k9rBuLLB4hCjAAejEg+vxaO/AUKsiWXFlbmHGFWA5jza
	sPoCoxRLXn5eqpIIb/8/oDRvSmJlVWpRfnxRaU5q8SHGiYxAb09klhJNzgcmnrySeENjEzMj
	SyMzCyMTc3NaCiuJ8zKeehIgJJCeWJKanZpakFoEcxQTB6dUA+OklNM7V4iflbFea6r7OEtF
	7OZp47cTyh/PYPk4dWb09af+D3XzAtcf9143LcpNNtdN2qDwUWdWP7dIVol5TdypDUX6dxhj
	NnalO3+X2OHHMrvhwlfXM0emTe9Z2t7DG1Vwu/cPT0lCU5ulntWJHev8pkd9U1GKs0w9zWl7
	lVN+47qvb56EFSqxFGckGmoxFxUnAgDo4JuEYAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-XUtZs4emqGndQWLgi1AM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please, pull f2fs bug fixes for v3.8-rc5.
Thanks,

The following changes since commit
5f738967e89584f99c6a11c6bf09b16c50b6a03e:

  Merge tag 'pinctrl-fixes' of
git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl
(2013-01-03 13:10:18 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs.git
tags/f2fs-for-3.8-rc5

for you to fetch changes up to d8b79b2f94600262fcfbffbe3df7fd3c83c6c51b:

  f2fs: use _safe() version of list_for_each (2013-01-22 10:49:00 +0900)

----------------------------------------------------------------
f2fs fixes for v3.8-rc5

o Support swap file and link generic_file_remap_pages
o Enhance the bio streaming flow and free section control
o One major bug fix on recovery routine
o Various minor bug/warning fixes and code cleanups

----------------------------------------------------------------
Dan Carpenter (1):
      f2fs: use _safe() version of list_for_each

Huajun Li (2):
      f2fs: update f2fs document to reflect SIT/NAT layout correctly
      f2fs: update f2fs partition info about SIT/NAT layout

Jaegeuk Kim (10):
      f2fs: initialize newly allocated dnode structure
      f2fs: avoid null dereference in f2fs_acl_from_disk
      f2fs: check return value during recovery
      f2fs: revisit the f2fs_gc flow
      f2fs: add f2fs_balance_fs in several interfaces
      f2fs: move f2fs_balance_fs to punch_hole
      f2fs: add remap_pages as generic_file_remap_pages
      f2fs: support swapfile
      f2fs: avoid issuing small bios due to several dirty node pages
      f2fs: add comments of start_bidx_of_node

Namjae Jeon (8):
      f2fs: introduce f2fs_msg to ease adding information prints
      f2fs: fix time update in case of f2fs fallocate
      f2fs: remove unneeded INIT_LIST_HEAD at few places
      f2fs: remove redundant call to set_blocksize in f2fs_fill_super
      f2fs: avoid redundant time update for parent directory in
f2fs_delete_entry
      f2fs: remove the blk_plug usage in f2fs_write_data_pages
      f2fs: fix the debugfs entry creation path
      f2fs: add __init to functions in init_f2fs_fs

majianpeng (1):
      f2fs: add global mutex_lock to protect f2fs_stat_list

 Documentation/filesystems/f2fs.txt | 18 +++----
 fs/f2fs/acl.c                      | 13 +++--
 fs/f2fs/checkpoint.c               |  3 +-
 fs/f2fs/data.c                     | 17 ++++++-
 fs/f2fs/debug.c                    | 50 +++++++++-----------
 fs/f2fs/dir.c                      |  2 +-
 fs/f2fs/f2fs.h                     | 18 ++++---
 fs/f2fs/file.c                     | 16 +++++--
 fs/f2fs/gc.c                       | 68 +++++++++++---------------
 fs/f2fs/inode.c                    |  3 ++
 fs/f2fs/node.c                     | 19 +++++---
 fs/f2fs/recovery.c                 | 10 ++--
 fs/f2fs/segment.c                  |  2 +-
 fs/f2fs/super.c                    | 97
++++++++++++++++++++++++++++----------
 fs/f2fs/xattr.c                    |  2 +
 15 files changed, 198 insertions(+), 140 deletions(-)


--=20
Jaegeuk Kim
Samsung

--=-XUtZs4emqGndQWLgi1AM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJQ/gnxAAoJEEAUqH6CSFDSME0P/i8M96XydjyVtaOy9GtLJNzj
Xzkk9wL/6733/nfoFvRFlFm4JuOwUZtZPj2Qr+rKHZNkSnlKMPdGgcLiLnfrlGKx
f23G/k4PL8oYhlGVezOaTMPtFqOWbqwIsfFskIBawIpsLPfFOBs3Vgy0eqy380Dl
1CGu0t8BueGPblej9nltxix02+nx9wGlo1trdkL7Xtw7CaBcD5l0ororB19YzhsO
n6+dUdI1Ud/mAnmzcDaO9OtdKC9hYkbQ/hBhSW02MneJAk5cN4SlhVwh6bGvvnEA
OZyipkFpL1zcSZcYEn1Jl2Cwn1Ai0nlOVVtxB9UZFeLKO+qOdf+0tkco/nLisefN
EYkuo7JNUo7Dei7ZxJ7TyeEgLiBrAhuxBFGSzXg7lwqIu5ZChKi1RRbr36g+YKZ7
foZ/xBhOBus9sUUMS2xV4RJepjwFJGqRPipv0CRIJbvwLBMeiZyuthmgBFLpJ1wf
h1zEdABcZkeG8YIh/fuDH1Ts7+rFKvSVYauL0C6ZCPlXy8nGw8oxeaRbrs7UK52M
/XJEtTpbnpW2GqIZmN43YqZZUVKSzMokFRv5mIE9pLbVyFzJARRzSJXENgnRq/Ec
1ow3IFmFFTMyiBI2iJ4qLtHqhfTDhRZ6CSYaa55sH/2WIfevj2++/HQt4vAEYGXU
Yk/WaYGxR8qeDREXFZjB
=uM3W
-----END PGP SIGNATURE-----

--=-XUtZs4emqGndQWLgi1AM--

