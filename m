Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934881AbaGYRDx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 13:03:53 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:33337 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932508AbaGYRDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 13:03:52 -0400
Date: Fri, 25 Jul 2014 10:03:19 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fix for 3.16-rc7
Message-ID: <20140725170319.GB21458@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wac7ysb48OaltWcw"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull a hwmon fix for Linux 3.16-rc7 from signed tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Fat finger, this time signed and with Cc:. Sorry for the noise.

Thanks,
Guenter
------

The following changes since commit 9a3c4145af32125c5ee39c0272662b47307a8323:

  Linux 3.16-rc6 (2014-07-20 21:04:16 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git tags/hwmon-for-linus

for you to fetch changes up to 043572d5444116b9d9ad8ae763cf069e7accbc30:

  hwmon: (smsc47m192) Fix temperature limit and vrm write operations (2014-07-24 06:25:25 -0700)

----------------------------------------------------------------
Fixes to temperature limit and vrm write operations in smsc47m192 driver.

----------------------------------------------------------------
Guenter Roeck (1):
      hwmon: (smsc47m192) Fix temperature limit and vrm write operations

 drivers/hwmon/smsc47m192.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--wac7ysb48OaltWcw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT0o3XAAoJEMsfJm/On5mBAVgP/jg7wn/pqSMBE1Iwm9ml4Mk1
wk6v0r0pSIMjKmj5T2+CRQMR2KPcEvlArGZn2bsAqPMwxLxvVWFSTc8zj0c3NJgY
09t5SoKFnG2bg6QqFUuXNGpTtPQv4aA/v+1DxB1QFYrigS9XSt7oGSG/mxq8cxDj
jOYRcs5aeH+r7WKdPQUTj+yljG1TCd/znlcN0XIVwO3E839mWgkP75gkPSASwWVj
MnYl/Ynzjf6waanUFLHl26UOOTQpoMWq/8WwhX226yrXXaFV5bpax0OWzygk/m4z
z4U7IkF3AKM/wTCpxSgmEPijynQqExmWJriPUJ1Ih3v77jypeEc16/P3M5ROaeuJ
hv56s60F9DFpi3QniAa96jer40/j48SDpcmXGi2spU5WJzztVTPrxs1L9VRmjS+x
S2GuYAa3Nsp8165ge9cSe72DNC8dYllVci4NDfGQxS6ZIvVvgpRntM++Ydwz4lz7
w+xbKOmaPJRMZCuRdvocqX0LLySiJkmwcHYlwqQdbV29sJ995HgdiE3H7n9Wtblb
xvzkEN2fMUDSJ5kDEo1lUwWPnQ59NJEiqk02zYljJ0KyWsh2300/G/S/wj6qbtn4
cz3+J8Zua2MTbgsxP5GLziXv+s2L3QcihPDHUta/p0D4QCBGCntMnH05ir0dPcJ9
U14lvuGq6Ua5/ykC+Shz
=4McE
-----END PGP SIGNATURE-----

--wac7ysb48OaltWcw--
