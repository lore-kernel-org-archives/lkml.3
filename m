Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966811Ab3DQP6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 11:58:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50361 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965042Ab3DQP6S (ORCPT
	<rfc822;linux-kernel@Vger.kernel.org>);
	Wed, 17 Apr 2013 11:58:18 -0400
Date: Wed, 17 Apr 2013 16:58:15 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: [PATCH 0/4] mfd: arizona updates
Message-ID: <20130417155815.GA13687@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="livrSZtJkVq9DDdS"
Content-Disposition: inline
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--livrSZtJkVq9DDdS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit b50cf35bf41f8aa451667d8ff01e13b9ab17dc86:

  mfd: tps65090: Add compatible string for charger subnode (2013-04-11 00:16:29 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/misc.git tags/mfd-arizona-v3.10-2

for you to fetch changes up to 4618e0bd13ae937c4997236a76ba636b4b2befe2:

  mfd: Add device tree bindings for Arizona class devices (2013-04-17 16:38:28 +0100)

Hopefully not to late for v3.10, Charles' patch in particular should go
in.

----------------------------------------------------------------
mfd: arizona: Some more updates

A few fixes, some support for future devices and some very basic OF
bindings.

----------------------------------------------------------------
Charles Keepax (1):
      mfd: wm5102: Manually apply register patch

Mark Brown (3):
      mfd: arizona: Read the device identification information after boot
      mfd: arizona: Add missing cleanup on remove
      mfd: Add device tree bindings for Arizona class devices

 Documentation/devicetree/bindings/mfd/arizona.txt |   62 ++++++++
 drivers/mfd/arizona-core.c                        |  163 +++++++++++++++++----
 drivers/mfd/arizona-i2c.c                         |   10 +-
 drivers/mfd/arizona-spi.c                         |   10 +-
 drivers/mfd/arizona.h                             |   12 ++
 5 files changed, 222 insertions(+), 35 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/arizona.txt

--livrSZtJkVq9DDdS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRbsaQAAoJELSic+t+oim9eKoP/0bvvArYyQrwYQo1/BLPIYgt
R7quWcMurqUjXEZj5Mq3CzOnH9nyS5eWTCzKIp2I021lEssj4MB+QdbbLBUWwnow
iVWlhVrhp/OHI318X6lrUrvIIRAXTkclosG8RO0Kb9hmcDEyYcXioSpSrEWYlKX2
jhXdY3EPRMOqKrlX/lY29k5h6uBL5qHX3ZShgu0HlKFy+Aq6TQYjf5KfhxvbY6MB
4z3UbnAFW3NNLFttj6JIeejodqww5/2fAy8nhwRmOmLwNKymXG1FxY6/f8gvMH/V
WSAPOhOvx35qRI5OnKR7dbDlexQr/gD+Qy2aXlHasBUfN7n20bxaYCipjKtGgECR
AMexmc9AW4MQ+4YQoMg+UnKie18uZp0erxRIMVhu/VX154AF9XwdH1LqG+A8w/F7
84aOnKaHv9lsfemBPSmFy5rafTBUUSHKOHCgMp6do7XHwzMHoIapWRmTgFQNkJU4
Ie+LdX6V+qGkH6XhccilT1Jlzd5X29LwWnCcp2oS0wF5m01YRD00cDF/gmQe6qHt
ti7R+IE0/iC7JqvNRxQVQfXyEy3Dc1Y86rhTJdHPZkyZQDaPIIdUClAdI//IYHu1
ExJ32CpOBaZwylArKdc1G3p9/XFiwrV68n56njiFRe8HQ2Aya9J/+buEcBXHn/79
x797YWmsfuALS3Gs/ji0
=5VI7
-----END PGP SIGNATURE-----

--livrSZtJkVq9DDdS--
