Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013AbaAOOd6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 09:33:58 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:41638 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbaAOOd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 09:33:56 -0500
Date: Wed, 15 Jan 2014 06:33:54 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fix for 3.13
Message-ID: <20140115143354.GA25243@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull the following hwmon fix for Linux 3.13 from signed tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Thanks,
Guenter
------

The following changes since commit 319e2e3f63c348a9b66db4667efa73178e18b17d:

  Linux 3.13-rc4 (2013-12-15 12:31:33 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git tags/hwmon-for-linus

for you to fetch changes up to 3f9aec7610b39521c7c69d754de7265f6994c194:

  hwmon: (coretemp) Fix truncated name of alarm attributes (2014-01-14 09:47:52 -0800)

----------------------------------------------------------------
hwmon fixes for 3.13 final

Fix attribute length problem in coretemp driver

----------------------------------------------------------------
Jean Delvare (1):
      hwmon: (coretemp) Fix truncated name of alarm attributes

 drivers/hwmon/coretemp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--mP3DRpeJDSE+ciuQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJS1pxSAAoJEMsfJm/On5mBaGYP/iya6E+ta/LnkgeheVgTJYpn
cwPTtmZAoMMxf2smeNi+WRyYZ0kGrr6hiwCxmWwdXPHglnf+nGF56RxEHP/L508H
JpOOSMoDrn/hbx3y/mroy+RHMBohkA51Bnq5FTzrcIo1GnqtbU4Sf7S+L4L+amKQ
TdO7iKvK43gtLnPMVAAwioc5+v2lMpp/AXnnLEu2uaSHlk+JF9vs2PcYJ0TLSJOk
wFLoOdDx8jXIfFHkf8MasSG9a3Es3TnHS4KXFiXO3kkWj4quNyEOwcR7wEYRcngJ
G6MhqPb42hEr1f5aMOJuILmkZz8sN8NS5p/N992RKlTELb/GzfnUGcYomo8fLR+h
UKfrNIWmGSC/ruZGIG3XLYluvIUcUAM8cXxCr0dUPrkCmt1lxOOtZGxlS03n7u5/
qUcU7bkhQdNrs3CvYolWB4JptaUdxlrzufENyZ6cdRsmElOSRsKNkUk+LvToALpu
h9RH9fKHOHyTcegf9mw1ATeGmL0XTkyrbrfR1berNCrom8r12LrgYldmxLAZLugd
ezhIxTVQA8bHlAxtO+dxzRn/a5MVjnoffN8kfhfh8HL0AHTNc3hhWEfpK73epBXw
XHTIANzGzW0hWshfDt8DL+soeJv5FUijDKCOJz9lw47WFQeqBpp40Cpmvp4tp+bM
BcplgqUi7mHTcBuNPgrQ
=uXvs
-----END PGP SIGNATURE-----

--mP3DRpeJDSE+ciuQ--
