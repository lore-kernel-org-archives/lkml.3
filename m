Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbaGYEFU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 00:05:20 -0400
Received: from mail-bl2lp0211.outbound.protection.outlook.com ([207.46.163.211]:49166
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750749AbaGYEFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 00:05:17 -0400
From: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>
To: =?utf-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>,
        Michal Simek <michals@xilinx.com>
CC: Andreas Olofsson <andreas@adapteva.com>,
        Matteo Vit <matteo.vit@starwaredesign.com>,
        Sean Rickerd <srickerd@suse.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: RE: [PATCH v2 00/11] ARM: dts: zynq: Prepare Parallella
Thread-Topic: [PATCH v2 00/11] ARM: dts: zynq: Prepare Parallella
Thread-Index: AQHPp5MqOd6KcMpZNUqgzX0gRVD/6puwJmFA
Date: Fri, 25 Jul 2014 03:49:23 +0000
References: <1406242820-20140-1-git-send-email-afaerber@suse.de>
In-Reply-To: <1406242820-20140-1-git-send-email-afaerber@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.23.92.172]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-RCIS-Action: ALLOW
Message-ID: <dc23839c-7a69-4674-9d92-80a1d68e9b23@BY2FFO11FD003.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(13464003)(51704005)(377454003)(199002)(189002)(76176999)(85306003)(83322001)(31696002)(6806004)(64706001)(106116001)(92726001)(4396001)(74662001)(85852003)(54356999)(19580405001)(31966008)(46102001)(47776003)(83072002)(20776003)(50986999)(95666004)(44976005)(77982001)(77096002)(53416004)(50466002)(104016003)(81342001)(80022001)(106466001)(74316001)(74502001)(107046002)(70736001)(15975445006)(21056001)(23676002)(2656002)(19580395003)(81542001)(79102001)(76482001)(92566001)(99396002)(86362001)(1496007)(15202345003)(87936001)(107986001);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB027;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02830F0362
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=punnaiah.choudary.kalluri@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s6P45PXo029776

Hi Andreas,

>-----Original Message-----
>From: Andreas FÃ¤rber [mailto:afaerber@suse.de]
>Sent: Friday, July 25, 2014 4:30 AM
>To: Michal Simek
>Cc: Andreas Olofsson; Matteo Vit; Sean Rickerd; devicetree@vger.kernel.org;
>linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org; Andreas
>FÃ¤rber; Punnaiah Choudary Kalluri; Lars-Peter Clausen
>Subject: [PATCH v2 00/11] ARM: dts: zynq: Prepare Parallella
>
>Hello,
>
>This patch series adds an initial device tree for the Parallella board.
>UART, SD card, Ethernet are enabled.
>Not yet enabled are HDMI, QSPI flash and 2x USB.
>
>v2 adds some SPI and FPGA pieces and tidies the device tree with a
>compatible string and matching documentation.
>
>Not having all pieces for testing all of this (most notably I'm missing
>ADI ADV7513 and AXI-HDMI support for VDMA and axi-clkgen, as well as
>the 25Q128A flash chip for QSPI), I've kept new things in separate patches
>so that we can make progress on the basic version and possibly squash
>further cherry-picked pieces.
>
>Punnaiah Choudary Kalluri had recently proposed to extend the Chipidea
>USB driver for Zynq; it kept complaining about the PHY though, and I
>haven't spotted a revised version based on the generic driver yet.
>https://patchwork.kernel.org/patch/4434681/

The plan is, go with generic chip idea driver which is currently under review. 
http://www.spinics.net/lists/linux-usb/msg109576.html

So, please wait some more time for extending the Chip idea driver support
 to zynq.

Punnaiah
>
>My rebasing work branch is here:
>https://github.com/afaerber/linux/commits/parallella-next
>
>Regards,
>Andreas
>
>Cc: Punnaiah Choudary Kalluri <punnaia@xilinx.com> (USB)
>Cc: Lars-Peter Clausen <lars@metafoo.de> (HDMI)
>
>Andreas FÃ¤rber (11):
>  Documentation: devicetree: Adapteva vendor prefix
>  Documentation: devicetree: Adapteva boards
>  ARM: dts: zynq: Add Parallella device tree
>  ARM: dts: zynq: Update deprecated xuartps clock names
>  ARM: dts: zynq: Add QSPI for Parallella
>  ARM: dts: zynq: Add DMAC for Parallella
>  Documentation: devicetree: Fix Xilinx VDMA specification
>  ARM: dts: zynq: Add VDMA to Parallella
>  Documentation: devicetree: Fix ADI AXI SPDIF specification
>  ARM: dts: zynq: Add SPDIF for Parallella
>  ARM: dts: zynq: Add AXI clkgen for Parallella
>
> Documentation/devicetree/bindings/arm/adapteva.txt |   7 ++
> .../devicetree/bindings/dma/xilinx/xilinx_vdma.txt |   2 +-
> .../devicetree/bindings/sound/adi,axi-spdif-tx.txt |   2 +-
> .../devicetree/bindings/vendor-prefixes.txt        |   1 +
> arch/arm/boot/dts/Makefile                         |   4 +-
> arch/arm/boot/dts/zynq-7000.dtsi                   |  58 +++++++++-
> arch/arm/boot/dts/zynq-parallella.dts              | 119
>+++++++++++++++++++++
> 7 files changed, 188 insertions(+), 5 deletions(-)
> create mode 100644 Documentation/devicetree/bindings/arm/adapteva.txt
> create mode 100644 arch/arm/boot/dts/zynq-parallella.dts
>
>--
>1.9.3

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
