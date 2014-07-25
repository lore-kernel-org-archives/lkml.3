Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760116AbaGYKbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 06:31:18 -0400
Received: from mail-bn1lp0140.outbound.protection.outlook.com ([207.46.163.140]:29292
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751220AbaGYKbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 06:31:16 -0400
From: Harini Katakam <harini.katakam@xilinx.com>
To: Michal Simek <michals@xilinx.com>,
        =?utf-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>,
        "monstr@monstr.eu" <monstr@monstr.eu>,
        Soren Brinkmann <sorenb@xilinx.com>
CC: Michal Simek <michals@xilinx.com>, Andreas Olofsson <andreas@adapteva.com>,
        Matteo Vit <matteo.vit@starwaredesign.com>,
        "Sean Rickerd" <srickerd@suse.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "Russell King" <linux@arm.linux.org.uk>
Subject: RE: [PATCH v2 05/11] ARM: dts: zynq: Add QSPI for Parallella
Thread-Topic: [PATCH v2 05/11] ARM: dts: zynq: Add QSPI for Parallella
Thread-Index: AQHPp95mQbWyYc0A3EeRLyT23ZYPj5uv8viAgAAPhICAAJKZYA==
Date: Fri, 25 Jul 2014 10:31:08 +0000
References: <1406242820-20140-1-git-send-email-afaerber@suse.de>
 <1406242820-20140-6-git-send-email-afaerber@suse.de>
 <ddb38ce5-9e31-4c94-967c-7784c7fba75c@BN1BFFO11FD028.protection.gbl>
 <53D20E5B.9070501@monstr.eu> <53D21887.2020305@suse.de>
 <53D2258B.9000609@xilinx.com>
In-Reply-To: <53D2258B.9000609@xilinx.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.23.18.13]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-RCIS-Action: ALLOW
Message-ID: <7aabd35a-0b4a-4d03-9976-ef3926929ddc@BL2FFO11FD027.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(199002)(189002)(13464003)(24454002)(479174003)(51704005)(377424004)(377454003)(44976005)(6806004)(83322001)(74662001)(31696002)(87936001)(83072002)(86362001)(81542001)(19580405001)(2656002)(19580395003)(92566001)(92726001)(99396002)(76482001)(46102001)(74502001)(54356999)(1496007)(104016003)(107046002)(4396001)(76176999)(50986999)(80022001)(64706001)(21056001)(53416004)(81342001)(85852003)(31966008)(85306003)(50466002)(23676002)(70736001)(79102001)(77982001)(106116001)(95666004)(74316001)(93886003)(106466001)(77096002)(47776003)(20776003)(107986001);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB008;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02830F0362
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=harini.katakam@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s6PAVNTH031861

Hi,

> -----Original Message-----
> From: Michal Simek [mailto:michal.simek@xilinx.com]
> Sent: Friday, July 25, 2014 3:08 PM
> To: Andreas FÃ¤rber; monstr@monstr.eu; Soren Brinkmann
> Cc: Harini Katakam; Michal Simek; Andreas Olofsson; Matteo Vit; Sean
> Rickerd; devicetree@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
> linux-kernel@vger.kernel.org; Rob Herring; Pawel Moll; Mark Rutland; Ian
> Campbell; Kumar Gala; Russell King
> Subject: Re: [PATCH v2 05/11] ARM: dts: zynq: Add QSPI for Parallella
> 
> On 07/25/2014 10:42 AM, Andreas FÃ¤rber wrote:
> > Am 25.07.2014 09:59, schrieb Michal Simek:
> >> On 07/25/2014 01:18 AM, SÃ¶ren Brinkmann wrote:
> >>> On Fri, 2014-07-25 at 01:00AM +0200, Andreas FÃ¤rber wrote:
> >>>> Prepare SPI0 and SPI1 while at it.
> >
> >> Patch subject is incorrect. You are adding SPI and QSPI.
> >
> > Yes, it originally added only QSPI, but I considered it a good deed to
> > add SPI as well while already reading that part of the TRM. :)
> >
> >>>>
> >>>> Signed-off-by: Andreas FÃ¤rber <afaerber@suse.de> --- v2: New
> >>>>
> >>>> arch/arm/boot/dts/zynq-7000.dtsi      | 37
> >>>> +++++++++++++++++++++++++++++++++++
> >>>> arch/arm/boot/dts/zynq-parallella.dts |  4 ++++ 2 files
> >>>> changed, 41 insertions(+)
> >>>>
> >>>> diff --git a/arch/arm/boot/dts/zynq-7000.dtsi
> >>>> b/arch/arm/boot/dts/zynq-7000.dtsi index 8fd826a..eed3df0
> >>>> 100644 --- a/arch/arm/boot/dts/zynq-7000.dtsi +++
> >>>> b/arch/arm/boot/dts/zynq-7000.dtsi @@ -122,6 +122,30 @@
> >>>> interrupts = <0 50 4>; };
> >>>>
> >>>> +		spi0: spi@e0006000 { +			compatible =
> "xlnx,zynq-spi-r1p6";
> >>>> +			reg = <0xe0006000 0x1000>; +			status
> = "disabled"; +
> >>>> interrupt-parent = <&intc>; +			interrupts = <0 26 4>;
> +
> >>>> clocks = <&clkc 25>, <&clkc 34>; +			clock-names =
> "ref_clk",
> >>>> "pclk"; +			#address-cells = <1>; +			#size-
> cells = <0>; +		};
> >>>> + +		spi1: spi@e0007000 { +			compatible =
> >>>> "xlnx,zynq-spi-r1p6"; +			reg = <0xe0007000 0x1000>; +
> 			status
> >>>> = "disabled"; +			interrupt-parent = <&intc>; +
> 		interrupts =
> >>>> <0 49 4>; +			clocks = <&clkc 26>, <&clkc 35>; +
> 		clock-names
> >>>> = "ref_clk", "pclk"; +			#address-cells = <1>; +
> 		#size-cells
> >>>> = <0>; +		}; +
> >>> Until here things look good.
> >>>
> >>>> gem0: ethernet@e000b000 { compatible = "cdns,gem"; reg =
> >>>> <0xe000b000 0x4000>; @@ -140,6 +164,19 @@ clock-names = "pclk",
> >>>> "hclk", "tx_clk"; };
> >>>>
> >>>> +		qspi: qspi@e000d000 { +			compatible =
> >>>> "xlnx,zynq-spi-r1p6"; +			reg = <0xe000d000 0x1000>; +
> 			status
> >>>> = "disabled"; +			interrupt-parent = <&intc>; +
> 		interrupts =
> >>>> <0 19 4>; +			clocks = <&clkc 10>, <&clkc 43>; +
> 		clock-names
> >>>> = "ref_clk", "pclk"; +			num-cs = <1>; +
> 	#address-cells =
> >>>> <1>; +			#size-cells = <0>; +		}; +
> >>> I'm not sure what the status of this driver is. I think QSPI is
> >>> still under review on the mailing lists and I don't think we
> >>> should add this yet.
> >
> >> Driver for qspi is not in the mainline yet but it doesn't mean that
> >> this fragment won't work. Harini: Can you please correct me if I am
> >> wrong?
> >

It can be added but it will have to be disabled as there is no qspi driver
at the moment in mainline.

Regards,
Harini
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
