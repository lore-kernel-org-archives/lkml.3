Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209AbaIQVcW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 17:32:22 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:54182 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756555AbaIQVcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 17:32:20 -0400
Date: Wed, 17 Sep 2014 14:32:16 -0700
From: Lee Jones <lee.jones@linaro.org>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        Johan Hovold <jhovold@gmail.com>, Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 9/9] mfd: syscon: add Atmel GPBR DT bindings
 documention
Message-ID: <20140917213216.GS30918@lee--X1>
References: <1410441525-25258-1-git-send-email-boris.brezillon@free-electrons.com>
 <1410441525-25258-10-git-send-email-boris.brezillon@free-electrons.com>
 <20140917163405.GM30918@lee--X1>
 <20140917195727.1c75a062@bbrezillon>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140917195727.1c75a062@bbrezillon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Sep 2014, Boris BREZILLON wrote:
> On Wed, 17 Sep 2014 09:34:05 -0700
> Lee Jones <lee.jones@linaro.org> wrote:
> 
> > On Thu, 11 Sep 2014, Boris BREZILLON wrote:
> > 
> > > The GPBR block provides a set of battery-backed registers that can be used
> > > to save data which need to be kept when the system is powered down and
> > > VDD-core is maintained by an external battery.
> > > 
> > > A typical usage is the RTT block (when used as an RTC) which needs one of
> > > those registers to save the current time.
> > > 
> > > Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> > > ---
> > >  Documentation/devicetree/bindings/mfd/atmel,gpbr.txt | 15 +++++++++++++++
> > >  1 file changed, 15 insertions(+)
> > >  create mode 100644 Documentation/devicetree/bindings/mfd/atmel,gpbr.txt
> > > 
> > > diff --git a/Documentation/devicetree/bindings/mfd/atmel,gpbr.txt b/Documentation/devicetree/bindings/mfd/atmel,gpbr.txt
> > > new file mode 100644
> > > index 0000000..a285695
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/mfd/atmel,gpbr.txt
> > > @@ -0,0 +1,15 @@
> > > +* Device tree bindings for Atmel GPBR (General Purpose Backup Registers)
> > > +
> > > +The GPBR are a set of battery-backed registers.
> > > +
> > > +Required properties:
> > > +- compatible:		"atmel,at91sam9260-gpbr", "syscon"
> > > +- reg:			contains offset/length value of the GPBR memory
> > > +			region.
> > > +
> > > +Example:
> > > +
> > > +gpbr: gpbr@fffffd50 {
> > 
> > Is something referencing this node via phandle?  If not, please remove
> > the label.
> 
> Yes, the rtt device is referencing it in its atmel,rtt-rtc-time-reg
> property (see patch 8 of this series).

How can I?  You only sent me patch 9.

Patch looks good, I'm going to apply it.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
