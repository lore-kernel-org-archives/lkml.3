Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588Ab3I0QnW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 12:43:22 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:63146 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377Ab3I0QnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 12:43:18 -0400
Date: Fri, 27 Sep 2013 09:43:13 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 3.12-rc3
Message-ID: <20130927164313.GA12414@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull hwmon fixes for Linux 3.12-rc3 from signed tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Thanks,
Guenter
------

The following changes since commit 4b97280675f45c1650ee4e388bd711ecbb18c4b4:

  Merge tag 'stable/for-linus-3.12-rc2-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip (2013-09-25 15:50:53 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon

for you to fetch changes up to 5f4513864304672e6ea9eac60583eeac32e679f2:

  hwmon: (applesmc) Check key count before proceeding (2013-09-26 03:48:43 -0700)

----------------------------------------------------------------
Fix potential crash condition in applesmc driver

----------------------------------------------------------------
Henrik Rydberg (1):
      hwmon: (applesmc) Check key count before proceeding

 drivers/hwmon/applesmc.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSRbWhAAoJEMsfJm/On5mBzFsP/2UciNm8c4HEQWHUhKJVfNzF
/Xg7VquXiN2VlD1wuXCeyNLizmTnDt0TdyAsNGEneJSedHvGIarCURcrPyA1sn+2
oPumBqHOqo2MhLxgxKl75+QFSmdIwUXPBxajbCQSl3RNhVKc7uuSd8V3qaI87ZJ0
7l/BA4I1JDIx6O4Ioob3QQ/M2K2uXD0mL8O6j4UCuKi7dR9SB6EUfaOp/xbYxrsd
XbLm0fnJKZnqRCW4q0+kdrFny/FgKb076veGPP4yofcPGh0BIit/Z3XD0JvCh6JR
wPVgNdo4+42CYVLIwhTpmPQZPGGvYMcwlZ4/NToGO3olK/CtNzngMrnH6iPtSEp4
jUf8o6JvhVkR9X8DGij214Z6ifixBK/QqcjoCbHmlbDLMsui0/au3Ll1g+Vg6Iti
Tgh71H5WYoeDU/NfG76Ai+ErSMU9bdRyWZSWs4vnfeWKMn6FlzcZe1Wjv+2Av7vI
XEVKzO3xZGNgu6oTAT/Cx/HjUx5HffrMLWPPNKVWwuanmS+XLsdghxC+RshfioHO
xAGLp1cKqxDz9A3qp9oxniaYdy9D6OxzF/T+OoVTS8eErwz5HaCIBZNFuvkJJRRI
aIw2OVfuN0oBBoptz08o9VNjjAEreaAj9UOKjmcj/te8YXTrjxQcTsR0BYjisTrZ
NyXarfw6vwU28jeW3HOE
=x/4A
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--
