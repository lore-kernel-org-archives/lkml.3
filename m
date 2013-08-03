Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217Ab3HCOX1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 10:23:27 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:48742 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab3HCOXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 10:23:25 -0400
Date: Sat, 3 Aug 2013 07:23:26 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 3.11-rc4
Message-ID: <20130803142326.GA19561@roeck-us.net>
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

Hi Linus,

Please pull hwmon fixes for Linux 3.11-rc4 from signed tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Thanks,
Guenter
------

The following changes since commit 5ae90d8e467e625e447000cb4335c4db973b1095:

  Linux 3.11-rc3 (2013-07-28 20:53:33 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git tags/hwmon-for-linus

for you to fetch changes up to 5c52add19733eb36d8619713312f5604efef3502:

  hwmon: (max6697) fix MAX6581 ideality (2013-08-03 07:04:50 -0700)

----------------------------------------------------------------
Fix chip initialization/configuration in MAX6697 driver

----------------------------------------------------------------
Vivien Didelot (1):
      hwmon: (max6697) fix MAX6581 ideality

 drivers/hwmon/max6697.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--rwEMma7ioTxnRzrJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR/RJeAAoJEMsfJm/On5mBnesP/Ay9sQW6RnBirfLlcCGkzTVx
hWXkRafJK0VtESwTRmzXY8VjI3chqgmzn2AWh8NkhxoHVl90cX1NZ2PLGj/YRqk2
8RW1LAZ4rDYxjwi8PCsYMUscPhKpogYnor6sc+xEiMlKX7P0QN8aUlZxZmu+J6k6
4kLIw6hpZ0sWAGp2hzFhgmaccLkAALJ/Upn10HBsAjE2cYHaqsx5Zh6VVY3ssURy
QUeQc2xPaBnjJM5eSpRSBrJwitXfPXpiWc6vbGkwSDkKxpVOHWzRdZthU4o1tau5
TQTJBj4Tt/VBqNLjk/NLSNQUPJ2KJtH3Qf8ie6Hp1D3tG6ySzm0y0/nU7RKJC3iI
XFwLO8ZLEFHN1Wc8hBWvjZDphqY27ep/GIV0aW1d0V8AWeXNvgBMmMEdruphZyzq
LLfWsr9RyXZ/4qnKyOq9muUDEJxHG59GK3229rdORLwszbJxj1qnmvc4q8wMlP0E
W6yaqAZnqeAfCn+U7yc7d8ZM84U0hYD28HNpfy3sFY8pOi4EllyqYITCAapZpmWU
ngALVQs42KRxm46/jKrxhBJvxW7nb7IaTjLwnCUEoeISHlr93GW+Ed3pTFzVo+PF
GjiYgSic/ni2xtMdf1uoMqGkTbKBAfbfFygS0FSLRAts7Cn5eCRpmWSn8ppEp7Nt
rCcXCyMpRkmPQyjZatPD
=gYQG
-----END PGP SIGNATURE-----

--rwEMma7ioTxnRzrJ--
