Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923Ab3GJRzE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 13:55:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36967 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754769Ab3GJRzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 13:55:01 -0400
Date: Wed, 10 Jul 2013 10:54:55 -0700
From: Tyler Hicks <tyhicks@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        ecryptfs@vger.kernel.org
Subject: [GIT PULL] eCryptfs updates for 3.11-rc1
Message-ID: <20130710175441.GA15884@boyd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit e8193ce572f0ddb8004acf976bba119f0abbe6ca:

  Merge tag 'rdma-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband (2013-06-07 16:29:21 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/tyhicks/ecryptfs.git tags/ecryptfs-3.11-rc1-cleanup

for you to fetch changes up to cc18ec3c8f5dd735c1bff5da30fd33860c08a293:

  Use ecryptfs_dentry_to_lower_path in a couple of places (2013-07-09 23:40:28 -0700)

----------------------------------------------------------------
Code cleanups and improved buffer handling during page crypto operations
- Remove redundant code by merging some encrypt and decrypt functions
- Get rid of a helper page allocation during page decryption by using in-place
  decryption
- Better use of entire pages during page crypto operations
- Several code cleanups

----------------------------------------------------------------
Matthew Wilcox (1):
      Use ecryptfs_dentry_to_lower_path in a couple of places

Thomas Meyer (1):
      eCryptfs: Cocci spatch "memdup.spatch"

Tyler Hicks (10):
      eCryptfs: Use entire helper page during page crypto operations
      eCryptfs: Read/write entire page during page IO
      eCryptfs: Simplify lower file offset calculation
      eCryptfs: Accept one offset parameter in page offset crypto functions
      eCryptfs: Decrypt pages in-place
      eCryptfs: Combine encrypt_scatterlist() and decrypt_scatterlist()
      eCryptfs: Combine page_offset crypto functions
      eCryptfs: Merge ecryptfs_encrypt_extent() and ecryptfs_decrypt_extent()
      eCryptfs: Collapse crypt_page_offset() into crypt_extent()
      eCryptfs: Make extent and scatterlist crypt function parameters similar

 fs/ecryptfs/crypto.c    | 337 +++++++++++-------------------------------------
 fs/ecryptfs/file.c      |   7 +-
 fs/ecryptfs/main.c      |   7 +-
 fs/ecryptfs/messaging.c |   3 +-
 4 files changed, 85 insertions(+), 269 deletions(-)

--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJR3Z/hAAoJENaSAD2qAscK2g8P/jShb/4tvCvy9/vzWiOfu3kn
d7nZlr/H3JAYaBOsiA8GAmyNtToMvNjskGUyuB8G5+8DgnEqJziI4/hGjeoj2svz
e/AZmUzDHeZ7byJ+dep9GsQUnhGGiP4V4sPQ2+rVDKjX7VTINCe9s3KSfFx4x49p
swfAKyjkpbBbxyMLcQLF4jO1gFG4ayP5n63ZtwE9JOIQ5fxbHQjBvY/Cieeqlmqc
m5otsWwf5w7sT+RXjySwA9y4jOXdMqBcMqK+6HReCCxv/uTFzS4Iojhu4Z+W98sW
0qvZEgx6/UaQTuc4ZaF+RBsNcgiXXJ/Cd13eNM2etVtoujjkp/Pqdb21BZC55TLp
bFMstpK6fVzEUaVmuRJmBMJ8iOX+yKlnIreNtx9j3iEHtrmOyYBP//FFvb/wOa3A
g8EqSgMuh2OqEYtWd6iY8nx8zNY9Gw0TphG8TeW9L/dDjiL3KT94MjkvZCKtDD78
Mi8skRh1wXf39gFUgdlVcZPjo7PN5T66HU08TdUIDbMkYPn4jfXtvxcD8ZFXb1fr
YLKdL8gf96PSV5l1EqafY2pMUITMzyFcRE5ATmBrvRJlQTDlsQ5loEj89An8BOcM
EJX6QHQETe4Dytk+AqxETxk2oqqbM1Zw4imWwm8smxRIJY3+GYdSwMthLB/funkw
h4gXS47BccAKlxSyamIp
=HkbJ
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--
