Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990Ab3F0SJp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 14:09:45 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:40025 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753849Ab3F0SJl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 14:09:41 -0400
From: "Fernandes, Joel" <joelf@ti.com>
To: "Krishnamoorthy, Balaji T" <balajitk@ti.com>,
        "Cousson, Benoit" <b-cousson@ti.com>
CC: "lars@metafoo.de" <lars@metafoo.de>, Tony Lindgren <tony@atomide.com>,
        "Nori, Sekhar" <nsekhar@ti.com>, Matt Porter <matt@ohporter.com>,
        "Grant Likely" <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>, Mark Brown <broonie@linaro.org>,
        "Russell King" <linux@arm.linux.org.uk>, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Kridner <jkridner@beagleboard.org>,
        "Koen Kooi" <koen@beagleboard.org>, Chris Ball <cjb@laptop.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, "lars@metafoo.de" <lars@metafoo.de>
Subject: RE: [PATCH 0/5] AM33xx: MMC resources from DT without HWMOD data
Thread-Topic: [PATCH 0/5] AM33xx: MMC resources from DT without HWMOD data
Thread-Index: AQHOc0JBa2Q1+uiBuUi8y9XUd9fX75lKE40A///GQbA=
Date: Thu, 27 Jun 2013 18:08:55 +0000
Message-ID: <083BC63EECB6FD41B8E81CF7FD87CC0F2E4F0F95@DLEE08.ent.ti.com>
References: <1372209808-6532-1-git-send-email-joelagnel@ti.com>
 <CAD=GYpbdVVrh-tiqOcbHi3mkWRJUBdx0EsEZEFVVbgFgcCWgsw@mail.gmail.com>
 <51CC2A1E.2040003@ti.com>
 <CAD=GYpa9LQ1fV6=O9B65sJURVAigsgXCPLWav8cHXTuGQXPc9A@mail.gmail.com>
 <51CC67CA.2070805@ti.com>
In-Reply-To: <51CC67CA.2070805@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.170.170.90]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Balaji,

> -----Original Message-----
> From: Krishnamoorthy, Balaji T
> Sent: Thursday, June 27, 2013 11:27 AM
> To: Cousson, Benoit; Fernandes, Joel
> Cc: lars@metafoo.de; Tony Lindgren; Nori, Sekhar; Matt Porter; Grant Likely;
> Rob Herring; Vinod Koul; Mark Brown; Russell King; Rob Landley; Andrew
> Morton; Jason Kridner; Koen Kooi; Chris Ball; Devicetree Discuss; Linux OMAP
> List; Linux ARM Kernel List; Linux DaVinci Kernel List; Linux Kernel Mailing List;
> Linux MMC List; Arnd Bergmann
> Subject: Re: [PATCH 0/5] AM33xx: MMC resources from DT without HWMOD
> data
> 
> On Thursday 27 June 2013 07:56 PM, Joel A Fernandes wrote:
> > Hi Benoit,
> >
> > On Thu, Jun 27, 2013 at 7:03 AM, Benoit Cousson <b-cousson@ti.com> wrote:
> >> Hi Joel,
> >>
> >> On 06/26/2013 05:28 AM, Joel A Fernandes wrote:
> >>> On Tue, Jun 25, 2013 at 8:23 PM, Joel A Fernandes <joelagnel@ti.com>
> wrote:
> >>>> From: Joel A Fernandes <agnel.joel@gmail.com>
> >>>>
> >>>> This series is fixes to get MMC working on AM33XX without HWMOD
> data.
> >>>> On removal of HWMOD data, interrupt and register properties need to
> >>>> be provided for the driver to function correctly.
> >>>
> >>> Please don't pull patches authored by me in this series. I have
> >>> posted them with my wrong email address by mistake. I will correct
> >>> my email during the next repost, after a round of review. Matt's
> >>> patches in the series are still good though.
> >>
> >> In that case, please repost these in two series to avoid pulling the
> >> DTS files in the MMC tree.
> >
> > The series has been replaced with the single patch:
> > "[PATCH v2] ARM: dts: add AM33XX MMC support"
> > http://marc.info/?l=linux-omap&m=137230403815943&w=2
> >
> > Some patches were squashed and others dropped in the series resulting
> > in the single patch above. This patch should be good to apply
> Hi Joel,
> 
> Before pushing mmc dts support for am335x, Can you please let me
> know if below 2 patches [1] are merged/accepted,
> IIRC these patches are needed for MMC to work properly.
> 
> I suggest to hold the dts patch until slave_sg_limit gets merged
> otherwise it will cause regression in am335x mmc.
> 
> [PATCH v4 1/3] dmaengine: add dma_get_slave_sg_limits()
> [PATCH v4 2/3] dma: edma: add device_slave_sg_limits() support

Actually this is an independent regression and is currently worked on by Lars-Peter Clausen [1].

Currently not having the MMC DTS merged is also a regression, so I suggest lets take it one
step at a time and get the DTS merged in first. Also there will be overhead of reposting this
DTS patch later again which will not change. What do you say?

Thanks,

-Joel

[1] https://patchwork.kernel.org/patch/2228041/
