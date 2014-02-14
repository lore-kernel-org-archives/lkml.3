Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421AbaBNSOm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 13:14:42 -0500
Received: from mail-pa0-f65.google.com ([209.85.220.65]:57023 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbaBNSOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 13:14:41 -0500
Date: Fri, 14 Feb 2014 10:14:36 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 3.14-rc3
Message-ID: <20140214181436.GA26946@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull hwmon fixes for Linux 3.14-rc3 from signed tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Thanks,
Guenter
------

The following changes since commit b28a960c42fcd9cfc987441fa6d1c1a471f0f9ed:

  Linux 3.14-rc2 (2014-02-09 18:15:47 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git tags/hwmon-for-linus

for you to fetch changes up to d3d89c468ceebbcf9423d1a3d66c5bf91f569570:

  hwmon: (ntc_thermistor) Avoid math overflow (2014-02-13 19:43:52 -0800)

----------------------------------------------------------------
Fix arithmetic overflow in ntc_thermistor driver

----------------------------------------------------------------
Doug Anderson (1):
      hwmon: (ntc_thermistor) Avoid math overflow

 drivers/hwmon/ntc_thermistor.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--2fHTh5uZTiUOsy+g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJS/l0MAAoJEMsfJm/On5mBW9wQAKIZ386nR+TVNeuU2A+JL8Bh
U3uBj4srikDXcv8JyHq06lfPLhQnP6bjNpV39tbPHqAlK3INoYU4zo45mOc9j0Aj
wCfSQdIYqqm+lfaTX1OhDe1r8j0mc+EdC4919PoDYNWVjZJsL5Fwyk24RDDUnoaK
NBlTYw7CFz8nx4WdB0w/qeVVxcK1s7bBi+pPqn+2ci670mlXE49Vh+xfVdp7ZBDP
PsnK8/D3gpwCiN7N8dqwUzn06rj6xJl5a9QZUoY6QeqRM/LnjbZhzTNT2I0g2WFY
7cxKIL6zcsSKcIEox019pwr83D4kmSmOU9P9HfJW0BwcXKkTz2Z4HFjLhN34gYt+
+C5TGmSQ2u90tVwBLg4ljicTL8X4AyOJse7wCXLpzH+K46QRedElwUR5EK6xkJEI
6yj7pu5B2OO1i/d4TcPJ11bCf/FZuSBFHSDvBXcwQk36uIoN0dwYKWAlCA6oBb/F
kUj1tuvwmAD8SsxHUKlX+2j7CKGeivoXif3Skg2ZIXU5SP8hztoIbNmNeb98OWJA
9Owe3Nd7KhZLXbGUnaU6map+Ny57G3o169k183jKb8p+fr6MkTKSpRzxP+R587E7
Yuctu98UP4Qt344gQDqydKWQjMjN4I2MzSEmXC8Q8P82Zvz9JatjIZRsu5KeTta+
P+2bbnge8FHJX7d5FjsP
=nMjD
-----END PGP SIGNATURE-----

--2fHTh5uZTiUOsy+g--
