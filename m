Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965754AbaFTHwj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 03:52:39 -0400
Received: from www.linutronix.de ([62.245.132.108]:57253 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794AbaFTHwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 03:52:38 -0400
Date: Fri, 20 Jun 2014 09:52:33 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
cc: LKML <linux-kernel@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        devicetree@vger.kernel.org, spear-devel <spear-devel@list.st.com>
Subject: Re: [patch 2/2] dts: spear: Add missing i2c1 interrupt
In-Reply-To: <CAOh2x==eh=k-LWK89QY_B0f9e7ctZE035NQm_vumayBYf3Mtnw@mail.gmail.com>
Message-ID: <alpine.DEB.2.10.1406200951400.5170@nanos>
References: <20140619215347.139324048@linutronix.de> <20140619215557.875556819@linutronix.de> <CAOh2x==eh=k-LWK89QY_B0f9e7ctZE035NQm_vumayBYf3Mtnw@mail.gmail.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jun 2014, Viresh Kumar wrote:

> On Fri, Jun 20, 2014 at 3:26 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > ---
> >  arch/arm/boot/dts/spear320.dtsi |    5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > Index: linux/arch/arm/boot/dts/spear320.dtsi
> > ===================================================================
> > --- linux.orig/arch/arm/boot/dts/spear320.dtsi
> > +++ linux/arch/arm/boot/dts/spear320.dtsi
> > @@ -123,6 +123,11 @@
> >                                 status = "disabled";
> >                         };
> >
> > +                       i2c1: i2c@a7000000 {
> > +                               interrupts = <21>;
> > +                               interrupt-parent = <&shirq>;
> > +                       };
> 
> Isn't this already available ?
> 
>                         i2c1: i2c@a7000000 {
>                                 #address-cells = <1>;
>                                 #size-cells = <0>;
>                                 compatible = "snps,designware-i2c";
>                                 reg = <0xa7000000 0x1000>;
>                                 interrupts = <21>;
>                                 interrupt-parent = <&shirq>;
>                                 status = "disabled";
>                         };

Oops yes, did this against an older tree and did not notice the
duplicate. So nothing to do here.

Thanks,

	tglx
