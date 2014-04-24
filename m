Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758614AbaDXRsF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 13:48:05 -0400
Received: from mail-bn1lp0142.outbound.protection.outlook.com ([207.46.163.142]:51603
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757354AbaDXRsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 13:48:03 -0400
Date: Thu, 24 Apr 2014 19:47:41 +0200
From: Anders Berg <anders.berg@lsi.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Mike Turquette <mturquette@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/6] ARM: dts: Device tree for AXM55xx.
Message-ID: <20140424174741.GA23444@swsaberg01>
References: <cover.1398335771.git.anders.berg@lsi.com>
 <2386bd1367aa44741979461358a72dec89608597.1398335771.git.anders.berg@lsi.com>
 <CACRpkdbU6UashxCuPMDjEB_nbB=mXicGpjJy=HGC6r3qfxCtVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CACRpkdbU6UashxCuPMDjEB_nbB=mXicGpjJy=HGC6r3qfxCtVQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [85.229.45.38]
X-ClientProxiedBy: DB4PR07CA002.eurprd07.prod.outlook.com (10.242.229.12) To
 CO1PR07MB380.namprd07.prod.outlook.com (10.141.74.150)
X-Forefront-PRVS: 01917B1794
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019001)(6009001)(428001)(189002)(199002)(51704005)(24454002)(377454003)(97756001)(92726001)(33716001)(33656001)(80976001)(87976001)(50986999)(46406003)(99396002)(92566001)(76176999)(66066001)(54356999)(77982001)(83322001)(80022001)(4396001)(20776003)(47776003)(85852003)(76482001)(83072002)(23726002)(81542001)(19580405001)(83506001)(46102001)(19580395003)(42186004)(31966008)(79102001)(50466002)(81342001)(74662001)(86362001)(74502001);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR07MB380;H:swsaberg01;FPR:83D2F0BC.3FC5DB0A.7AF0B257.C6E01A.20227;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: lsi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 03:24:14PM +0200, Linus Walleij wrote:
> On Thu, Apr 24, 2014 at 12:44 PM, Anders Berg <anders.berg@lsi.com> wrote:
> 
> > Add device tree for the Amarillo validation board with an AXM5516 SoC.
> >
> > Signed-off-by: Anders Berg <anders.berg@lsi.com>
> (...)
> 
> > +                       timer0: timer@2010091000 {
> > +                               compatible = "arm,sp804", "arm,primecell";
> > +                               reg = <0x20 0x10091000 0 0x1000>;
> > +                               interrupts = <GIC_SPI 46 IRQ_TYPE_LEVEL_HIGH>,
> > +                                            <GIC_SPI 46 IRQ_TYPE_LEVEL_HIGH>,
> > +                                            <GIC_SPI 47 IRQ_TYPE_LEVEL_HIGH>,
> > +                                            <GIC_SPI 48 IRQ_TYPE_LEVEL_HIGH>,
> > +                                            <GIC_SPI 49 IRQ_TYPE_LEVEL_HIGH>,
> > +                                            <GIC_SPI 50 IRQ_TYPE_LEVEL_HIGH>,
> > +                                            <GIC_SPI 51 IRQ_TYPE_LEVEL_HIGH>,
> > +                                            <GIC_SPI 52 IRQ_TYPE_LEVEL_HIGH>,
> > +                                            <GIC_SPI 53 IRQ_TYPE_LEVEL_HIGH>;
> > +                               clocks = <&clk_per>;
> > +                               clock-names = "apb_pclk";
> > +                               status = "okay";
> > +                       };
> > +
> > +                       gpio0: gpio@2010092000 {
> > +                               #gpio-cells = <2>;
> > +                               compatible = "arm,pl061", "arm,primecell";
> > +                               gpio-controller;
> > +                               reg = <0x20 0x10092000 0x00 0x1000>;
> > +                               interrupts = <GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>,
> > +                                            <GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>,
> > +                                            <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>,
> > +                                            <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>,
> > +                                            <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>,
> > +                                            <GIC_SPI 15 IRQ_TYPE_LEVEL_HIGH>,
> > +                                            <GIC_SPI 16 IRQ_TYPE_LEVEL_HIGH>,
> > +                                            <GIC_SPI 17 IRQ_TYPE_LEVEL_HIGH>;
> > +                               clocks = <&clk_per>;
> > +                               clock-names = "apb_pclk";
> > +                               status = "disabled";
> > +                       };
> 
> One interrupt per CPU core?
> 
> The drivers for these blocks will really just grab the first IRQ and
> then I guess they
> will only be able to execute on CPU0.
> 
> It's definately correct to list all the IRQs here, but how do you envision
> the drivers making use of them in the long run?

It's one interrupt line per input pin (so with the current driver only the first pin
is usable as interrupt source).

/Anders

> 
> Yours,
> Linus Walleij
> 
