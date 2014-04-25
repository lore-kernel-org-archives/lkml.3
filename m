Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353AbaDYP3M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 11:29:12 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:43751 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbaDYP3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 11:29:10 -0400
Date: Fri, 25 Apr 2014 08:29:06 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 3.15-rc3
Message-ID: <20140425152906.GB28665@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9zSXsLTf0vkW971A"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9zSXsLTf0vkW971A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull hwmon fixes for Linux 3.15-rc3 from signed tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Thanks,
Guenter
------

The following changes since commit a798c10faf62a505d24e5f6213fbaf904a39623f:

  Linux 3.15-rc2 (2014-04-20 11:08:50 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git tags/hwmon-for-linus

for you to fetch changes up to f75d72309192e52ef9a3efb390b1c4f408c142df:

  hwmon: (ltc2945) Don't crash the kernel unnecessarily (2014-04-24 06:09:43 -0700)

----------------------------------------------------------------
ltc2945: Don't unecessarily crash kernel on implementation error
vexpress: Fix 'name' and 'label' attributes

----------------------------------------------------------------
Guenter Roeck (1):
      hwmon: (ltc2945) Don't crash the kernel unnecessarily

Pawel Moll (2):
      hwmon: (vexpress) Use legal hwmon device names
      hwmon: (vexpress) Avoid creating non-existing attributes

 drivers/hwmon/ltc2945.c  |    6 ++--
 drivers/hwmon/vexpress.c |   83 +++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 74 insertions(+), 15 deletions(-)

--9zSXsLTf0vkW971A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTWn9CAAoJEMsfJm/On5mBHTIQAJnDgXl+nwj/hqDf5q3hMuhF
mBITNlKEEsPQ3VB8j3xzARIPg0rcGqGPzC7RngaXpbjQwHAHvY407tI0yUXCPXlG
l017bJfzvNHkga3parU7hG12vNY6h0kXxYKT7FBV3N4DlPu6BQ8yURqv9zleYztb
Gfybqi2sJlDV8ItjdNcX7d/wHxJmkZGg9Y9Fmcu4fYMDUPjgC5YvMhUAzo+Gmg/o
aO/nJ+vLwSuR9c+Oj0RKXxC85EZ3Gi0LrkAGauMu8vogh95F2xSBA4qljZT0Cgm8
++kQuBytWOx8gpB1av9Sv3PwPQw1Oe179lTCFZSXTZ3KE3IY6r9FspUMrHMWH7XP
zlAIqYC3Xt3gYzhGRa3jikQb5vtS833Bxo7ccq0Arep/bi+cQuWFDC/6Coo3JKjy
z+ng7HKicES3JO0sh6PChVtwXsGH8yO3LwmB/dVIfjYkaOB1XTzdOlNtmyHOeeAg
DhjEuVmugr2nTzVosm0YzVccVUqgPy+vUKJFqbbqLgnyVK4K/sfw/+ldKmO9VZg1
wp0PD/CfgWnqCUlLbb5thNQvg6zbdA0oKCEXJdx51qof6nSI+MalPKp0cut/Fo8I
wGIjIvK4C1ETTitL/QgE3rHxZZy9KVe4GsCq0NN6jn8NDPOt0nGbPIie/1AQnP2c
8syt3BAGERzHkble641l
=RolN
-----END PGP SIGNATURE-----

--9zSXsLTf0vkW971A--
