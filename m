Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab3IMRGr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 13:06:47 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:49180 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab3IMRGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 13:06:46 -0400
Date: Fri, 13 Sep 2013 10:06:44 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 3.12-rc1
Message-ID: <20130913170644.GA7009@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rwEMma7ioTxnRzrJ"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Subject: [GIT PULL] hwmon fixes for 3.12-rc1

Hi Linus,

Please pull hwmon fixes for Linux 3.12-rc1 from signed tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Thanks,
Guenter
------

The following changes since commit a22a0fdba4191473581f86c9dd5361cf581521d3:

  Merge tag 'for-v3.12' of git://git.infradead.org/battery-2.6 (2013-09-10 22:58:14 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git tags/hwmon-for-linus

for you to fetch changes up to 0b77f766f3ef9875e2bb0035c9b89b4f9469b78d:

  hwmon: (k10temp) remove unnecessary pci_set_drvdata() (2013-09-12 08:17:40 -0700)

----------------------------------------------------------------
Some more low risk cleanup patches:

Remove unnecessary pci_set_drvdata in k10temp driver from Jingoo Han
Fix return values in several drivers from Sachin Kamat
Remove redundant break in amc6821 driver from Sachin Kamat

----------------------------------------------------------------
Jingoo Han (1):
      hwmon: (k10temp) remove unnecessary pci_set_drvdata()

Sachin Kamat (5):
      hwmon: (emc2103) Fix return value
      hwmon: (ibmaem) Fix return value
      hwmon: (amc6821) Fix return value
      hwmon: (amc6821) Remove redundant break
      hwmon: (tmp421) Fix return value

 drivers/hwmon/amc6821.c |    7 ++-----
 drivers/hwmon/emc2103.c |   10 +++++-----
 drivers/hwmon/ibmaem.c  |    2 +-
 drivers/hwmon/k10temp.c |    1 -
 drivers/hwmon/tmp421.c  |    2 +-
 5 files changed, 9 insertions(+), 13 deletions(-)

--rwEMma7ioTxnRzrJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSM0YkAAoJEMsfJm/On5mBD5gP/3byCh2+wWgJrhax8dP2DGps
IWZk8UsHxus/OvVnyD8jpzQ0soQ1zbpbUYU6TX2bmPf4lUnHHUqnXI25Tt7lEHZd
YfYMAzljZTgxX2FJhFlVL1raiP+twMQuimY+dRVu9l9jZkkIA24I2o67qIF/TbHP
YHGX6XbUR0qT19oUTOFIkpKVkrN3+yy+/LDxV5WCVBlunyoGv7apva+UesCxz5vn
5zVBfFgKoapbmVuax56xhdPbkK0z/McpxXm2WkKRVAleIQfOE/ItvjD79tRxlKka
uYpw2BASplIBV8GhtFL4dUfDHdO3LX7AD6NrXwmnLso7hza/NBLD9IIbOrZp5d+F
UjDJFyzX63QSk+3rhKnzUBio0c/3eR7dLVHE1jj4PNBcRGmDX4EtftdnnkRPfDTH
c99qiOYV60pFzA7KOIqbYX2kULe7HlhU7yXXdp+jLRxLbo1YQYCfA4p97qx8D5IE
tSLAYp233qVkeYEyACptEnLh9JCTujaS9pGuH+dymqoLahG6IYc7Fzp5qAztskO8
EWU6/iVeVzHnVZVjz2wqZxIe7byeOtuBdgRqYlpdKJaZFopQBoG6tFqYQm1cbOjK
INWT+t/JvWMx6iLN/mBeuGjrWJLeNxxtuB15FCSrl8XVMu9DV6HsAhoglfQ6ffTr
Imxr1pnFVwZCcMEdeW3M
=aPwo
-----END PGP SIGNATURE-----

--rwEMma7ioTxnRzrJ--
