Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758563Ab3CGAul (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 19:50:41 -0500
Received: from mail.active-venture.com ([67.228.131.205]:55561 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755425Ab3CGAuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 19:50:40 -0500
X-Originating-IP: 108.223.40.66
Date: Wed, 6 Mar 2013 16:50:38 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon patches for 3.9-rc2
Message-ID: <20130307005038.GA29640@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull hwmon fixes for Linux 3.9-rc2 from signed tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Thanks,
Guenter
------

The following changes since commit 6dbe51c251a327e012439c4772097a13df43c5b8:

  Linux 3.9-rc1 (2013-03-03 15:11:05 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git tags/hwmon-for-linus

for you to fetch changes up to 3e78080f81481aa8340374d5a37ae033c1cf4272:

  hwmon: (sht15) Check return value of regulator_enable() (2013-03-03 21:45:48 -0800)

----------------------------------------------------------------
Bug fixes for sht15 and ltc2978 driver plus some documentation updates

----------------------------------------------------------------
Guenter Roeck (4):
      hwmon: Update my e-mail address in driver documentation
      hwmon: (pmbus/ltc2978) Update datasheet links
      hwmon: (pmbus/ltc2978) Fix peak attribute handling
      hwmon: (pmbus/ltc2978) Use detected chip ID to select supported functionality

Jean Delvare (1):
      hwmon: (adt7410) Document ADT7420 support

Mark Brown (1):
      hwmon: (sht15) Check return value of regulator_enable()

 Documentation/hwmon/adm1275     |    2 +-
 Documentation/hwmon/adt7410     |   11 ++++++++++-
 Documentation/hwmon/jc42        |    2 +-
 Documentation/hwmon/lineage-pem |    2 +-
 Documentation/hwmon/lm25066     |    2 +-
 Documentation/hwmon/ltc2978     |    6 +++---
 Documentation/hwmon/ltc4261     |    2 +-
 Documentation/hwmon/max16064    |    2 +-
 Documentation/hwmon/max16065    |    2 +-
 Documentation/hwmon/max34440    |    2 +-
 Documentation/hwmon/max8688     |    2 +-
 Documentation/hwmon/pmbus       |    2 +-
 Documentation/hwmon/smm665      |    2 +-
 Documentation/hwmon/ucd9000     |    2 +-
 Documentation/hwmon/ucd9200     |    2 +-
 Documentation/hwmon/zl6100      |    2 +-
 drivers/hwmon/pmbus/ltc2978.c   |   30 ++++++++++++++++--------------
 drivers/hwmon/sht15.c           |    8 +++++++-
 18 files changed, 50 insertions(+), 33 deletions(-)

--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJRN+ReAAoJEMsfJm/On5mBmK4P/0TZIXWK16kNKM6tMN/3ON8N
mgFLV92jI8lTwXDKflNZvvX3zisdFFkLG/lod5CwSs7LyCn1y1OSBm1dYQl0GQ/P
Tot9XgQCmet+1H2GHNPrHaZ4kSE03DqNygIyZTyQ9V2iAjPLnC+Nm/sFI1el/xhE
ouLr8X7d+xN5DL3G7PTQH8+EquE+NoCYt2HadZ4xNUEdSp3Zc/60HQavvTfv+ERh
Q0kkWzw8PYTBUGIy3AMZICsTcuoq9XjWFr962zSRzYIy8pGRWmACbyeRO3Q3ksda
W0CcWUQAggGmVhg/lRWRibma+D//AcKQFvS3ouwFzd8obtaVpe7Z7Il6RxOhyFKZ
lya5gj63mmbQop7GxuoAz19oyPfaRgL8NfbWP2DpjYfQ/Iv0RroPNHg2LacmQX5Y
OlOppf17ScpbAx/ghaceJt8mm92v4hcjEUtvRoQB9NHV4LucK1+9pfBGG3ouFxis
UwOkYrjFLFw5qWfZlzBYsPI1idTrqb9ETEVlanpI2mes6itI7zsjqNJq5CYhv8vT
QyOxsx3STm103rZc4AuP5MpMYI1ksr8aBtOJmPjNjxPtxh/jnJNZdMk1OZwwyilJ
+7rx+gCXsfHthxJBRhb0Ki+3WdPb8VUE6D2RMHRENUh0SJ0QGs6h04hQQpR1H2ZO
5m3e9MyRV5M9kp8+5bns
=nYJJ
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
