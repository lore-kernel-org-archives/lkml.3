Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756408Ab3BFBjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 20:39:19 -0500
Received: from nasmtp01.atmel.com ([192.199.1.245]:26599 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754755Ab3BFBjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 20:39:18 -0500
From: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
        "richard.genoud@gmail.com" <richard.genoud@gmail.com>,
        "Lin, JM" <JM.Lin@atmel.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
Subject: RE: [v4 PATCH 11/12] ARM: dts: add spi nodes for atmel SoC
Thread-Topic: [v4 PATCH 11/12] ARM: dts: add spi nodes for atmel SoC
Thread-Index: AQHN8iq6J0z1UvaAp0u3piizV4P59phrSesAgADmFSA=
Date: Wed, 6 Feb 2013 01:35:46 +0000
Message-ID: <B256D81BAE5131468A838E5D7A2436413A086C1E@penmbx02>
References: <1358148877-18679-1-git-send-email-wenyou.yang@atmel.com>
 <1358148877-18679-12-git-send-email-wenyou.yang@atmel.com>
 <20130205195126.GB30595@game.jcrosoft.org>
In-Reply-To: <20130205195126.GB30595@game.jcrosoft.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.5.13]
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r161dKss019158



> -----Original Message-----
> From: Jean-Christophe PLAGNIOL-VILLARD [mailto:plagnioj@jcrosoft.com]
> Sent: 2013Äê2ÔÂ6ÈÕ 3:51
> To: Yang, Wenyou
> Cc: linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org; Ferre,
> Nicolas; richard.genoud@gmail.com; Lin, JM; linux@arm.linux.org.uk
> Subject: Re: [v4 PATCH 11/12] ARM: dts: add spi nodes for atmel SoC
> 
> On 15:34 Mon 14 Jan     , Wenyou Yang wrote:
> > From: Richard Genoud <richard.genoud@gmail.com>
> >
> > Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
> > [wenyou.yang@atmel.com: add spi nodes for sam9260, sam9263, sam9g45
> and sam9n12]
> > [wenyou.yang@atmel.com: remove spi property "cs-gpios" to the board dts
> files]
> > Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
> > Cc: linux@arm.linux.org.uk
> > ---
> >  arch/arm/boot/dts/at91sam9260.dtsi |   18 ++++++++++++++++++
> >  arch/arm/boot/dts/at91sam9263.dtsi |   18 ++++++++++++++++++
> >  arch/arm/boot/dts/at91sam9g45.dtsi |   18 ++++++++++++++++++
> I alreadt have some patch in queue
> 
Thanks
I will remove this patch in the next version.

> Best Regards,
> J.
> >  arch/arm/boot/dts/at91sam9n12.dtsi |   18 ++++++++++++++++++
> >  arch/arm/boot/dts/at91sam9x5.dtsi  |   18 ++++++++++++++++++
> >  5 files changed, 90 insertions(+)
> >
> > diff --git a/arch/arm/boot/dts/at91sam9260.dtsi
> b/arch/arm/boot/dts/at91sam9260.dtsi
> > index 68bccf4..9586fe1 100644
> > --- a/arch/arm/boot/dts/at91sam9260.dtsi
> > +++ b/arch/arm/boot/dts/at91sam9260.dtsi
> > @@ -453,6 +453,24 @@
> >  				status = "disabled";
> >  			};
> >
> > +			spi0: spi@fffc8000 {
> > +				#address-cells = <1>;
> > +				#size-cells = <0>;
> > +				compatible = "atmel,at91sam9260-spi";
> > +				reg = <0xfffc8000 0x200>;
> > +				interrupts = <12 4 3>;
> > +				status = "disabled";
> > +			};
> > +
> > +			spi1: spi@fffcc000 {
> > +				#address-cells = <1>;
> > +				#size-cells = <0>;
> > +				compatible = "atmel,at91sam9260-spi";
> > +				reg = <0xfffcc000 0x200>;
> > +				interrupts = <13 4 3>;
> > +				status = "disabled";
> > +			};
> > +
> >  			adc0: adc@fffe0000 {
> >  				compatible = "atmel,at91sam9260-adc";
> >  				reg = <0xfffe0000 0x100>;
> > diff --git a/arch/arm/boot/dts/at91sam9263.dtsi
> b/arch/arm/boot/dts/at91sam9263.dtsi
> > index 32ec62c..636b882 100644
> > --- a/arch/arm/boot/dts/at91sam9263.dtsi
> > +++ b/arch/arm/boot/dts/at91sam9263.dtsi
> > @@ -426,6 +426,24 @@
> >  				reg = <0xfffffd40 0x10>;
> >  				status = "disabled";
> >  			};
> > +
> > +			spi0: spi@fffa4000 {
> > +				#address-cells = <1>;
> > +				#size-cells = <0>;
> > +				compatible = "atmel,at91sam9260-spi";
> > +				reg = <0xfffa4000 0x200>;
> > +				interrupts = <14 4 3>;
> > +				status = "disabled";
> > +			};
> > +
> > +			spi1: spi@fffa8000 {
> > +				#address-cells = <1>;
> > +				#size-cells = <0>;
> > +				compatible = "atmel,at91sam9260-spi";
> > +				reg = <0xfffa8000 0x200>;
> > +				interrupts = <15 4 3>;
> > +				status = "disabled";
> > +			};
> >  		};
> >
> >  		nand0: nand@40000000 {
> > diff --git a/arch/arm/boot/dts/at91sam9g45.dtsi
> b/arch/arm/boot/dts/at91sam9g45.dtsi
> > index 231858f..0100b80 100644
> > --- a/arch/arm/boot/dts/at91sam9g45.dtsi
> > +++ b/arch/arm/boot/dts/at91sam9g45.dtsi
> > @@ -495,6 +495,24 @@
> >  				reg = <0xfffffd40 0x10>;
> >  				status = "disabled";
> >  			};
> > +
> > +			spi0: spi@fffa4000 {
> > +				#address-cells = <1>;
> > +				#size-cells = <0>;
> > +				compatible = "atmel,at91sam9g45-spi";
> > +				reg = <0xfffa4000 0x200>;
> > +				interrupts = <14 4 3>;
> > +				status = "disabled";
> > +			};
> > +
> > +			spi1: spi@fffa8000 {
> > +				#address-cells = <1>;
> > +				#size-cells = <0>;
> > +				compatible = "atmel,at91sam9g45-spi";
> > +				reg = <0xfffa8000 0x200>;
> > +				interrupts = <15 4 3>;
> > +				status = "disabled";
> > +			};
> >  		};
> >
> >  		nand0: nand@40000000 {
> > diff --git a/arch/arm/boot/dts/at91sam9n12.dtsi
> b/arch/arm/boot/dts/at91sam9n12.dtsi
> > index e9efb34..86d5357 100644
> > --- a/arch/arm/boot/dts/at91sam9n12.dtsi
> > +++ b/arch/arm/boot/dts/at91sam9n12.dtsi
> > @@ -355,6 +355,24 @@
> >  				#size-cells = <0>;
> >  				status = "disabled";
> >  			};
> > +
> > +			spi0: spi@f0000000 {
> > +				#address-cells = <1>;
> > +				#size-cells = <0>;
> > +				compatible = "atmel,at91sam9x5-spi";
> > +				reg = <0xf0000000 0x100>;
> > +				interrupts = <13 4 3>;
> > +				status = "disabled";
> > +			};
> > +
> > +			spi1: spi@f0004000 {
> > +				#address-cells = <1>;
> > +				#size-cells = <0>;
> > +				compatible = "atmel,at91sam9x5-spi";
> > +				reg = <0xf0004000 0x100>;
> > +				interrupts = <14 4 3>;
> > +				status = "disabled";
> > +			};
> >  		};
> >
> >  		nand0: nand@40000000 {
> > diff --git a/arch/arm/boot/dts/at91sam9x5.dtsi
> b/arch/arm/boot/dts/at91sam9x5.dtsi
> > index 40ac3a4..8ea2f7d 100644
> > --- a/arch/arm/boot/dts/at91sam9x5.dtsi
> > +++ b/arch/arm/boot/dts/at91sam9x5.dtsi
> > @@ -473,6 +473,24 @@
> >  					trigger-value = <0x6>;
> >  				};
> >  			};
> > +
> > +			spi0: spi@f0000000 {
> > +				#address-cells = <1>;
> > +				#size-cells = <0>;
> > +				compatible = "atmel,at91sam9x5-spi";
> > +				reg = <0xf0000000 0x100>;
> > +				interrupts = <13 4 3>;
> > +				status = "disabled";
> > +			};
> > +
> > +			spi1: spi@f0004000 {
> > +				#address-cells = <1>;
> > +				#size-cells = <0>;
> > +				compatible = "atmel,at91sam9x5-spi";
> > +				reg = <0xf0004000 0x100>;
> > +				interrupts = <14 4 3>;
> > +				status = "disabled";
> > +			};
> >  		};
> >
> >  		nand0: nand@40000000 {
> > --
> > 1.7.9.5
> >

Best Regards,
Wenyou Yang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
