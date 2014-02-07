Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371AbaBGSAW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 13:00:22 -0500
Received: from mail-pb0-f67.google.com ([209.85.160.67]:43027 "EHLO
	mail-pb0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbaBGSAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 13:00:20 -0500
Date: Fri, 7 Feb 2014 10:00:16 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: torvalds@linux-foundation.org
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] hwmon fixes for 3.14-rc2
Message-ID: <20140207180016.GA23438@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull hwmon fixes for Linux 3.14-rc2 from signed tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Thanks,
Guenter
------

The following changes since commit 38dbfb59d1175ef458d006556061adeaa8751b72:

  Linus 3.14-rc1 (2014-02-02 16:42:13 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git tags/hwmon-for-linus

for you to fetch changes up to 4f545a4ba158600b7a780b9daaf9ffabb934cdb6:

  hwmon: (da9055) Remove use of regmap_irq_get_virq() (2014-02-06 17:22:33 -0800)

----------------------------------------------------------------
Fix PMBus driver problem with some multi-page voltage sensors
Fix da9055 interrupt initialization

----------------------------------------------------------------
Adam Thomson (1):
      hwmon: (da9055) Remove use of regmap_irq_get_virq()

Guenter Roeck (1):
      hwmon: (pmbus) Support per-page exponent in linear mode

 drivers/hwmon/da9055-hwmon.c     |    4 ---
 drivers/hwmon/pmbus/pmbus_core.c |   68 ++++++++++++++++++++------------------
 2 files changed, 36 insertions(+), 36 deletions(-)

--HlL+5n6rz5pIUxbD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJS9R8wAAoJEMsfJm/On5mB/G4P/2JI2M0vbk/QUkXtTocvXP6v
1uzzaWRvJBsL6nXI9T8fkLOjkZGeoZ8bIjfZ+1J+rmd7uhenp8rld4WUzEe9+vfm
iNMR6qmKRB4I0FNoevoL2NiWBX+0WoOvvo10N/cyrAGnUxXKhFkv7zptjjLS7B/q
AEolFUGSVMRrHyXZwgwssXLba+SGD9yGY5EYWk3NulttM1m/5FKNmYv/620YKZCq
wJ7CaYHOUxVzQ+jgCwuyP9F0KKAI7rdEoaLQrXkSW+KIIHN90M9z3ZNpJUV6IaF/
qXuyjGqUhbEgQCWkCRQ8ALjK5x9OmNBP9vZUKXLOKS88EnjYe6Y4k62WPX3siCO2
Y/MBdtgfMsp1x88ILn6hjdh1bBwGSrc0lqkdgf9ugPiWp4/ztoEyJmHG23on/aWZ
8gs63WnARzmluH33coU/jDfau++QIjcxKQRaJUYG5fk/UGpi1mYuvEmVWP3MLvs6
FVM/zsDFPgDAocIZIqJ3NQlQHq/tIa8Jq1v46XvpT4flnkxRiiGFG7e+xcoyh58E
+l+XB1NqkzPskWbK6ueQgQKb/n4cGjWp/4Yh7Hk8XwZiRNC3KU4S63M4y1GbuQ/o
pcSgUjLRagR9sXcEY5MBQYkMmI3DTPsLNV+HT9Ikcu8zlEXcFPzMVMXqyDqs8S2q
QcPxGFZeduBJSLSWyoEK
=lZZF
-----END PGP SIGNATURE-----

--HlL+5n6rz5pIUxbD--
