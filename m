Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931Ab3AKWki (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 17:40:38 -0500
Received: from mail.active-venture.com ([67.228.131.205]:63836 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691Ab3AKWkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 17:40:37 -0500
X-Originating-IP: 108.223.40.66
Date: Fri, 11 Jan 2013 14:40:36 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon patches for 3.8-rc4
Message-ID: <20130111224036.GA6268@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull hwmon patches for Linux 3.8-rc4 from signed tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Thanks,
Guenter
------

The following changes since commit 9931faca02c604c22335f5a935a501bb2ace6e20:

  Linux 3.8-rc3 (2013-01-09 18:59:55 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git tags/hwmon-for-linus

for you to fetch changes up to 08245ad87e2970ac56987caab5cd5900563db4e1:

  hwmon: (vexpress) Fix build error seen if CONFIG_OF_DEVICE is not set (2013-01-09 21:47:22 -0800)

----------------------------------------------------------------
Fix build error in vexpress driver

----------------------------------------------------------------
Guenter Roeck (1):
      hwmon: (vexpress) Fix build error seen if CONFIG_OF_DEVICE is not set

 drivers/hwmon/vexpress.c |    1 +
 1 file changed, 1 insertion(+)

--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJQ8JTkAAoJEMsfJm/On5mBf60P/R51pv9/Bca211d/nujuCcNt
7HD/MOU7i5T4V4HgDDdqTD9wiXz+b5DzH0FkER6dHukNSc0Wk/I1BOWdkGkqaHiG
7gaXu1/g1h0wWDDz6FO6RT54KyMJ1RLCZM15dPo5nTD87LkF3vnNDMrnqN3g0Z7H
HeuI36yFMhq8VNZ5XCLdoyARdTVey04YnMlVtRdlVmRT0NB72cL7SERffsqDf6U1
hhD+mv/Gkos0SwZLQQPCu7iMTrdYZYQxYgCp0v4LCu8h5BNg9s3TPnQ2iw4eHJPs
Z4Gp6fyratebMPjC3WALXHnCn+imD0kNBufTYAynDjio0+LUOtODT2Skzbtd+TNX
3iTI339VBrIK1US97ORgFcBT9Vi90d9shwDOrzxUqNHyETMd3XJRqZTK4k9IRDh6
TM+OM7XxzCyar+pV+3OhEdVA1iFGgzP1/DYhliJDdKwOuA+0l2H5PwhJl4rQbLOG
hW70Lvuq8zp2f4JYQAwu54hwWE13sw9CmnvEznMoTrIfBgrCCwR8P3wkVJa+0MCw
HbRkavC7nUZuFbPL31ZhYuu4YLXsM7VZLOGst81nf9uSaNN39ufIGa0NNMoxxULF
Utb5POsRbbriiEY9i6C2r29/Fl3F1jqyjAVU2ZnZY3Jx954QUkZt+NNkdT3pE8G0
IrfAaF9dGji+ABg+Sf5T
=8NSf
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--
