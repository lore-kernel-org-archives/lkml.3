Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab3GRH71 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 03:59:27 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:42508 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884Ab3GRH70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 03:59:26 -0400
Date: Thu, 18 Jul 2013 00:59:30 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 3.11-rc2
Message-ID: <20130718075930.GA9880@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qDbXVdCdHGoSgWSk"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull hwmon fixes for Linux 3.11-rc2 from signed tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Thanks,
Guenter
------

The following changes since commit ad81f0545ef01ea651886dddac4bef6cec930092:

  Linux 3.11-rc1 (2013-07-14 15:18:27 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git tags/hwmon-for-linus

for you to fetch changes up to 0b905d83c4db7ae98718c44d79c717836a2ecaa7:

  hwmon: (abx500) Staticize abx500_temp_attributes (2013-07-14 16:24:25 -0700)

----------------------------------------------------------------
Single patch to staticize a local variable

----------------------------------------------------------------
Sachin Kamat (1):
      hwmon: (abx500) Staticize abx500_temp_attributes

 drivers/hwmon/abx500.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--qDbXVdCdHGoSgWSk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR56BiAAoJEMsfJm/On5mB2UgQAKwzXYODsfIXhO3Hy8z813fB
/v0Utt/vzLOtf0T0ENgjQpIqZESMr+P0F65rP/BcZXTl5G/FdjQjXr7yF8i55Sn8
sXsjW2jcOb5udSn4QYHXLy7F5RYSyic+dvnSv0X18e5ocC4QcbzQwSLzdnB51SqW
ZGyfEtoXyN4C9GHrjUAjPz/sIGbCDtBclpLCWGG/DMX79PCr5N5FNDTiKQGDDWEa
tBgz5tTrCRE06yAM5emKchNVeAeaMeMMq9OQekkPbhESIcYfpL8xLwoLFDNbTwmK
IJrwA6N/BVKdxMDQDTpuCJNDKpoR+3b0R4c3quHMijt/bd55QtVxTutPa3bCAxpY
QkqmswBBWJd5pEsIWEMObOlaTd2Cx4V0QSLPVdlUCCz0SQhzVdfqdndWqZh797jP
0c1sBgNf9bl4ivzfpisI3ffcHCuKSJXaGB35PCQJSyJ/q/b1P9w26mr6SMAWDRM8
432fZogl9sZ1D4Z6/pfVyT/TyosaqdDwkqrU19p/F9I8UKvakn6bEydn6675Jy1e
iWRiAB/UgIK6eXPtTLuKjBCypEh67jfBmseSNz++ots2tPDYeJuJkyqTssII8hps
AzKsMiraEFNbDuu8vfDc52yP81CKDoDmIN/okCdFK1UCOaZbsuMyHNZWCsnoi72W
Xx4Ap+QvalCEXUdijU6F
=a278
-----END PGP SIGNATURE-----

--qDbXVdCdHGoSgWSk--
