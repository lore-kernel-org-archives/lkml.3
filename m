Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320AbaKTLXE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 06:23:04 -0500
Received: from mail.kernel.org ([198.145.19.201]:54775 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170AbaKTLXC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 06:23:02 -0500
Date: Thu, 20 Nov 2014 11:22:55 +0000
From: Lee Jones <lee@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Lee Jones <lee.jones@linaro.org>,
        Matthias Klein <matthias.klein@linux.com>
Subject: Re: [PATCH] ARM: bcm2835: Add device tree for Raspberry Pi model B+
Message-ID: <20141120112255.GB13269@x1>
References: <1416480765-13449-1-git-send-email-lee@kernel.org>
 <2041471.8rvf0EmQUU@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2041471.8rvf0EmQUU@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Nov 2014, Arnd Bergmann wrote:

> On Thursday 20 November 2014 10:52:45 Lee Jones wrote:
> > From: Matthias Klein <matthias.klein@linux.com>
> > 
> > The model B and B+ differ in the GPIO lines for ACT and PWR leds, and the
> > I2S interface.
> > 
> > Signed-off-by: Matthias Klein <matthias.klein@linux.com>
> > Tested-by: Stephen Warren <swarren@nvidia.com>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> > 
> > As requested by Arnd.
> > 
> >  arch/arm/boot/dts/Makefile               |  1 +
> >  arch/arm/boot/dts/bcm2835-rpi-b-plus.dts | 30 +++++++++++++++++++
> >  arch/arm/boot/dts/bcm2835-rpi-b.dts      | 46 ++--------------------------
> >  arch/arm/boot/dts/bcm2835-rpi.dtsi       | 51 ++++++++++++++++++++++++++++++++
> >  4 files changed, 85 insertions(+), 43 deletions(-)
> >  create mode 100644 arch/arm/boot/dts/bcm2835-rpi-b-plus.dts
> >  create mode 100644 arch/arm/boot/dts/bcm2835-rpi.dtsi
> > 
> 
> Applied to next/dt.
> 
> When you send a patch for inclusion the next time, better
> be explicit and ask for it to be picked up into arm-soc, so we
> know it's not just for review.

Sounds reasonable.  Thanks Arnd.
