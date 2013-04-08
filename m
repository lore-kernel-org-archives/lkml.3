Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936532Ab3DHKUL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:20:11 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39409 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935524Ab3DHKTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 06:19:52 -0400
Date: Mon, 8 Apr 2013 11:19:51 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/15] arizona updates for v3.10
Message-ID: <20130408101951.GD9243@opensource.wolfsonmicro.com>
References: <20130401172748.GG18636@opensource.wolfsonmicro.com>
 <20130403180423.GA6985@opensource.wolfsonmicro.com>
 <20130408092556.GL24058@zurbaran>
 <20130408093842.GA23639@zurbaran>
 <20130408100409.GB9243@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q0rSlbzrZN6k9QnT"
Content-Disposition: inline
In-Reply-To: <20130408100409.GB9243@opensource.wolfsonmicro.com>
X-Cookie: Your love life will be... interesting.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Q0rSlbzrZN6k9QnT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 08, 2013 at 11:04:10AM +0100, Mark Brown wrote:

> patch series...  I'm just re-tagging and re-pushing but were you testing
> both serieses together?

OK, the mirrors seem to have the rebase now.  New pull request:

The following changes since commit 31880c37c11e28cb81c70757e38392b42e695dc6:

  Linux 3.9-rc6 (2013-04-07 20:49:54 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/misc.git tags/mfd-arizona-3.10

for you to fetch changes up to 031eb8d52ecbe417cf778fba2d49bee90a078648:

  mfd: wm5102: Don't wait for boot when boot sequencer is disabled (2013-04-08 11:12:04 +0100)

----------------------------------------------------------------
mfd: arizona: Updates for v3.10

This is really a few separate topics which I can split out if required:

 - WM5102 updates to improve robustness
 - Improved support for interoperation with edge triggered interrupt
   controllers
 - Support for some unusual clocking configurations
 - A couple small single patch updates and fixes

----------------------------------------------------------------
Charles Keepax (7):
      mfd: wm5102: Manually apply register patch
      mfd: arizona: Factor out register polling
      mfd: arizona: Add a hardware patch mechanism
      mfd: wm5102: Deactivate standard boot sequence
      mfd: wm5102: Update defaults to match patch
      mfd: arizona: Wait for internal clocks to startup after reset
      mfd: wm5102: Don't wait for boot when boot sequencer is disabled

Mark Brown (12):
      mfd: arizona: Disable all wake sources by default
      mfd: arizona: Clean up on failed runtime resume
      mfd: arizona: Clarify error message for failed primary IRQ request
      mfd: arizona: Basic support for edge triggered IRQs
      mfd: arizona: Allow GPIO to be specified for IRQ line
      mfd: arizona: Try to use interrupt flags from interrupt controller
      mfd: arizona: Support configuring MICBIASes into bypass mode
      mfd: wm5102: Update patch for latest evaluation
      mfd: arizona: Fully support the use of MCLK1 as the 32kHz clock source
      mfd: arizona: Unconditionally enable 32kHz clock
      mfd: wm5102: Only use the lowest three bits of device revision
      mfd: arizona: Hold device in reset while ramping supplies

 arch/arm/mach-s3c64xx/mach-crag6410-module.c |    4 +-
 drivers/mfd/arizona-core.c                   |  267 +++++++++++++++++++++-----
 drivers/mfd/arizona-irq.c                    |  106 ++++++++--
 drivers/mfd/wm5102-tables.c                  |   56 ++++--
 include/linux/mfd/arizona/pdata.h            |    7 +-
 5 files changed, 357 insertions(+), 83 deletions(-)

--Q0rSlbzrZN6k9QnT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRYpm+AAoJELSic+t+oim9tKcQAIxVMfQMVSwqkMtDm4jynf/h
QVOL9Fmb671lgTsY5RZS+wajRDj0xUUGNB13fbr5+Y4ukTDihbOnOYPRMgToUKpq
DO6F/oxF7sonJu2BaPnbJGWNpsrTJLYiXhPxXD7HcujaLQZVYEbQjXK3bo2YnQB6
9fYrMw5bNDMB/+0hdX1Z3QFH9pln9TowzQ8RCkem7nrMkLgSIOenM1H8ps+WabHi
eYkQnmS5KWaLilktOHdYitI8rC3M+WImuBQRQRE8GAMZTJg9KGPawMFExGZJYTIX
ykEijCibka+m1FOI5yoFdEOcv58FTinuGZAwVr7ELzT87w2PJ6yrg6sbZrx2sdPj
m+4ekC//SWTQ7315jt/lcThw/TBXBxGqvBz8aPcFGcVtZGIGVYZ21E5QXvBd9QGL
v+H+iW92wF3q+N8sPD6lIn6ip4OVkHaPOhvavgbAvpzfP6quc2DAYp0ZDRGVdiE0
eTc18lUq1rQaXhDCtPsmITO20b2DfPXCFQEFRrmQaBEp4aBbWOZH1IfwpaNPHVeS
O3I7RpnQrXa1BigC9G1p1q0IWLQx1o7nyCmIE8NbnZXr0y2xeyQF6Ne34xNZLcGE
QrPCaDj0TkBi8hx/SQsykbiLRZ/S1mFwImwXWImWMfhL5rqGYZgFasgSxWZNQSBT
mRCCSL01cyifqT7w74dx
=lR66
-----END PGP SIGNATURE-----

--Q0rSlbzrZN6k9QnT--
