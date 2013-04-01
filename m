Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048Ab3DAR1x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 13:27:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47065 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754457Ab3DAR1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 13:27:52 -0400
Date: Mon, 1 Apr 2013 18:27:49 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: [PATCH 0/15] arizona updates for v3.10
Message-ID: <20130401172748.GG18636@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dClnwdpHIAy5TST4"
Content-Disposition: inline
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dClnwdpHIAy5TST4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 07961ac7c0ee8b546658717034fe692fd12eefa9:

  Linux 3.9-rc5 (2013-03-31 15:12:43 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/misc.git tags/mfd-arizona-3.10

for you to fetch changes up to b66b1364683c6710e110196b6bf4123675a380bf:

  mfd: wm5102: Update defaults to match patch (2013-04-01 18:09:47 +0100)

----------------------------------------------------------------
mfd: arizona: Updates for v3.10

This is really a few separate topics which I can split out if required:

 - WM5102 updates to improve robustness
 - Improved support for interoperation with edge triggered interrupt
   controllers
 - Support for some unusual clocking configurations
 - A couple small single patch updates and fixes

----------------------------------------------------------------
Charles Keepax (5):
      mfd: wm5102: Manually apply register patch
      mfd: arizona: Factor out register polling
      mfd: arizona: Add a hardware patch mechanism
      mfd: wm5102: Deactivate standard boot sequence
      mfd: wm5102: Update defaults to match patch

Mark Brown (10):
      mfd: arizona: Disable all wake sources by default
      mfd: arizona: Clarify error message for failed primary IRQ request
      mfd: arizona: Basic support for edge triggered IRQs
      mfd: arizona: Allow GPIO to be specified for IRQ line
      mfd: arizona: Try to use interrupt flags from interrupt controller
      mfd: arizona: Support configuring MICBIASes into bypass mode
      mfd: wm5102: Update patch for latest evaluation
      mfd: arizona: Fully support the use of MCLK1 as the 32kHz clock source
      mfd: arizona: Unconditionally enable 32kHz clock
      mfd: wm5102: Only use the lowest three bits of device revision

 arch/arm/mach-s3c64xx/mach-crag6410-module.c |    4 +-
 drivers/mfd/arizona-core.c                   |  205 ++++++++++++++++++++++----
 drivers/mfd/arizona-irq.c                    |  106 ++++++++++---
 drivers/mfd/wm5102-tables.c                  |   56 +++++--
 include/linux/mfd/arizona/pdata.h            |    7 +-
 5 files changed, 312 insertions(+), 66 deletions(-)

--dClnwdpHIAy5TST4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRWcONAAoJELSic+t+oim962oP+wXW/BJFzHlI/Jo6CWeOF/2F
kvlcjLdmyjNvCKZFBix3ulvAItKNa8z7v5R2Yc7UAmGr/X9TJBTHHQ4oFWqSh61f
0tjIFYEzghdOLl0dpBPSNUldvoglCGnN/wVA82hbWYqvKxGLIN1h0Qjeu5Qzb2Nm
2ZZTFRSb5Z3O5s12XTwNZYw/+BaRJWTCcrvlSzToLuTuJdhh9lbLLp6kr4kKX8+k
J0gSqDuDgqJjAEJV+beoY7eNf/NrHjlYyjKIVkZdXM/GBTngBtFVV5LnsQOHtymD
/lLZH8W1xdxXDphIN0T7vYSNJemdPUAZWdt8K/tCCzzCv7e1DcVU//WvRCIqsBK4
5GcYwoL1UmBRy+jjmTgTbhxL4V+AyWZ/iLbLEoIndAUaAop99j58kPaE9g9/7b5F
ox2+bAepHTOeDHyA2XUrlIZPzE0aSHU8hAOabSjewQl/RLcPeJq8YVe1TOUrreXZ
iAtEM5r/soZBEqgDFjw/kxRxtptkOOv72ge9J7z+a0B0NjLyn8NlUKqhhO/L1iB5
D8JhO6cSpzc4smj4iRZ5MPn2S00pVMfKmOlXmslJtQoQ/dnyp807/oZy76FHmsE8
WX5IM50OEwYG2SK/QhZ/vro1+gcvZn6GOO5RotG9nB8HnrpIudyCv3crir9ub6yM
qjhSShWKYEzlkA/5yjMb
=UXTQ
-----END PGP SIGNATURE-----

--dClnwdpHIAy5TST4--
