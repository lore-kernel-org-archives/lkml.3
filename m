Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260AbbAPOLi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 09:11:38 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:36055 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879AbbAPOLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 09:11:35 -0500
Date: Fri, 16 Jan 2015 14:11:09 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Lyra Zhang <zhang.lyra@gmail.com>
Cc: Chunyan Zhang <chunyan.zhang@spreadtrum.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "gnomes@lxorguk.ukuu.org.uk" <gnomes@lxorguk.ukuu.org.uk>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        Will Deacon <Will.Deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "jslaby@suse.cz" <jslaby@suse.cz>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "heiko@sntech.de" <heiko@sntech.de>,
        "florian.vaussard@epfl.ch" <florian.vaussard@epfl.ch>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "rrichter@cavium.com" <rrichter@cavium.com>,
        "hytszk@gmail.com" <hytszk@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "antonynpavlov@gmail.com" <antonynpavlov@gmail.com>,
        "Joel.Schopp@amd.com" <Joel.Schopp@amd.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "jorge.ramirez-ortiz@linaro.org" <jorge.ramirez-ortiz@linaro.org>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "orsonzhai@gmail.com" <orsonzhai@gmail.com>,
        "geng.ren@spreadtrum.com" <geng.ren@spreadtrum.com>,
        "zhizhou.zhang@spreadtrum.com" <zhizhou.zhang@spreadtrum.com>,
        "lanqing.liu@spreadtrum.com" <lanqing.liu@spreadtrum.com>,
        "wei.qiao@spreadtrum.com" <wei.qiao@spreadtrum.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        Leo Yan <leo.yan@linaro.org>
Subject: Re: [PATCH v5 2/5] Documentation: DT: Add bindings for Spreadtrum
 SoC Platform
Message-ID: <20150116141109.GC22569@leverpostej>
References: <1421402411-3479-1-git-send-email-chunyan.zhang@spreadtrum.com>
 <1421402411-3479-3-git-send-email-chunyan.zhang@spreadtrum.com>
 <20150116102135.GC21809@leverpostej>
 <CAAfSe-teDdPzRUnvzM+NErfZwmqM04yUMgic--hyZL8-Jjd8jw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAfSe-teDdPzRUnvzM+NErfZwmqM04yUMgic--hyZL8-Jjd8jw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2015 at 12:53:16PM +0000, Lyra Zhang wrote:
> Hi, Mark
> 
> >> +
> >> +Required properties:
> >> +- compatible: must be "sprd,sc9836-uart"
> >> +- reg: offset and length of the register set for the device
> >> +- interrupts: exactly one interrupt specifier
> >> +- clocks: phandles to input clocks.
> >
> > The order and relevance of each should be specified. If you have
> > multiple clocks I would strongly recommend you use clock-names to
> > distinguish them.
> >
> 
> Thank you for the recommendation.
> but, since we haven't made the clock driver ready, for this initial
> commit, we just let 4 UARTs share a single fixed 26 MHz clock source.
> we'll do like you've recommended when we will submit the clock driver
> in the future.

I'm on about the clock input lines on the UART instance, not the
providers they come from.

Is there only a single clock input line on each UART? Perhaps multiple
input lines which are currently fed by the same clock?

Thanks,
Mark.
