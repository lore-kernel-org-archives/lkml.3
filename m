Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353Ab3JJW23 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 18:28:29 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:39209 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab3JJW22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 18:28:28 -0400
Date: Thu, 10 Oct 2013 15:28:21 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 3.12-rc5
Message-ID: <20131010222821.GA7679@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OXfL5xGRrasGEqWY"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull hwmon fixes for Linux 3.12-rc5 from signed tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Thanks,
Guenter
------

The following changes since commit 15c03dd4859ab16f9212238f29dd315654aa94f6:

  Linux 3.12-rc3 (2013-09-29 15:02:38 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon

for you to fetch changes up to 25f2bd7f5add608c1d1405938f39c96927b275ca:

  hwmon: (applesmc) Always read until end of data (2013-10-09 09:48:55 -0700)

----------------------------------------------------------------
Fix root cause of crash/error seen in applesmc driver

----------------------------------------------------------------
Henrik Rydberg (1):
      hwmon: (applesmc) Always read until end of data

 drivers/hwmon/applesmc.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--OXfL5xGRrasGEqWY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSVyoEAAoJEMsfJm/On5mBS+cP/j5oTslz41dU3p9Axu0T5uWV
TJKsCrXmLGmx/JF7ZP8FCHC+gPu8maCuo0pZySg4mPQVGojvG2V8SqUiVkHYQQBQ
K0OR74If2D3S8lQZMdMZSpd0N/cka0ULwnvIPwGT3GkG/p5Hld/m5qmIfUIkspaG
zYThNfsG9rkreBs7kJIVVNMXM8NlyNxPmfmUJf1UL8MxNbgxwOH7yWCj2UwusXmf
klqQbCnV3a3zvTbyyA0TpY5HsbDvuTd5kfqMQ4A4RGFfbLftvxyZJbbd9pxfrsG3
UfPyZ2txnUoHoyboqESlah6GWT4MtnIDUZ0S92iA3AOu8oy+e92vqLMWUKcQheAZ
7B8gzI/bBQTT+IEPJB5ufNnxYj8ntI4ZNs0hatES+9/1VZqY8y4qbV2z36vXx5tO
6S9tjXXV017AKx5XJRovzuUdO3b/lwFaekP6PdGLnpFwmD/sJ7dKh/nPGOfJlWGU
VsFaaQ9SKO1bpEKo2RtJiRwC/cbqRKR8pKFYM0weveIFHIbtK+uN2i2R53moRgsT
qk4cwCCUYKbdKh7+IfgATZMv9AGpEx4iheXyu/A3wHXb7891t7fYpf8JOTp3AiTE
08h/rkzrQMbiOQGFv3T+qrDUVr7LrkPLfCmhlH+W1bD1X4Qd4Vcgkn0cxNvfF+zq
Lnh+iGjEOHX9zR6zGUe/
=a64M
-----END PGP SIGNATURE-----

--OXfL5xGRrasGEqWY--
