Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558AbaDUIJq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 04:09:46 -0400
Received: from mail-bn1blp0181.outbound.protection.outlook.com ([207.46.163.181]:29888
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751265AbaDUIJn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 04:09:43 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "Jason.Jin@freescale.com" <Jason.Jin@freescale.com>,
        "Dongsheng.Wang@freescale.com" <Dongsheng.Wang@freescale.com>,
        Jingchang Lu <jingchang.lu@freescale.com>
CC: "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH 0/3] clocksource: Add Freescale FlexTimer Module (FTM)
 timer support
Thread-Topic: [PATCH 0/3] clocksource: Add Freescale FlexTimer Module (FTM)
 timer support
Thread-Index: AQHPXTg373dymIQqvkGJjKPcMd6l4psbt1Xw
Date: Mon, 21 Apr 2014 08:09:40 +0000
Message-ID: <2b156cf0fffb42df84c0035535bc6672@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1398064800-27250-1-git-send-email-Li.Xiubo@freescale.com>
In-Reply-To: <1398064800-27250-1-git-send-email-Li.Xiubo@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 0188D66E61
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(13464003)(377454003)(189002)(199002)(51704005)(164054003)(50986999)(54356999)(99286001)(76176999)(2656002)(76482001)(99396002)(81542001)(87936001)(74316001)(19580405001)(77096999)(4396001)(81342001)(46102001)(79102001)(83322001)(19580395003)(74662001)(80976001)(74502001)(33646001)(31966008)(76576001)(2201001)(92566001)(20776003)(77982001)(80022001)(85852003)(83072002)(66066001)(86362001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB378;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:F49FCFBA.2C30AD6D.7FE163B3.10EE2A99.2023B;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

@All,

Please ignore this patch series, I just forgot the V2 tag, I have resent a 
New one.

Thanks,
BRs
Xiubo



> -----Original Message-----
> From: Xiubo Li [mailto:Li.Xiubo@freescale.com]
> Sent: Monday, April 21, 2014 3:20 PM
> To: daniel.lezcano@linaro.org; tglx@linutronix.de; shawn.guo@linaro.org; Jin
> Zhengxiong-R64188; Wang Dongsheng-B40534; Lu Jingchang-B35083
> Cc: linux-doc@vger.kernel.org; linux-kernel@vger.kernel.org;
> devicetree@vger.kernel.org; linux-arm-kernel@lists.infradead.org; Xiubo Li-
> B47053
> Subject: [PATCH 0/3] clocksource: Add Freescale FlexTimer Module (FTM) timer
> support
> 
> 
> Changes in V2:
> - Add big-endian support.
> - Add using pr_err instead of BUG_ON.
> - Add more detail comment message of FTM.
> - Add DT binding documentation.
> - Remove some header files and macros not useful.
> 
> 
> 
> Xiubo Li (3):
>   clocksource: ftm: Add FlexTimer Module (FTM) Timer devicetree
>     Documentation
>   ARM: dts: vf610: Add Freescale FlexTimer Module timer node.
>   clocksource: Add Freescale FlexTimer Module (FTM) timer support
> 
>  .../devicetree/bindings/timer/fsl,ftm-timer.txt    |  31 ++
>  arch/arm/boot/dts/vf610.dtsi                       |  12 +
>  drivers/clocksource/Kconfig                        |   5 +
>  drivers/clocksource/Makefile                       |   1 +
>  drivers/clocksource/fsl_ftm_timer.c                | 344
> +++++++++++++++++++++
>  5 files changed, 393 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/timer/fsl,ftm-timer.txt
>  create mode 100644 drivers/clocksource/fsl_ftm_timer.c
> 
> --
> 1.8.4

