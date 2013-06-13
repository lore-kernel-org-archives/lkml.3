Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963Ab3FMEJt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 00:09:49 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56767 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054Ab3FMEJr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 00:09:47 -0400
From: "J, KEERTHY" <j-keerthy@ti.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "Cousson, Benoit" <b-cousson@ti.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ldewangan@nvidia.com" <ldewangan@nvidia.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "swarren@nvidia.com" <swarren@nvidia.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>
Subject: RE: [PATCH v4] ARM: dts: OMAP5: Add palmas MFD node and regulator
 nodes
Thread-Topic: [PATCH v4] ARM: dts: OMAP5: Add palmas MFD node and regulator
 nodes
Thread-Index: AQHOZ0aOzpDdDqo2IEWs3NtTs2HlqpkxtMgAgAFTriA=
Date: Thu, 13 Jun 2013 04:09:22 +0000
Message-ID: <DC88CAD03C0052499C1907B327FC63229EB4B8@DBDE04.ent.ti.com>
References: <1371025140-25376-1-git-send-email-j-keerthy@ti.com>
 <51B8990A.8030506@wwwdotorg.org>
In-Reply-To: <51B8990A.8030506@wwwdotorg.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

> -----Original Message-----
> From: Stephen Warren [mailto:swarren@wwwdotorg.org]
> Sent: Wednesday, June 12, 2013 9:22 PM
> To: J, KEERTHY
> Cc: Cousson, Benoit; devicetree-discuss@lists.ozlabs.org; linux-
> omap@vger.kernel.org; linux-kernel@vger.kernel.org;
> ldewangan@nvidia.com; grant.likely@secretlab.ca; swarren@nvidia.com;
> sameo@linux.intel.com; gg@slimlogic.co.uk; lee.jones@linaro.org
> Subject: Re: [PATCH v4] ARM: dts: OMAP5: Add palmas MFD node and
> regulator nodes
> 
> On 06/12/2013 02:19 AM, J Keerthy wrote:
> > This patch adds Palmas MFD node and the regulator nodes for OMAP5.
> >
> > The node definitions are based on: https://lkml.org/lkml/2013/6/6/25
> >
> > Boot tested on omap5-uevm board.
> 
> Reviewed-by: Stephen Warren <swarren@nvidia.com>

Thanks..

> 
> > diff --git a/arch/arm/boot/dts/omap5-uevm.dts
> > b/arch/arm/boot/dts/omap5-uevm.dts
> 
> > +	palmas: palmas@48 {
> > +		reg = <0x48>;
> > +		interrupts = <GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>; /* IRQ_SYS_1N
> */
> > +		interrupt-parent = <&gic>;
> > +		compatible = "ti,palmas";
> 
> ... although personally I prefer the compatible property to be right at
> the top of each node, since it's what implies the schema for the rest
> of the node. That's a tiny nit though; feel free to ignore it if the
> OMAP files don't follow that convention.

Sure. I will send hopefully the last version incorporating this :-).

Regards,
Keerthy
