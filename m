Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387AbaG2FRv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 01:17:51 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.218]:9671 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbaG2FRt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 01:17:49 -0400
X-RZG-AUTH: :JGIXVUS7cutRB/49FwqZ7WcKdUCnXG6JabOfSXKWrat9htPoyY0=
X-RZG-CLASS-ID: mo00
Subject: Re: [PATCH 3/3] arm: dts: Add gta04a5 model
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <CAOf5uwmjznuK_1au1HnsnYh=BhqC=x+O_tpk6U71bqPv=hFe_A@mail.gmail.com>
Date: Tue, 29 Jul 2014 07:17:06 +0200
Cc: Marek Belisko <marek.belisko@gmail.com>, Kumar Gala <galak@codeaurora.org>,
        pawel.moll@arm.com, Benoit Cousson <bcousson@baylibre.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Rob Herring <robh+dt@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <A0AA66B6-5D28-49D7-AF83-06F0D38DA96D@goldelico.com>
References: <1406577213-9642-1-git-send-email-marek@goldelico.com> <1406577213-9642-4-git-send-email-marek@goldelico.com> <CAOf5uwk=ctww=pP4Ae+1C6i-oOtiYTv2NJbj1GpuPwVSKXB4Hw@mail.gmail.com> <CAAfyv35jvhzvjCKMwrpa=RQ1JkfcmthCsGDzwLW9Y6bq3Ww_fg@mail.gmail.com> <CAOf5uw=Fm9FXEH5ESqDC8pGjMbn5VQ1+MyPJVXSqGh_9+JRLHw@mail.gmail.com> <CAAfyv351g1R6TnmW+JKM1sDQsegEFExV6p9BEN=izOdR4n8zEQ@mail.gmail.com> <CAOf5uwmjznuK_1au1HnsnYh=BhqC=x+O_tpk6U71bqPv=hFe_A@mail.gmail.com>
To: Michael Trimarchi <michael@amarulasolutions.com>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Am 28.07.2014 um 22:12 schrieb Michael Trimarchi:

> Hi
> 
> Il 28/lug/2014 22:06 "Belisko Marek" <marek.belisko@gmail.com> ha scritto:
> >
> > On Mon, Jul 28, 2014 at 10:04 PM, Michael Trimarchi
> > <michael@amarulasolutions.com> wrote:
> > > Hi
> > >
> > > Il 28/lug/2014 22:02 "Belisko Marek" <marek.belisko@gmail.com> ha scritto:
> > >
> > >
> > >>
> > >> Hi Michael,
> > >>
> > >> On Mon, Jul 28, 2014 at 9:56 PM, Michael Trimarchi
> > >> <michael@amarulasolutions.com> wrote:
> > >> > Hi Marek
> > >> >
> > >> > Il 28/lug/2014 21:54 "Marek Belisko" <marek@goldelico.com> ha scritto:
> > >> >
> > >> >
> > >> >>
> > >> >> Add model a5 which have additional jack detection.
> > >> >>
> > >> >> Signed-off-by: Marek Belisko <marek@goldelico.com>
> > >> >> ---
> > >> >>  arch/arm/boot/dts/Makefile          |  1 +
> > >> >>  arch/arm/boot/dts/omap3-gta04a5.dts | 17 +++++++++++++++++
> > >> >>  2 files changed, 18 insertions(+)
> > >> >>  create mode 100644 arch/arm/boot/dts/omap3-gta04a5.dts
> > >> >>
> > >> >> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> > >> >> index 7d45fde..576c595 100644
> > >> >> --- a/arch/arm/boot/dts/Makefile
> > >> >> +++ b/arch/arm/boot/dts/Makefile
> > >> >> @@ -285,6 +285,7 @@ dtb-$(CONFIG_ARCH_OMAP3) += am3517-craneboard.dtb \
> > >> >>         omap3-evm-37xx.dtb \
> > >> >>         omap3-gta04a3.dtb \
> > >> >>         omap3-gta04a4.dtb \
> > >> >> +       omap3-gta04a5.dtb \
> > >> >>         omap3-igep0020.dtb \
> > >> >>         omap3-igep0030.dtb \
> > >> >>         omap3-ldp.dtb \
> > >> >> diff --git a/arch/arm/boot/dts/omap3-gta04a5.dts
> > >> >> b/arch/arm/boot/dts/omap3-gta04a5.dts
> > >> >> new file mode 100644
> > >> >> index 0000000..210317c3
> > >> >> --- /dev/null
> > >> >> +++ b/arch/arm/boot/dts/omap3-gta04a5.dts
> > >> >> @@ -0,0 +1,17 @@
> > >> >> +/*
> > >> >> + * Copyright (C) 2014 H. Nikolaus Schaller <hns@goldelico.com>
> > >> >> + *
> > >> >> + * This program is free software; you can redistribute it and/or
> > >> >> modify
> > >> >> + * it under the terms of the GNU General Public License version 2 as
> > >> >> + * published by the Free Software Foundation.
> > >> >> + */
> > >> >> +
> > >> >> +#include "omap3-gta04.dtsi"
> > >> >> +
> > >> >> +/ {
> > >> >> +       model = "Goldelico GTA04A5;
> > >> >> +
> > >> >> +       sound {
> > >> >> +               ti,jack-det-gpio = <&twl_gpio 2 0>;    /* GTA04A5 only
> > >> >> */
> > >> >> +       };
> > >> >> +};
> > >> >> --
> > >> >> 1.9.1
> > >> >>
> > >> >
> > >> > Can we have only one dts with status enabled/disabled?
> > >> Do you mean to define this node it gta04.dtsi disabled and enable only
> > >> for a5 model?
> > >> >
> > >
> > > This should be possible in the bootloader
> > Sorry I didn't get that. Can you give me some short example (or
> > existing board which using it)?
> > Thanks.
> > >
> 
> http://www.denx.de/wiki/view/DULG/UBootCmdFDT
> 
> I just suggest to not create a dts for each board revision but let it manage by the bootloader. I don't know if there are examples but make sense to me to avoid to add a lot of dts.
> 
> 

Hm. Why should we dynamically modify the dtb in memory through slow, interpreted FDT commands in u-boot, if the DTC can statically compile complete .dtb files by using an #include mechanism? It would slow down boot time for no other improvement. And debugging is more difficult that looking for compiler errors.

And our u-boot does not support the fdt command to avoid bloating it. IMHO boot loaders should be as small and fast as possible and contain only what is barely necessary. Everything more sophisticated should be done by the kernel and device drivers and some init user space process. I.e. boot loader should only tell the kernel only which board revision it is but not "manage" the board revisions.

We also have a nice feature that a system on an SD card has the uImage in /boot and all existing and relevant .dtb files. U-Boot simply picks and loads the right one (by file name). This keeps the boot loader stable (people always have difficulties flashing new boot loaders). Therefore we need precompiled DTBs that completely and consistently describe each board variant. This mechanism allows that we can easily swap the SD card between different boards and variants. Implementing this feature using U-Boot scripts with FDT commands to patch the DT, appears to become a nightmare. If you are interested, the whole concept is described here:

http://projects.goldelico.com/p/gta04-main/downloads/55/

Another aspect to consider: in my understanding, the main reason why DT is still maintained within the kernel is that the bindings are not yet stable. Therefore if bindings are patched, all device trees using them are also to be changed. I don't see how this can work if we have part of the board variations managed outside the kernel tree. Therefore each board revision is to be treated not differently from a completely new board. And similar parts are treated by a common .dtsi. This is how the concept IMHO should be. And the consequence is that we need a different .dts file for each board that has differences (even if they are or appear to be small).

So I don't see that your suggestion is the right way to go.

BR,
Nikolaus

