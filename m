Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629AbaGHRBN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 13:01:13 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:58834 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbaGHRBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 13:01:11 -0400
Date: Tue, 8 Jul 2014 10:01:07 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 3.16-rc5
Message-ID: <20140708170107.GA13973@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull hwmon fixes for Linux 3.16-rc5 from signed tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Thanks,
Guenter
------

The following changes since commit 4c834452aad01531db949414f94f817a86348d59:

  Linux 3.16-rc3 (2014-06-29 14:11:36 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git tags/hwmon-for-linus

for you to fetch changes up to 7fe7381cbdadf16792e733789983690b3fa82880:

  hwmon: (adc128d818) Drop write support on inX_input attributes (2014-07-07 09:48:23 -0700)

----------------------------------------------------------------
Fix a number of zero-day bugs, mostly found with module test scripts.
Nothing major, but potentially annoying and worthwhile to fix.

----------------------------------------------------------------
Axel Lin (3):
      hwmon: (amc6821) Fix permissions for temp2_input
      hwmon: (adm1029) Ensure the fan_div cache is updated in set_fan_div
      hwmon: (adm1021) Fix cache problem when writing temperature limits

Guenter Roeck (3):
      hwmon: (adm1031) Fix writes to limit registers
      hwmon: (emc2103) Clamp limits instead of bailing out
      hwmon: (adc128d818) Drop write support on inX_input attributes

Naveen Krishna Chatradhi (1):
      hwmon: (ntc_thermistor) Correct information printed during probe

 drivers/hwmon/adc128d818.c     | 28 ++++++++++++++--------------
 drivers/hwmon/adm1021.c        | 14 ++++++++------
 drivers/hwmon/adm1029.c        |  3 +++
 drivers/hwmon/adm1031.c        |  8 +++++---
 drivers/hwmon/amc6821.c        |  2 +-
 drivers/hwmon/emc2103.c        | 15 +++++----------
 drivers/hwmon/ntc_thermistor.c |  2 +-
 7 files changed, 37 insertions(+), 35 deletions(-)

--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTvCPTAAoJEMsfJm/On5mB5XIP+wRlGvJ1agEHIHMTGyRMT8DU
YQgw4WGE2RZhGmlUePz973GVBFd5xt3kNUii4EN5vXtYN4uJzXjAqie/xboWdzD2
deg37OE6cGNzsTiUtF8Xeoec3P6bp6hy3XSO5MFldTVJ0q+rGNeidE7ekzOD/IHH
O7488rdfMgj5ufmPib933P0YQTq9JdXYczCNEp6OT3tsUIpWBU8UenYHqMhfWJus
UDbBpTglJv6WvmTK6MJ0tE5vX/mE1ttQBTzxvhCXM+20Qv7aoW5qHx8/9Q2oLJ12
VKcDGNoQuIIfmKLBw08Wu7o63nm9Pp0+4Z8x8j/X+H0TgaYZYwarmAvFbUO00lsT
djrzAoPoKpIQFB8XZFWD8skOAtxwRERD//LvZQBiv+Uwbe7R4AJFpBvOT2Z5afqI
ksWu8Pi78mpwS6HLczk0/pVJ7AzStNkFC2WswIde6OpFbXs+gYHEQB18quGpY03V
jo0SbHzhQTv8tcjhefzAtnv6ZnBmixtymLe+52MR5z5nGa/jPKWMCKmwSqMXumo/
lqj5SMKXcaoaUMm4QbMHLBRVPv5wFw9Wbfd89POUnDmGnYlBZb9OXu6PUQY7MQKp
JWbwzTtq4ej3U39K9QfRoXIehysE23HlQscJfP978J5qjoLkq6FVeu2TbNLjtn8D
s6r3Glb8KqVH8Qcj7Ejh
=0nLk
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--
