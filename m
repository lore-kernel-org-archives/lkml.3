Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570Ab3EJGru (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 02:47:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37056 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab3EJGrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 02:47:49 -0400
Date: Thu, 9 May 2013 23:47:43 -0700
From: Tyler Hicks <tyhicks@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        ecryptfs@vger.kernel.org
Subject: [GIT PULL] eCryptfs update for 3.10-rc1
Message-ID: <20130510064721.GA24195@boyd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit c1be5a5b1b355d40e6cf79cc979eb66dafa24ad1:

  Linux 3.9 (2013-04-28 17:36:01 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tyhicks/ecryptfs.git tags/ecryptfs-3.10-rc1-ablkcipher

for you to fetch changes up to 4dfea4f0d7f13309d2ee112a2584210cae4320c6:

  eCryptfs: Use the ablkcipher crypto API (2013-05-09 16:55:07 -0700)

----------------------------------------------------------------
Improve performance when AES-NI (and most likely other crypto accelerators) is
available by moving to the ablkcipher crypto API. The improvement is more
apparent on faster storage devices. There's no noticeable change when hardware
crypto is not available.

----------------------------------------------------------------
Tyler Hicks (1):
      eCryptfs: Use the ablkcipher crypto API

 fs/ecryptfs/crypto.c          | 141 ++++++++++++++++++++++++++++++------------
 fs/ecryptfs/ecryptfs_kernel.h |   3 +-
 2 files changed, 103 insertions(+), 41 deletions(-)

--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJRjJf5AAoJENaSAD2qAscKPIwP/3vNFGMGUJvJJU7YhIyZAFRS
ASWOD8HihqiZqObLdUkfwIuJZaUp9AmTyiA6WKrArN2sU/3yOCEy1P5JKRhqDCdw
TKneAIKwBl8aLD4kJkkgnbRd7y4KU1ZisqhqKAaKfVRelXVwnQNqxtwHBRkD9lc/
XHD7DcvjrP8ZUhM8hOuKGqwIHiHbHkR7NzhkAkGB0iqo2zklOA6gsdVQhGEPRkDJ
ahcqk2sZALgOqVJRVLhqdSrzyoZAcMNdN8yUpR19pJzq4drXiVZG9alTuTOhK8Qg
RIXcYjJOBTx4dJPZPCOTSaepg+lz5NzCCg8XpbtaCMgmtyrL1y+fnxl/I7MQO0ip
kA1KxxHBMvE3YmPb5ooLshKmqlv6j0tFCDhUJgIYGUvtRKtRfjB9r4VXZDxyv7iI
oRhtu9sYq7A0uVwQmdAKOjVa326o8OcS7pdleyDxPStFSbM6K7pn9LUGwF3nveWM
i386RI6hRcudi41pxlsYgsOOhWHwe4t5DT2+x2ZrKfRfTwCgieq3RMlvLe4M18bj
KZANPsfUPwnq0GQghAvSqlQZYTSu28I4PiEE58GpUcUm615Jdqh2sTMbm7M2+6lN
tU5rSp4q8rP8LwzCI1tB3jKjb5rKcb93D2pOvy5sEKPQJQ/Vrawgf6JyYBV2k1ge
TvhBTa+csHkOcqPw1por
=U63p
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--
