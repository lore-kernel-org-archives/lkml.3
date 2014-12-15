Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751607AbaLONcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 08:32:18 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:60543 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750716AbaLONcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 08:32:16 -0500
Date: Mon, 15 Dec 2014 13:32:08 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Eddie Huang <eddie.huang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        "srv_heupstream@mediatek.com" <srv_heupstream@mediatek.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Olof Johansson <olof@lixom.net>,
        "Joe.C" <yingjoe.chen@mediatek.com>,
        Robert Richter <rrichter@cavium.com>, Mark Brown <broonie@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        "yh.chen@mediatek.com" <yh.chen@mediatek.com>
Subject: Re: [PATCH 3/4] arm64: dts: Add mediatek MT8173 SoC and evaluation
 board dts and Makefile
Message-ID: <20141215133208.GC8264@leverpostej>
References: <1418208602-35584-1-git-send-email-eddie.huang@mediatek.com>
 <1418208602-35584-4-git-send-email-eddie.huang@mediatek.com>
 <20141211180245.GE28150@leverpostej>
 <1418371705.423.31.camel@mtksdaap41>
 <20141212164254.GK22670@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141212164254.GK22670@titan.lakedaemon.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 04:42:54PM +0000, Jason Cooper wrote:
> On Fri, Dec 12, 2014 at 04:08:25PM +0800, Eddie Huang wrote:
> > On Thu, 2014-12-11 at 18:02 +0000, Mark Rutland wrote:
> > > On Wed, Dec 10, 2014 at 10:50:01AM +0000, Eddie Huang wrote:
> ...
> > > > +	memory {
> > > 
> > > Nit: should be memory@40000000 (and you'll need to add device_type =
> > > "memory").
> > > 
> > > > +		reg = <0 0x40000000 0 0x40000000>;
> > > > +	};
> > 
> > skeleton.dtsi already has /memory node with address-cells=2,
> > size-cells=1, which will cause build warning if I change to use
> > memory@40000000, because we use size-cells=2. I will not include
> > skeleton.dtsi and follow your suggestion in next version.
> 
> There's skeleton64.dtsi in arch/arm/boot/dts (arm 32bit has LPAE-enabled
> systems).  Perhaps we should come up with a way to share both across the
> arches?

As I mentioned in my other reply [1], I think if anything it would be
better to get rid of the skeleton dtsi entirely.

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-December/310617.html

Thanks,
Mark.
