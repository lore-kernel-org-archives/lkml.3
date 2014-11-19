Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208AbaKSR3k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 12:29:40 -0500
Received: from mail.kernel.org ([198.145.19.201]:58611 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754998AbaKSR3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 12:29:38 -0500
Date: Wed, 19 Nov 2014 17:29:31 +0000
From: Lee Jones <lee@kernel.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Matthias Klein <matthias.klein@linux.com>,
        linux-rpi-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ARM: bcm2835: add device tree for Raspberry Pi model
 B+
Message-ID: <20141119172931.GK1875@x1>
References: <1415231123-920-1-git-send-email-matthias.klein@linux.com>
 <20141119152951.GA1875@x1>
 <546CCE73.4020708@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546CCE73.4020708@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Nov 2014, Stephen Warren wrote:

> On 11/19/2014 08:29 AM, Lee Jones wrote:
> >>The model B and B+ differ in the GPIO lines for ACT and PWR leds, and the
> >>I2S interface.
> >>
> >>Signed-off-by: Matthias Klein <matthias.klein@linux.com>
> >>---
> >>Changes in v2:
> >>- move the common parts between the B and B+ model into the new bcm2835-rpi.dtsi file
> >>
> >>- add the I2S signals to the B+ file which fix the problem that USB is not working
> >>   with the current bcm2835-rpi-b.dts file on the B+.
> >>---
> >>  arch/arm/boot/dts/Makefile               |  1 +
> >>  arch/arm/boot/dts/bcm2835-rpi-b-plus.dts | 30 +++++++++++++++++++
> >>  arch/arm/boot/dts/bcm2835-rpi-b.dts      | 46 ++--------------------------
> >>  arch/arm/boot/dts/bcm2835-rpi.dtsi       | 51 ++++++++++++++++++++++++++++++++
> >>  4 files changed, 85 insertions(+), 43 deletions(-)
> >>  create mode 100644 arch/arm/boot/dts/bcm2835-rpi-b-plus.dts
> >>  create mode 100644 arch/arm/boot/dts/bcm2835-rpi.dtsi
> >
> >Sorry for the delay.  I thought RPi world was exceptionally quiet, but
> >in fact I had issues with my newly setup mailbox and filters.  All
> >rectified now in any case.
> >
> >It might be worth noting that this will not likely land in v3.19, as
> >we are one step removed from Linus (i.e. via ARM SoC) and they usually
> >like to have pull-requests in by -rc5.  Unless anyone stamps their
> >feet, I'll be sending this no sooner than v3.20.
> 
> -rc6 is the usual cut-off, and the arm-soc maintainers have said
> that's not always a very strict cut-off; it depends on how invasive
> the patch is (which this isn't) and whether the patch has been in
> linux-next already before getting into arm-soc (and linux-rpi.git's
> for-next branch is in linux-next).

Okay, looks like I'm off-by-one -- I ways thought the cut-off was
-rc5.  Nevertheless, I'll have the patch in -next by tonight (tomorrow
at the latest, as it's getting late and I need to wait for a previous
test-build to finish before I can run this patch), let it stew there
for a couple of weeks and fire them a pull-request around -rc6 and see
what happens.
