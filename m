Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbaFEQof (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 12:44:35 -0400
Received: from top.free-electrons.com ([176.31.233.9]:59345 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751641AbaFEQo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 12:44:29 -0400
Date: Thu, 5 Jun 2014 18:44:26 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/9] ARM: dts: berlin: add a required reset property in
 the chip controller node
Message-ID: <20140605164426.GA21960@kwain>
References: <1401983326-19205-1-git-send-email-antoine.tenart@free-electrons.com>
 <1401983326-19205-4-git-send-email-antoine.tenart@free-electrons.com>
 <1401986347.4103.11.camel@paszta.hi.pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1401986347.4103.11.camel@paszta.hi.pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2014 at 06:39:07PM +0200, Philipp Zabel wrote:
> Am Donnerstag, den 05.06.2014, 17:48 +0200 schrieb Antoine Ténart:
> > The chip controller node now also describes the Marvell Berlin reset
> > controller. Add the required 'reset-cells' property.
> > 
> > Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> > ---
> >  arch/arm/boot/dts/berlin2.dtsi   | 1 +
> >  arch/arm/boot/dts/berlin2cd.dtsi | 1 +
> >  arch/arm/boot/dts/berlin2q.dtsi  | 1 +
> >  3 files changed, 3 insertions(+)
> > 
> > diff --git a/arch/arm/boot/dts/berlin2.dtsi b/arch/arm/boot/dts/berlin2.dtsi
> > index 2477dac4d643..379ff1a38377 100644
> > --- a/arch/arm/boot/dts/berlin2.dtsi
> > +++ b/arch/arm/boot/dts/berlin2.dtsi
> > @@ -243,6 +243,7 @@
> >  		chip: chip-control@ea0000 {
> >  			compatible = "marvell,berlin2-chip-ctrl";
> >  			#clock-cells = <1>;
> > +			#reset-cells = <1>;
> 
> Are the marvell,berlin2q-chip-ctrl bindings already documented? This
> should also be added to the documentation.

It is, I'll add information about its reset function.

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
