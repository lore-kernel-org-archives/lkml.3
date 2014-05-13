Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758293AbaEMCEX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 22:04:23 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:50375 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755976AbaEMCEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 22:04:22 -0400
Date: Mon, 12 May 2014 19:04:10 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 3.15-rc6
Message-ID: <20140513020410.GA27750@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull hwmon fixes for Linux 3.15-rc6 from signed tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Thanks,
Guenter
------

The following changes since commit d6d211db37e75de2ddc3a4f979038c40df7cc79c:

  Linux 3.15-rc5 (2014-05-09 13:10:52 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git tags/hwmon-for-linus

for you to fetch changes up to 3a18e1398fc2dc9c32bbdc50664da3a77959a8d1:

  hwmon: (emc1403) Support full range of known chip revision numbers (2014-05-12 08:37:06 -0700)

----------------------------------------------------------------
Fix resource leak as well as broken store function in emc1403 driver,
and add support for additional chip revisions.

----------------------------------------------------------------
Jean Delvare (1):
      hwmon: (emc1403) Fix resource leak on module unload

Josef Gajdusek (2):
      hwmon: (emc1403) fix inverted store_hyst()
      hwmon: (emc1403) Support full range of known chip revision numbers

 drivers/hwmon/emc1403.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTcX2aAAoJEMsfJm/On5mBaz4P/iHHf4+kRWZxlsd2K4ASQJQD
XXq9+twsgHnZVhhcupVFtsoQ2oi8McBcd9uOuIPuuzTdmS8TuQoYaxZWIDKF8XV1
qIHnOne1MN9BGvv0zQ2D6wOMy7wYRPXN+LFY8ehd9E02qYThlwtR3XQBXPb52Q8Z
c/3z2fT1/5HYfU47n3FCmv99ih/8liFnwXWrFb9W20ifymt7Yv+eG2Ns7+L7J+e0
lABpirPZXXGLQia9TnraTkVOvPTA1y+aFlRIcqi5BY1zA+/IfbUingHR/7uMRnrf
rySLKUIDT15Ky4eUH/3dalZf/ICB+XljRLZcFZRqcDCMnYDAJwJZDwoBgX2GncYB
dAxYmktNDVDJpWo+Z71bGZjSrkLU3TSgp0MaR7XqxtpE5xOQ08T86Yu+Z4XFr7q1
yAkB7dt+bqZRzgKN68mWEZ/3hcGBfcV5Zfbea42u/Bl9uT7cD2UClQ14XrGu9zck
2OiJDwwjD+oo6iNsSFfD2DCve7VhlcRKB93t8K5ILHZ4OkDaPcs5FRr1pKGnYhb9
GTJYFoMxht7dXAL7uZx1YCjRtKOvG7ZP7kvVY+XE57bf9u1hx4+xLGx/3ld1Mjm2
fhL0A7UubOZHp2j5kxzMTGH5pF+hnNqjY4MpIqJSE2n7lLGJjy5baeCwzfrgSF7x
r/g7ylcBZy+KA8oPsZQ/
=q/QQ
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--
