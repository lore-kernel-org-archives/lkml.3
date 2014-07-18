Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762458AbaGRN54 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:57:56 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:63785 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762437AbaGRN5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:57:54 -0400
Date: Fri, 18 Jul 2014 06:57:51 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 3.16-rc6
Message-ID: <20140718135751.GB18432@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull hwmon fixes for Linux 3.16-rc6 from signed tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Thanks,
Guenter
------

The following changes since commit 1795cd9b3a91d4b5473c97f491d63892442212ab:

  Linux 3.16-rc5 (2014-07-13 14:04:33 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git tags/hwmon-for-linus

for you to fetch changes up to de12d6f4b10b21854441f5242dcb29ea96181e58:

  hwmon: (adt7470) Fix writes to temperature limit registers (2014-07-16 21:18:47 -0700)

----------------------------------------------------------------
More fallout from module tests and code inspection.

Fixes to temperature limit write operations in adt7470 driver.
Also, dashes are not allowed in hwmon 'name' attributes.
Fix drivers where necessary.

----------------------------------------------------------------
Axel Lin (2):
      hwmon: (da9052) Don't use dash in the name attribute
      hwmon: (da9055) Don't use dash in the name attribute

Guenter Roeck (1):
      hwmon: (adt7470) Fix writes to temperature limit registers

 drivers/hwmon/adt7470.c      | 6 +++---
 drivers/hwmon/da9052-hwmon.c | 2 +-
 drivers/hwmon/da9055-hwmon.c | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

--huq684BweRXVnRxX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTySffAAoJEMsfJm/On5mBYvMP/2tSsN3lUKVuOuUFj//xaBix
HH131fzj8sinMXiMrVe253IIbDDWwwsqY6TQxJLhAhL3C/opjzsJMSdwKntg7mzi
OJgd3bJUgoqOb1iCVSzVXavJtZI+fMeNHscVJsZ4vEmMA0xVneZqY5dlS4Yso4Nu
cXChwUAcLJSTwU1gScJqvxgRaUV5/dOV0qUgGnX2i4u87HBmfDeU9NETYFZgbR2h
N213K+m8YQXSSw3SI1FTukyVVjoN+fi9PKlgliPEIcvMoSp0O4c1GGlvOdWCyIhh
eNoL7uDjs+4dD5XyzXFZsrI7BQBnWftDsSsf7yngtpG9C1x/wrMGdlEtXu7PC1rp
m87z9Uka8Fj9q1LazfbVjOkzldgDCvHyuLXeMGpDPI+tlM0A0ce8OMvkSD3fmSMF
M+dW6I/AxYHmmcR5Qq9lqHzeAwetAxkKyYfJ3nigomPasFIHKvebgQIyWM/OFQH+
Xkim3dL6ZMZe4KGVIkig78OKlQ41B0QGvQRLlav5CJFlw2Pi2LegUNYPnACl8LYs
5r4ftOPMibN9vxSodcQP7dgeDhw9JangeYqw0UE2qKSlNAJg0Jy8rZoPZEcc4dPY
wmees2kjdXHiTWn3Woxc+FFbEN/HgzqfQ/U0GkJPC1zJQNg8nFA1An7YwVv/J6hQ
MCYOPMi8gE60o6pHIOB+
=boB9
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--
