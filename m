Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbaATQjd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 11:39:33 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:56651 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaATQjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 11:39:31 -0500
Date: Mon, 20 Jan 2014 08:39:29 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon updates for 3.14-rc1
Message-ID: <20140120163929.GA652@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull hwmon updates for Linux 3.14-rc1 from signed tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Thanks,
Guenter
------

The following changes since commit 3f9aec7610b39521c7c69d754de7265f6994c194:

  hwmon: (coretemp) Fix truncated name of alarm attributes (2014-01-14 09:47:52 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git tags/hwmon-for-linus

for you to fetch changes up to d303b1b5fbb688282bbf72a534b9dfed7af9fe4f:

  hwmon: (k10temp) Add support for Kaveri CPUs (2014-01-14 21:36:54 -0800)

----------------------------------------------------------------
Add support for Kaveri CPUs to k10temp driver. Add support for S12x0 to
coretemp driver.
Cleanup and minor fixes in several drivers. Notable are 'Do not return -EAGAIN
for low temperatures' to coretemp and 'Re-enable logical device mapping for
NCT6791 during resume' to nct6775. Both will be sent to -stable, but only
after some time in mainline.

----------------------------------------------------------------
Anthony Olech (1):
      hwmon: (da9052) Fix adc to voltage calculation

Guenter Roeck (5):
      hwmon: (coretemp) Use PCI host bridge ID to identify CPU if necessary
      hwmon: (coretemp) Add PCI device ID for CE41x0 CPUs
      hwmon: (coretemp) Refine TjMax detection
      hwmon: (coretemp) Do not return -EAGAIN for low temperatures
      hwmon: (nct6775) Re-enable logical device mapping for NCT6791 during resume

Jingoo Han (1):
      hwmon: remove DEFINE_PCI_DEVICE_TABLE macro

Phil Pokorny (1):
      hwmon: (k10temp) Add support for Kaveri CPUs

Sachin Kamat (1):
      hwmon: (s3c) Trivial cleanup in hwmon-s3c.h

Vivien Didelot (2):
      hwmon: (max197) add include guard
      hwmon: (sht15) add include guard

 drivers/hwmon/coretemp.c                |   58 ++++++++++++++++++++++---------
 drivers/hwmon/da9052-hwmon.c            |    4 +--
 drivers/hwmon/fam15h_power.c            |    2 +-
 drivers/hwmon/k10temp.c                 |    3 +-
 drivers/hwmon/k8temp.c                  |    2 +-
 drivers/hwmon/nct6775.c                 |   38 ++++++++++++++------
 drivers/hwmon/sis5595.c                 |    2 +-
 drivers/hwmon/via686a.c                 |    2 +-
 drivers/hwmon/vt8231.c                  |    2 +-
 include/linux/platform_data/hwmon-s3c.h |   10 +++---
 include/linux/platform_data/max197.h    |    5 +++
 include/linux/platform_data/sht15.h     |    5 +++
 12 files changed, 92 insertions(+), 41 deletions(-)

--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJS3VFBAAoJEMsfJm/On5mBxpoQAKd9ELrCA7pkAnJHzBamDpjc
EpVQAyI0zOD+LcXwNwBZcgY7aaUYQKmRyGXsGcr8kMV4w96xUBEKL5tKMYJ/GItk
5bxViSTqDYIXtLhhrk3TLkElMTO8v4aiDefWNMhbQPevao/peIxKmK8RyDncyJII
JfqKfLJzTjkTFA3GtkUTn+hvw+MAqLhJUxChscDWogCE5lcwgBL2+Lc3fYBXtKLz
7ECvTeZ90wE+7d/wIAv/1vKwSkD5Q6M6hBJFeTtpGy/q29AotxB5xkZRPofcG16k
MpXXmimNUVXkJVx0bpL88/H3bPKcU3yTl2CoZtdPQ2Vg47OJK/g60ObTONS0ffzt
eMAVfa+yKMrH7AOhYd2xvg+QOrlHSCQJ3T3rJCd9eRqubd3KzPgszC+0ct105Rmr
jaHdJeq/BfOIM8GOxuOFNWyqa/UTFAaDqwAQ2D+IF+b9VLb34Tm+cf75bzDJt49U
BrbGosPv3yY33sSerwcl6u3Be+4CEhhMoCh55bO2dS0IJyFcI14/8uI3aV+kLlbH
if703gqy3rr7wJVmE33inMdw4F/HdN+c8mWn5ByrkkzvguXMW+bLSlWFdgQ9vNO3
vXoaR8v0O+CByYqEzPU1vhLRRO6CjJmuiRRtjfTOc1CaPZ/jimZ8QSY5M6GE1vYp
+/hPtrJQSc6b8KB/UPko
=WWgo
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--
