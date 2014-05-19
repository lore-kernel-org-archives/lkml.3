Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbaESB5n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 21:57:43 -0400
Received: from [207.46.163.208] ([207.46.163.208]:8078 "EHLO
	na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751046AbaESB5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 21:57:41 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Jingchang Lu <jingchang.lu@freescale.com>
Subject: RE: [PATCHv3 3/3] clocksource: Add Freescale FlexTimer Module (FTM)
 timer support
Thread-Topic: [PATCHv3 3/3] clocksource: Add Freescale FlexTimer Module
 (FTM) timer support
Thread-Index: AQHPY1ed3mDRWUd51kaK8D+dt0JVM5tDRxUAgAP8vNA=
Date: Mon, 19 May 2014 01:55:05 +0000
Message-ID: <ab6d3e36d7a249c9af56ab8e14e76d7d@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1398737939-5334-1-git-send-email-Li.Xiubo@freescale.com>
 <1398737939-5334-4-git-send-email-Li.Xiubo@freescale.com>
 <53760C0C.4070002@linaro.org>
In-Reply-To: <53760C0C.4070002@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 021670B4D2
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(428001)(51704005)(164054003)(189002)(199002)(74316001)(20776003)(2201001)(92566001)(79102001)(83072002)(85852003)(19580395003)(101416001)(83322001)(66066001)(77982001)(80022001)(64706001)(87936001)(74662001)(76176999)(50986999)(2656002)(4396001)(81342001)(15395725003)(99396002)(76576001)(81542001)(99286001)(21056001)(74502001)(33646001)(76482001)(86362001)(31966008)(46102001)(54356999)(77096999)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB476;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Li.Xiubo@freescale.com; 
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s4J1vrZr032034

> > +static void __iomem *clksrc_base;
> > +static void __iomem *clkevt_base;
> > +static unsigned long peroidic_cyc;
> 
> peroidic_cyc ? Did you mean periodic_cyc ? :)
> 

Yes, I'll fix it.

Thanks,

BRs
Xiubo


> 
> 
> --
>   <http://www.linaro.org/> Linaro.org â”‚ Open source software for ARM SoCs
> 
> Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
> <http://twitter.com/#!/linaroorg> Twitter |
> <http://www.linaro.org/linaro-blog/> Blog

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
