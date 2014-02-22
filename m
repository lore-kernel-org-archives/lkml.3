Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbaBVDhl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 22:37:41 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:41846 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710AbaBVDhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 22:37:40 -0500
Date: Fri, 21 Feb 2014 19:37:34 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: torvalds@linux-foundation.org
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] hwmon fixes for 3.14-rc4
Message-ID: <20140222033734.GA10921@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="r5Pyd7+fXNt84Ff3"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull hwmon fixes for Linux 3.14-rc4 from signed tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Thanks,
Guenter
------

The following changes since commit 6d0abeca3242a88cab8232e4acd7e2bf088f3bc2:

  Linux 3.14-rc3 (2014-02-16 13:30:25 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git tags/hwmon-for-linus

for you to fetch changes up to 500a91571f0a5d0d3242d83802ea2fd1faccc66e:

  hwmon: (max1668) Fix writing the minimum temperature (2014-02-18 15:53:49 -0800)

----------------------------------------------------------------
Fix writing the minimum temperature in max1668 driver.

----------------------------------------------------------------
Guenter Roeck (1):
      hwmon: (max1668) Fix writing the minimum temperature

 drivers/hwmon/max1668.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--r5Pyd7+fXNt84Ff3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTCBt+AAoJEMsfJm/On5mBIgoQAIqtxCYFM6hrIHqg+/NEQCZp
UHn7fIx9c/ta/+sjyD14DatZOrhHpO7XfGp9ByGq0doIsLv60WtOgPuVOa+TS4+S
1T+Su7VVvMDOTJLTOA2tmT4CwR7jehJjtF8z+Lpp+XV2jTjrHZwqifJYqTU9JnmC
RRYi03MNk6ArA99TCRoIbbQnrjWuj01tr7KXeJuRQtTbtOxnM9BLRujoCVjC7JmR
P/WYm8pG+xzXObDr30A5g9VP2fUPDv4aXXTSMUVYMd+/Z6ZPedCNZW6YgCAgmTc8
hV7MG4rcFLVZuOYsP1UIrEYXyOPlmuN3k15DO3E2Xil+Re+J7VM6SX3zXaVNEZ8s
BuApaelZP3oggvpU5Nap8gH4cGrUh+RUs2xqYxq7VyFgXB47O4wk2YB6+9dG5yVT
hfnyRLEIJSfa2not1JaMqKqjqB6AgHad0GHCwZVkTUZUGMmB136MGhv4aJBXAn3u
PySDW+1KkWKIteEBPWsk49incM6E0ees3FK6pZwJGNengr1/w29ZSf42QvStHiqM
m08Vr1QfHijLWojOPQMUSX/6BBjlV4CAq4jZUuNYZlpZ4Dv1wxVVKOb3UrjkU1UJ
bAtu39ov5JlbX210Kow17YKZBYnWc4wMY7Lzrk0NCTHMG80+XRFSD+AjeJm5oeW/
pHB0YgVbiXi9JvcrMY4B
=/uiY
-----END PGP SIGNATURE-----

--r5Pyd7+fXNt84Ff3--
