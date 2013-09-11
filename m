Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404Ab3IKX6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 19:58:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43216 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab3IKX6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 19:58:17 -0400
Date: Wed, 11 Sep 2013 16:58:12 -0700
From: Tyler Hicks <tyhicks@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        ecryptfs@vger.kernel.org
Subject: [GIT PULL] eCryptfs fixes for 3.12-rc1
Message-ID: <20130911235811.GE18678@boyd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ffoCPvUAPMgSXi6H"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ffoCPvUAPMgSXi6H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit 4de9ad9bc08b4953fc03336ad38908496e2f8826:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile (2013-09-06 11:14:33 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/tyhicks/ecryptfs.git tags/ecryptfs-3.12-rc1-crypt-ctx

for you to fetch changes up to cb69f36ba1f8d5e73c46538e84a88178fb17f23d:

  ecryptfs: avoid ctx initialization race (2013-09-06 16:58:18 -0700)

----------------------------------------------------------------
Two small fixes to the code that initializes the per-file crypto
contexts.

----------------------------------------------------------------
Dan Carpenter (1):
      ecryptfs: remove check for if an array is NULL

Kees Cook (1):
      ecryptfs: avoid ctx initialization race

 fs/ecryptfs/crypto.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

--ffoCPvUAPMgSXi6H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBCgAGBQJSMQOTAAoJENaSAD2qAscKOXMP/jRQpOKVDY11YJluoFqVuQWj
Fx7vYlMLtTFifzMBUDL+qG/SVWxj2L7iPEBL2MmWVZPSLS4w1uke3zEOZTtUG3tP
nAd521f6ZUVpGlFTkLQ3Wp5KmeibbaHZ60VPHpe3lOiELXlft8mcy9sjsP5IQwUw
24GJ6wNn+hAXqB+KGZl95wWxZhun/ao3QBvAr6ZPGgAzWHrt2/P91rUmw1mA2nA7
yG3j+RE6fhjfvtUdpj0/EzQ46rFDPXWI8P5PoEF3BTQVPji3gHT7zaojFkuzmb/a
U1TR0nIDfUrCzOeuoBGUtiH3BQ7UBnYcGpBVty5PbTRiZWuXgqNR9T5uFXLSOB/g
FLc1t0N/EtLgUthKn5ZQYLmEupDTMuNqRRoxKHpVvAW12sVHOpeK7xP32kqAoZXF
Ly1STUuhTeyhrLQ/1kQhM1fM0z0xZl69ky89X1+VUx6Qxct21aFNlTLHjqkH0hEh
6YGuR2KH1yHOTux9gqf08vhBZMTAJaD6YQqW0ZRkQLBrK69qt5C7f58ocCv4ajSd
co9GyDU1saAd+SQelqahwlpXpyskXYbSA/5rXheV+hwgw71+pHQDIRL6oap46IKs
C59+y5NjyHWZ5+ieDkUe3USAV90zVAPEHAEgq8c3rEu804E2rlWB4r0y3Bun/3Ws
nv1+bmFIqZl3CX+zoISd
=PiCE
-----END PGP SIGNATURE-----

--ffoCPvUAPMgSXi6H--
