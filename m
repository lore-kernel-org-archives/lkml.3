Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228AbbAPOJ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 09:09:58 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:36039 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbbAPOJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 09:09:56 -0500
Date: Fri, 16 Jan 2015 14:09:26 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Orson Zhai <orsonzhai@gmail.com>, marc.zyngier@arm.com
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
        "geng.ren@spreadtrum.com" <geng.ren@spreadtrum.com>,
        "zhizhou.zhang@spreadtrum.com" <zhizhou.zhang@spreadtrum.com>,
        "lanqing.liu@spreadtrum.com" <lanqing.liu@spreadtrum.com>,
        "zhang.lyra@gmail.com" <zhang.lyra@gmail.com>,
        "wei.qiao@spreadtrum.com" <wei.qiao@spreadtrum.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Leo Yan <leo.yan@linaro.org>
Subject: Re: [PATCH v5 3/5] arm64: dts: Add support for Spreadtrum SC9836 SoC
 in dts and Makefile
Message-ID: <20150116140926.GB22569@leverpostej>
References: <1421402411-3479-1-git-send-email-chunyan.zhang@spreadtrum.com>
 <1421402411-3479-4-git-send-email-chunyan.zhang@spreadtrum.com>
 <20150116103558.GD21809@leverpostej>
 <CA+H2tpGPKc8Gu=s+d4PnO=Wp_Uv=o338hxj_1opPRkZ3KZH+rw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+H2tpGPKc8Gu=s+d4PnO=Wp_Uv=o338hxj_1opPRkZ3KZH+rw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2015 at 12:49:20PM +0000, Orson Zhai wrote:
> Hi, Mark,
> 
> On Fri, Jan 16, 2015 at 6:35 PM, Mark Rutland <mark.rutland@arm.com> wrote:
> > On Fri, Jan 16, 2015 at 10:00:09AM +0000, Chunyan Zhang wrote:
> >> From: Zhizhou Zhang <zhizhou.zhang@spreadtrum.com>
> >>
> >> Adds the device tree support for Spreadtrum SC9836 SoC which is based on
> >> Sharkl64 platform.
> >>
> >> Sharkl64 platform contains the common nodes of Spreadtrum's arm64-based SoCs.
> >>
> >> Signed-off-by: Zhizhou Zhang <zhizhou.zhang@spreadtrum.com>
> >> Signed-off-by: Orson Zhai <orson.zhai@spreadtrum.com>
> >> Signed-off-by: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
> >> ---
> >>  arch/arm64/boot/dts/Makefile                  |    1 +
> >>  arch/arm64/boot/dts/sprd/Makefile             |    5 ++
> >>  arch/arm64/boot/dts/sprd/sc9836-openphone.dts |   49 +++++++++++++++++
> >>  arch/arm64/boot/dts/sprd/sc9836.dtsi          |   73 +++++++++++++++++++++++++
> >>  arch/arm64/boot/dts/sprd/sharkl64.dtsi        |   67 +++++++++++++++++++++++
> >>  5 files changed, 195 insertions(+)
> >>  create mode 100644 arch/arm64/boot/dts/sprd/Makefile
> >>  create mode 100644 arch/arm64/boot/dts/sprd/sc9836-openphone.dts
> >>  create mode 100644 arch/arm64/boot/dts/sprd/sc9836.dtsi
> >>  create mode 100644 arch/arm64/boot/dts/sprd/sharkl64.dtsi
> >
> > [...]
> >
> >> +     cpus {
> >> +             #address-cells = <2>;
> >> +             #size-cells = <0>;
> >> +
> >> +             cpu@0 {
> >> +                     device_type = "cpu";
> >> +                     compatible = "arm,cortex-a53", "arm,armv8";
> >> +                     reg = <0x0 0x0>;
> >> +                     enable-method = "psci";
> >> +             };
> >> +
> >> +             cpu@1 {
> >> +                     device_type = "cpu";
> >> +                     compatible = "arm,cortex-a53", "arm,armv8";
> >> +                     reg = <0x0 0x1>;
> >> +                     enable-method = "psci";
> >> +             };
> >> +
> >> +             cpu@2 {
> >> +                     device_type = "cpu";
> >> +                     compatible = "arm,cortex-a53", "arm,armv8";
> >> +                     reg = <0x0 0x2>;
> >> +                     enable-method = "psci";
> >> +             };
> >> +
> >> +             cpu@3 {
> >> +                     device_type = "cpu";
> >> +                     compatible = "arm,cortex-a53", "arm,armv8";
> >> +                     reg = <0x0 0x3>;
> >> +                     enable-method = "psci";
> >> +             };
> >> +     };
> >
> > Just to check, all CPUs may be hotplugged off and on, yes?
> >
> 
> Yes, I have tested with them successfully by looking into
> `/proc/interrupts` and `top` except CPU0.

Ok.

> > Including CPU0?
> >
> 
>  It returns "status busy" after I type the command below.

Is this while other CPUs are active, or after you've hotplugged out all
other CPUs? The latter is expected, but the former is not.

Are you able to hotplug CPU0 out and back in while other CPUs are
active

> > How is your implementation tested?
> >
> I build kernel image with 3.19-rc1 + this patchset and run into console.
> I use `echo 0 > /sys/devices/system/cpu[0-3]/online`
> 
> BTW, I run these on a real phone of sc9836 not fast-model as before.
> 
> > You boot CPUs at EL2?
> >
> 
> Yes, I have confirmed this when working around the BUG() in
> arch_counter_get_cntpct() introduced from 3.19.

Ah, good to hear.

> 
> >> +
> >> +     gic: interrupt-controller@12001000 {
> >> +             compatible = "arm,gic-400";
> >> +             #interrupt-cells = <3>;
> >> +             interrupt-controller;
> >> +             reg = <0 0x12001000 0 0x1000>,
> >> +                   <0 0x12002000 0 0x2000>,
> >> +                   <0 0x12004000 0 0x2000>,
> >> +                   <0 0x12006000 0 0x2000>;
> >> +     };
> >
> > You're missing the maintenance interrupt here.
> >
> 
> Do you mean to declare SGI like this ?
> 
> " interrupts = <1 9 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_HIGH)> "

Something like that, yes. However the maintenance interrupt is wired up
in your system.

> 
> > [...]
> >
> >> diff --git a/arch/arm64/boot/dts/sprd/sharkl64.dtsi b/arch/arm64/boot/dts/sprd/sharkl64.dtsi
> >> new file mode 100644
> >> index 0000000..b08989d
> >> --- /dev/null
> >> +++ b/arch/arm64/boot/dts/sprd/sharkl64.dtsi
> >> @@ -0,0 +1,67 @@
> >> +/*
> >> + * Spreadtrum Sharkl64 platform DTS file
> >> + *
> >> + * Copyright (C) 2014, Spreadtrum Communications Inc.
> >> + *
> >> + * This file is licensed under a dual GPLv2 or X11 license.
> >> + */
> >> +
> >> +/ {
> >> +     interrupt-parent = <&gic>;
> >> +     #address-cells = <2>;
> >> +     #size-cells = <2>;
> >> +
> >> +     soc {
> >> +             compatible = "simple-bus";
> >> +             reg = <0x0 0x0 0x0 0x80000000>;
> >
> > What is this reg for? It's not required by simple-bus.
> >
> 
> It's added by me.
> I want to tell people the register range of what the bus covers, not
> for any drivers use.

My point is that it's not part of the binding, so shouldn't be there.

> for this example, It starts from address 0 to 0x80000000.
> Because Spreadtrum chip is very large with a lots of registers and matrix buses.

Ok.

> 
> > If you want to encode that this covers a particular portion of the
> > address space, do so with the ranges proeprty.
> 
> But I look up the ePAPER who says "The ranges property provides a
> means of defining a mapping or translation...".
> The bus here is flat-memory for all.

In this case you could have:

ranges = <0x0 0x0 0x0 0x0 0x0 0x80000000>;

Which would be a flat mapping for the range you care about.

> 
> >
> >> +             #address-cells = <2>;
> >> +             #size-cells = <2>;
> >> +             ranges;
> >> +
> >> +             ap_apb: apb@70000000 {
> >> +                     compatible = "simple-bus";
> >> +                     reg = <0x0 0x70000000 0x0 0x10000000>;

For this bus you could instead use addresses relative to the bus inside,
rather than absolute addresses, or you could have:

ranges = <0x0 0x70000000 0x0 0x70000000 0x0 0x10000000>;

> >
> > Likewise here.
> >
> 
> This initial patch is picked up from a very big dt file.
> There are several apb buses in this chip.

At the same level us the bus hierarchy?

> So I use apb@starting-address to separate them.
> But I remember another rule that the @address needs to equal  first
> address in property reg array.
> Do I have to delete @7000000 as well if i delete reg line?

Hmm. I'm not too keen on encoding a reg or unit-address here, because
the control interface of the bus isn't at that address. If we want to
add that later then the reg would be different in those cases. Given
there's no control interface here, there shouldn't be a reg or
unit-address.

Just ensure that the name before the unit-address is unique.

Thanks,
Mark.
