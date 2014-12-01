Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582AbaLADKa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 22:10:30 -0500
Received: from mail-bn1bbn0101.outbound.protection.outlook.com ([157.56.111.101]:34024
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752406AbaLADK3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 22:10:29 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: "plagnioj@jcrosoft.com" <plagnioj@jcrosoft.com>,
        "tomi.valkeinen@ti.com" <tomi.valkeinen@ti.com>
CC: "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/4] LS1021A: Add dcfb framebuffer driver support.
Thread-Topic: [PATCH 0/4] LS1021A: Add dcfb framebuffer driver support.
Thread-Index: AQHQB9CG/zQivB3onUuZpP6aA8mF6Zx6D3jw
Date: Mon, 1 Dec 2014 02:38:12 +0000
Message-ID: <BY2PR0301MB0613C9A88CF0353C0B41603B9B7D0@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1416824454-28156-1-git-send-email-Li.Xiubo@freescale.com>
In-Reply-To: <1416824454-28156-1-git-send-email-Li.Xiubo@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.53]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0615;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0615;
x-forefront-prvs: 0412A98A59
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(13464003)(199003)(377454003)(189002)(51704005)(54356999)(106116001)(54606007)(101416001)(92566001)(92726001)(76176999)(50986999)(74316001)(64706001)(66066001)(33656002)(20776003)(87936001)(2656002)(99286002)(95666004)(106356001)(76576001)(40100003)(105586002)(46102003)(19580395003)(19580405001)(99396003)(77096004)(107046002)(120916001)(122556002)(4396001)(31966008)(21056001)(86362001)(54206007)(62966003)(77156002)(2501002)(97736003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0615;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'd like to know the status of this patches for internal release needed.

Thanks very much,

BRs
Xiubo


> -----Original Message-----
> From: Xiubo Li [mailto:Li.Xiubo@freescale.com]
> Sent: Monday, November 24, 2014 6:21 PM
> To: plagnioj@jcrosoft.com; tomi.valkeinen@ti.com
> Cc: shawn.guo@linaro.org; linux-fbdev@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; linux-kernel@vger.kernel.org; Xiubo Li-B47053
> Subject: [PATCH 0/4] LS1021A: Add dcfb framebuffer driver support.
> 
> Framebuffer driver for the Freescale SoC Display Controller.
> 
> Xiubo Li (4):
>   video: fsl-dcfb: Add dcfb framebuffer driver for LS1021A platform
>   video: fsl-dcfb: Add devicetree binding support
>   ARM: ls1021a: dtsi: Add dt node support for dcfb.
>   ARM: ls1021a: dts: Add and enable dt node for dcfb.
> 
>  .../devicetree/bindings/video/fsl,dcfb.txt         |  52 ++
>  arch/arm/boot/dts/ls1021a-twr.dts                  |  26 +
>  arch/arm/boot/dts/ls1021a.dtsi                     |  10 +
>  drivers/video/fbdev/Kconfig                        |  19 +
>  drivers/video/fbdev/Makefile                       |   1 +
>  drivers/video/fbdev/fsl-dcfb.c                     | 811
> +++++++++++++++++++++
>  6 files changed, 919 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/video/fsl,dcfb.txt
>  create mode 100644 drivers/video/fbdev/fsl-dcfb.c
> 
> --
> 2.1.0.27.g96db324

