Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341AbaJWQUM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 12:20:12 -0400
Received: from gloria.sntech.de ([95.129.55.99]:43842 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972AbaJWQUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 12:20:10 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Joerg Roedel <joro@8bytes.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>, Simon Xue <xxm@rock-chips.com>,
        Grant Grundler <grundler@chromium.org>,
        =?ISO-8859-1?Q?St=E9phane?= Marchesin <marcheu@chromium.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:IOMMU DRIVERS" <iommu@lists.linux-foundation.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>
Subject: Re: [PATCH 0/3] Rockchip IOMMU driver and devicetree bindings
Date: Thu, 23 Oct 2014 18:23 +0200
Message-ID: <2804227.ziAnEUAn0E@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <CAGS+omB+si1J-gjyvyjJF0x=QBTyPyNKbqyV0QM=sKNo9zecDw@mail.gmail.com>
References: <1412158843-8115-1-git-send-email-djkurtz@chromium.org> <20141022152019.GK10074@8bytes.org> <CAGS+omB+si1J-gjyvyjJF0x=QBTyPyNKbqyV0QM=sKNo9zecDw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 24. Oktober 2014, 00:11:06 schrieb Daniel Kurtz:
> On Wed, Oct 22, 2014 at 11:20 PM, Joerg Roedel <joro@8bytes.org> wrote:
> > On Wed, Oct 01, 2014 at 06:20:40PM +0800, Daniel Kurtz wrote:
> > > Add a driver and devicetree bindings for the IOMMU found in Rockchip
> > 
> > RK3288
> > 
> > > SoCs.
> > > 
> > > Daniel Kurtz (3):
> > >   iommu/rockchip: rk3288 iommu driver
> > >   dt-bindings: iommu: Add documentation for rockchip iommu
> > >   ARM: dts: rk3288: add VOP iommu nodes
> > >  
> > >  .../devicetree/bindings/iommu/rockchip,iommu.txt   |  26 +
> > >  arch/arm/boot/dts/rk3288.dtsi                      |  18 +
> > >  drivers/iommu/Kconfig                              |  11 +
> > >  drivers/iommu/Makefile                             |   1 +
> > >  drivers/iommu/rockchip-iommu.c                     | 924
> > 
> > +++++++++++++++++++++
> > 
> > >  5 files changed, 980 insertions(+)
> > >  create mode 100644
> > 
> > Documentation/devicetree/bindings/iommu/rockchip,iommu.txt
> > 
> > >  create mode 100644 drivers/iommu/rockchip-iommu.c
> > 
> > Please make sure you also get Acks for the DT bindings. With that and
> > the issue I mentioned in the other email fixed, I will apply these
> > patches?
> 
> Hi Joerg,
> 
> Thanks for your reviews.
> Can you help me get these DT bindings Acked?
> AFAICT, the DT maintainers are CC'ed on this patch, I'm not sure what else
> to do.

I think the generally accepted way is, to give the dt maintainers an 
appropriate amount of time [0] to complain and assume an implicit ack if no 
complaint arrives.

This is especially true, as the dt-binding for the iommu itself does not even 
introduce any new properties and simply uses widely established ones.


As a sidenote ... I'd like to take the dts changes in patch 3, once Joerg 
takes patches 1 and 2.


Heiko



[0] 3 weeks seems to be the most widely used timespan
