Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760204AbaGYKrl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 06:47:41 -0400
Received: from mail-bn1lp0139.outbound.protection.outlook.com ([207.46.163.139]:35519
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750751AbaGYKrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 06:47:39 -0400
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
Thread-Index: AQHPp95mQbWyYc0A3EeRLyT23ZYPj5uv8viAgAAPhICAAJKZYIAABi6g
Date: Fri, 25 Jul 2014 10:47:31 +0000
References: <1406242820-20140-1-git-send-email-afaerber@suse.de>
 <1406242820-20140-6-git-send-email-afaerber@suse.de>
 <ddb38ce5-9e31-4c94-967c-7784c7fba75c@BN1BFFO11FD028.protection.gbl>
 <53D20E5B.9070501@monstr.eu> <53D21887.2020305@suse.de>
 <53D2258B.9000609@xilinx.com> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.23.18.13]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-RCIS-Action: ALLOW
Message-ID: <2bb3733f-f6db-4953-b3f2-8d76203d7c91@BY2FFO11FD002.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(979002)(6009001)(438002)(13464003)(199002)(24454002)(51704005)(189002)(377424004)(377454003)(479174003)(85852003)(99396002)(80022001)(76176999)(53416004)(81542001)(106116001)(95666004)(50986999)(31696002)(1496007)(92726001)(50466002)(104016003)(107046002)(106466001)(74316001)(83072002)(92566001)(23676002)(79102001)(54356999)(93886003)(74662001)(2656002)(31966008)(74502001)(77982001)(76482001)(64706001)(47776003)(19580405001)(87936001)(20776003)(46102001)(6806004)(44976005)(83322001)(21056001)(19580395003)(81342001)(4396001)(77096002)(86362001)(85306003)(70736001)(107986001)(23106004)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB008;H:xsj-pvapsmtpgw01;FPR:;MLV:ovrnspm;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02830F0362
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=harini.katakam@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s6PAlkKc031975

Hi,

> -----Original Message-----
> From: Harini Katakam
> Sent: Friday, July 25, 2014 4:01 PM
> To: 'Michal Simek'; Andreas FÃ¤rber; monstr@monstr.eu; Soren Brinkmann
> Cc: Michal Simek; Andreas Olofsson; Matteo Vit; Sean Rickerd;
> devicetree@vger.kernel.org; linux-arm-kernel@lists.infradead.org; linux-
> kernel@vger.kernel.org; Rob Herring; Pawel Moll; Mark Rutland; Ian
> Campbell; Kumar Gala; Russell King
> Subject: RE: [PATCH v2 05/11] ARM: dts: zynq: Add QSPI for Parallella
> 
> Hi,
> 
> > -----Original Message-----
> > From: Michal Simek [mailto:michal.simek@xilinx.com]
> > Sent: Friday, July 25, 2014 3:08 PM
> > To: Andreas FÃ¤rber; monstr@monstr.eu; Soren Brinkmann
> > Cc: Harini Katakam; Michal Simek; Andreas Olofsson; Matteo Vit; Sean
> > Rickerd; devicetree@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org;
> > linux-kernel@vger.kernel.org; Rob Herring; Pawel Moll; Mark Rutland; Ian
> > Campbell; Kumar Gala; Russell King
> > Subject: Re: [PATCH v2 05/11] ARM: dts: zynq: Add QSPI for Parallella
> >
> > On 07/25/2014 10:42 AM, Andreas FÃ¤rber wrote:
> > > Am 25.07.2014 09:59, schrieb Michal Simek:
> > >> On 07/25/2014 01:18 AM, SÃ¶ren Brinkmann wrote:
> > >>> On Fri, 2014-07-25 at 01:00AM +0200, Andreas FÃ¤rber wrote:
> > >>>> Prepare SPI0 and SPI1 while at it.
> > >
> > >> Patch subject is incorrect. You are adding SPI and QSPI.
> > >
> > > Yes, it originally added only QSPI, but I considered it a good deed to
> > > add SPI as well while already reading that part of the TRM. :)
> > >
> > >>>>
> > >>>> Signed-off-by: Andreas FÃ¤rber <afaerber@suse.de> --- v2: New
> > >>>>
> > >>>> arch/arm/boot/dts/zynq-7000.dtsi      | 37
> > >>>> +++++++++++++++++++++++++++++++++++
> > >>>> arch/arm/boot/dts/zynq-parallella.dts |  4 ++++ 2 files
> > >>>> changed, 41 insertions(+)
> > >>>>
> > >>>> diff --git a/arch/arm/boot/dts/zynq-7000.dtsi
> > >>>> b/arch/arm/boot/dts/zynq-7000.dtsi index 8fd826a..eed3df0
> > >>>> 100644 --- a/arch/arm/boot/dts/zynq-7000.dtsi +++
> > >>>> b/arch/arm/boot/dts/zynq-7000.dtsi @@ -122,6 +122,30 @@
> > >>>> interrupts = <0 50 4>; };
> > >>>>
> > >>>> +		spi0: spi@e0006000 { +			compatible =
> > "xlnx,zynq-spi-r1p6";
> > >>>> +			reg = <0xe0006000 0x1000>; +
> 	status
> > = "disabled"; +
> > >>>> interrupt-parent = <&intc>; +			interrupts = <0 26 4>;
> > +
> > >>>> clocks = <&clkc 25>, <&clkc 34>; +			clock-names
> =
> > "ref_clk",
> > >>>> "pclk"; +			#address-cells = <1>; +			#size-
> > cells = <0>; +		};
> > >>>> + +		spi1: spi@e0007000 { +			compatible =
> > >>>> "xlnx,zynq-spi-r1p6"; +			reg = <0xe0007000 0x1000>; +
> > 			status
> > >>>> = "disabled"; +			interrupt-parent = <&intc>; +
> > 		interrupts =
> > >>>> <0 49 4>; +			clocks = <&clkc 26>, <&clkc 35>; +
> > 		clock-names
> > >>>> = "ref_clk", "pclk"; +			#address-cells = <1>; +
> > 		#size-cells
> > >>>> = <0>; +		}; +
> > >>> Until here things look good.
> > >>>
> > >>>> gem0: ethernet@e000b000 { compatible = "cdns,gem"; reg =
> > >>>> <0xe000b000 0x4000>; @@ -140,6 +164,19 @@ clock-names = "pclk",
> > >>>> "hclk", "tx_clk"; };
> > >>>>
> > >>>> +		qspi: qspi@e000d000 { +
> 	compatible =
> > >>>> "xlnx,zynq-spi-r1p6"; +			reg = <0xe000d000 0x1000>; +
> > 			status
> > >>>> = "disabled"; +			interrupt-parent = <&intc>; +
> > 		interrupts =
> > >>>> <0 19 4>; +			clocks = <&clkc 10>, <&clkc 43>; +
> > 		clock-names
> > >>>> = "ref_clk", "pclk"; +			num-cs = <1>; +
> > 	#address-cells =
> > >>>> <1>; +			#size-cells = <0>; +		}; +
> > >>> I'm not sure what the status of this driver is. I think QSPI is
> > >>> still under review on the mailing lists and I don't think we
> > >>> should add this yet.
> > >
> > >> Driver for qspi is not in the mainline yet but it doesn't mean that
> > >> this fragment won't work. Harini: Can you please correct me if I am
> > >> wrong?
> > >
> 
> It can be added but it will have to be disabled as there is no qspi driver
> at the moment in mainline.
> 

The cadence spi driver can't be used for qspi directly.
Itâ€™s better not to add qspi now. Once qspi driver is in mainline, qspi
can be added with the corresponding compatibility string.

Regards,
Harini
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
