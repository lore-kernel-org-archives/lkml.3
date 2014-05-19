Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492AbaESJRp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 05:17:45 -0400
Received: from mail-bl2lp0205.outbound.protection.outlook.com ([207.46.163.205]:44836
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752057AbaESJRn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 05:17:43 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [PATCHv3 0/3] clocksource: Add Freescale FlexTimer Module (FTM)
 timer support
Thread-Topic: [PATCHv3 0/3] clocksource: Add Freescale FlexTimer Module
 (FTM) timer support
Thread-Index: AQHPY1eYWo/zs3B7k0i/5DbFQOUNw5tHvqwAgAAAy1A=
Date: Mon, 19 May 2014 09:17:28 +0000
Message-ID: <29474d5a171e4ac8940f332706dd816a@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1398737939-5334-1-git-send-email-Li.Xiubo@freescale.com>
 <5379CB5C.1070202@linaro.org>
In-Reply-To: <5379CB5C.1070202@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 021670B4D2
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(428001)(52034003)(199002)(189002)(51704005)(164054003)(21056001)(92566001)(77982001)(99396002)(2201001)(99286001)(80022001)(66066001)(85852003)(64706001)(83322001)(46102001)(74662001)(31966008)(74502001)(83072002)(76482001)(79102001)(87936001)(2656002)(20776003)(81342001)(101416001)(86362001)(77096999)(15395725003)(33646001)(81542001)(4396001)(76176999)(19580395003)(76576001)(74316001)(50986999)(54356999)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB508;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Li.Xiubo@freescale.com; 
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s4J9HnoY001943

> > Xiubo Li (3):
> >    clocksource: ftm: Add FlexTimer Module (FTM) Timer devicetree
> >      Documentation
> >    ARM: dts: vf610: Add Freescale FlexTimer Module timer node.
> >    clocksource: Add Freescale FlexTimer Module (FTM) timer support
> >
> >   .../devicetree/bindings/timer/fsl,ftm-timer.txt    |  31 ++
> >   arch/arm/boot/dts/vf610.dtsi                       |  12 +
> >   drivers/clocksource/Kconfig                        |   5 +
> >   drivers/clocksource/Makefile                       |   1 +
> >   drivers/clocksource/fsl_ftm_timer.c                | 344
> +++++++++++++++++++++
> >   5 files changed, 393 insertions(+)
> >   create mode 100644 Documentation/devicetree/bindings/timer/fsl,ftm-
> timer.txt
> >   create mode 100644 drivers/clocksource/fsl_ftm_timer.c
> 
> By the way, when reposting the serie, could you please add Rob Herring
> and Grant likely as Cc to review the dts part ?
> 

No problem.

Thanks,

BRs
Xiubo


> Thanks
>    -- Daniel
> 
> --
>   <http://www.linaro.org/> Linaro.org â”‚ Open source software for ARM SoCs
> 
> Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
> <http://twitter.com/#!/linaroorg> Twitter |
> <http://www.linaro.org/linaro-blog/> Blog

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
