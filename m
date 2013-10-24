Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab3JXVfA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 17:35:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57725 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092Ab3JXVe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 17:34:58 -0400
Date: Thu, 24 Oct 2013 14:34:53 -0700
From: Tyler Hicks <tyhicks@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        ecryptfs@vger.kernel.org
Subject: [GIT PULL] eCryptfs fixes for 3.12-rc7
Message-ID: <20131024213452.GB16603@boyd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="SkvwRMAIpAhPCcCJ"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SkvwRMAIpAhPCcCJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit d6099aeb4a9aad5e7ab1c72eb119ebd52dee0d52:

  Merge branch 'fixes' of git://git.linaro.org/people/rmk/linux-arm (2013-10-14 10:02:23 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/tyhicks/ecryptfs.git tags/ecryptfs-3.12-rc7-fixes

for you to fetch changes up to 43b7c6c6a4e3916edd186ceb61be0c67d1e0969e:

  eCryptfs: fix 32 bit corruption issue (2013-10-24 12:36:30 -0700)

----------------------------------------------------------------
Two important fixes
- Fix long standing memory leak in the (rarely used) public key support
- Fix large file corruption on 32 bit architectures

----------------------------------------------------------------
Colin Ian King (1):
      eCryptfs: fix 32 bit corruption issue

Geyslan G. Bem (1):
      ecryptfs: Fix memory leakage in keystore.c

 fs/ecryptfs/crypto.c   | 2 +-
 fs/ecryptfs/keystore.c | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

--SkvwRMAIpAhPCcCJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBCgAGBQJSaZJ8AAoJENaSAD2qAscKNPIQAMivc36smIb0j1HosY83KDv/
xnSPNM/mJsvcHc14K8+hPCQBECZn7TJpr1SVa6AQOIr5x4rEmZ2XM5BR51LQa6L3
MiYjfKoVB4EFcI++Suk4qN6oO8waCmtSDTa+TUYfn8k1JgPveVSCdeBWFsChidLc
hRa4UAA12t/JLKYCpltwllIARhfRtpRD4G1t7rU3dyjJa56SFX0rht3nGOcFRoX8
hDa8X16Vpg3scOkMDqJLa/4Pg57w51nvN6iKclyZF7kr317tsvMhBeefZnle14da
kQhZsGZgnKWF5qCdgt9bOUEtdOAEC8U/qk3maTyUlQ46fu6P2Wi9WYy0pjA5QRkg
ER5QfwRyP1yCMkDhYMTrsNcBwKJMSZXVOTLsC1RKGBdNp4soqSMASAS1/MQOBCkK
c3FUJHUO06uM0Z2vSudoOvZnIpAWJr9sJwbV5fH5Vr3OM5BX4Y3hSD2uBOtkxGWW
/gy7JiAEjOt59Jw/Tf+Q7gmcgwM9qvT2o2fYQGfQDGmx7h3sTz9JOBA2jPuOBxx5
zy/6TmJ4keLcMLWr2o6CvkYPG8m7bufNni3C1+m4u6uQZZvxetR2dwCFGumyR6q8
IIOZ+7oUJGAcsA5UlJcKDVVIxf0K/bmpTSXg0HU0uVMbDFGpfmjigRJoMXpZGgT3
Yp1l4sBejJ+shZPtbHo0
=59fg
-----END PGP SIGNATURE-----

--SkvwRMAIpAhPCcCJ--
