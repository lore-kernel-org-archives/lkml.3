Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759046Ab3EONc4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 09:32:56 -0400
Received: from mail.active-venture.com ([67.228.131.205]:54150 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759028Ab3EONcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 09:32:54 -0400
X-Originating-IP: 108.223.40.66
Date: Wed, 15 May 2013 06:33:11 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 3.10-rc2
Message-ID: <20130515133311.GA14411@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7JfCtLOvnd9MIVvH"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull hwmon fixes for Linux 3.10-rc2 from signed tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Thanks,
Guenter
------

The following changes since commit f722406faae2d073cc1d01063d1123c35425939e:

  Linux 3.10-rc1 (2013-05-11 17:14:08 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git tags/hwmon-for-linus

for you to fetch changes up to ecacb0b17c08fae89f65468727f0e4b8e91da4e1:

  hwmon: fix error return code in abituguru_probe() (2013-05-13 08:07:13 -0700)

----------------------------------------------------------------
Error path fixes for abituguru and iio_hwmon drivers.
Drop erroneously created attributes from nct6775 driver.

----------------------------------------------------------------
Axel Lin (2):
      hwmon: (iio_hwmon) Fix missing iio_channel_release_all call if devm_kzalloc fail
      hwmon: (iio_hwmon) Fix null pointer dereference

Guenter Roeck (1):
      hwmon: (nct6775) Do not create non-existing attributes

Wei Yongjun (1):
      hwmon: fix error return code in abituguru_probe()

 drivers/hwmon/abituguru.c |   16 ++++++++++------
 drivers/hwmon/iio_hwmon.c |    8 +++++---
 drivers/hwmon/nct6775.c   |    6 ++++--
 3 files changed, 19 insertions(+), 11 deletions(-)

--7JfCtLOvnd9MIVvH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJRk46XAAoJEMsfJm/On5mBJCEP/0bjfSJngxvvJ2oGXcIklnJQ
Kk5cHBaXPUaxO+CC8B7SBpABPWE8FJgrMg2CdJzpwlOpbukBuxWFN6LScVyBNoB7
VJRqz/w04Fk7P3BMdNPezOEsd7cZgHdqZ55sk8aBe4C6SENj6jCBpq1yBKsaFQ1h
sCGguBtTBtgIvNkQZjYPTAaXq5QLtXlBt+dvuLiCH+SDwj1Pk+qSCQAlR7HK9cNo
RKc47pgUKdHTMHtpd67JjPs0xZTmXVCK7bKI7tzkKFI/5Dp/tgJnmQpvU297T6g9
zgwdR2kqWSDrb1qp6VpMdpyTvHRn6ErE4xCtiPdSbfDcfdu36/ysZCRO/OddavBd
MVnIzu/UE6d57HOZNpjJB8C4Hk5oEKg3hhmpuCn168eSXo+S5EvATdbXyjt2vnSe
L0PDiOjDtAiI6EULTFTJTzDIuj2XnqVsjJxHwP4IO6IkFJPKxeitvrCUzBmNeyOC
A4HsDO5OU/fF+LF3QdrMZJRKfOlTNOsVxZHJmm2dog0h7S8K1RTdwOwFnWjw3EGU
JiONUdIYuU0PMzXb/uRhsT0W0Rspws6D63lvECN1Gx+ymvzySVL7DjvpzPoROpGP
+wUO+AAmAGR+3b6fuJJWm7oXgtFS/iFoGezWVCQqPHNJGg/IBYfQ2Uj4hauuSZxY
Wf/vSv1zxAhOOYw6f9et
=Gt+w
-----END PGP SIGNATURE-----

--7JfCtLOvnd9MIVvH--
