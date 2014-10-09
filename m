Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932667AbaJIVX6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:23:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59823 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757293AbaJIVXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:23:53 -0400
Date: Thu, 9 Oct 2014 16:23:48 -0500
From: Tyler Hicks <tyhicks@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        ecryptfs@vger.kernel.org
Subject: [GIT PULL] eCryptfs fixes for 3.18
Message-ID: <20141009212310.GA13655@boyd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="1UWUbFP1cBYEclgG"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1UWUbFP1cBYEclgG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit 319e2e3f63c348a9b66db4667efa73178e18b17d:

  Linux 3.13-rc4 (2013-12-15 12:31:33 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tyhicks/ecryptfs.git tags/ecryptfs-3.18-fixes

for you to fetch changes up to 0f9e2bf008a1b143973a01b52320eb66c20ac6ab:

  ecryptfs: remove unneeded buggy code in ecryptfs_do_create() (2014-10-06 16:54:50 -0500)

----------------------------------------------------------------
Minor code cleanups and a fix for when eCryptfs metadata is stored in xattrs

----------------------------------------------------------------
Alexey Khoroshilov (1):
      ecryptfs: remove unneeded buggy code in ecryptfs_do_create()

Chao Yu (1):
      ecryptfs: avoid to access NULL pointer when write metadata in xattr

David Howells (1):
      Use %pd in eCryptFS

Fabian Frederick (2):
      fs/ecryptfs/messaging.c: remove null test before kfree
      ecryptfs: remove unnecessary break after goto

Himangi Saraogi (1):
      ecryptfs: Drop cast

Steven Rostedt (1):
      ecryptfs: Remove unnecessary include of syscall.h in keystore.c

 fs/ecryptfs/file.c      |  4 ++--
 fs/ecryptfs/inode.c     | 25 ++++++++-----------------
 fs/ecryptfs/keystore.c  |  2 --
 fs/ecryptfs/messaging.c |  3 +--
 4 files changed, 11 insertions(+), 23 deletions(-)

--1UWUbFP1cBYEclgG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUNvzYAAoJENaSAD2qAscKXsEP/iFh0cytl6v0+dRdoaCzOwTF
qIXWB6Qyo4nn05cVebKMg7NA3OqDx4FS1dJLrblAQtUjY+y/rKo0M+3IhWYUTmQY
0mN80je+NZtqH5TI+6cv/5OcbVKZQQ8/cypTfilDnhyERMbLy3nCqtlwHZux+Cz0
iMVZd740JHfmB23O0skZbUdF3+PBOwQgFhJ9sS8+lbqXH9SNqM3rMnBraX/Apgwy
1QGob5zCrI0FbVRUTT+99BGtT4hmW4v8K8aFsfOQq2oS/XW/XbXgMlKjiVnG9ZKF
pazjBN40mZOvyHY/M6kT+2v2bZqp9cbi2kJ/0pUYoqGDqwJ5yMpLv4Yx9qBTPu+F
M66c+tI1P0gFslkPk/vi7p/NULLaTklY6ZnR8UnLlPqpKknopyceaA0VwgzBkO4h
/1QbwufGwQm8k5CWxkkICRFQyqu7wbsfqFVdaRZt+j/u/0tCdN6QOmw4l/iJpxD1
Wkd+UhiRZsqVMqfK5w50i2tAPc3AAQ7GtG6Q919ACSmmEjFBKDMtiqiQM+W4h5DQ
SD9i5GcjNMd5tamNU9/pM+EOLr1sePQGDTpuroWYEAVhfPL1Orwa4goZC7LCpFWn
4a4yHY0g8gwHAuoUPWSZKyCc3mTCoArxhNvS3evCFedpXOm97K+e9kOqXoxwUkzn
M37xcl7yzlNk+Yn7G3rw
=mpGY
-----END PGP SIGNATURE-----

--1UWUbFP1cBYEclgG--
