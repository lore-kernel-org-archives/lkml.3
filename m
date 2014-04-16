Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501AbaDPAd0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 20:33:26 -0400
Received: from mail-bn1lp0142.outbound.protection.outlook.com ([207.46.163.142]:46364
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750885AbaDPAdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 20:33:25 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] clocksource: vf_pit_timer: fix pit_read_sched_clock
Thread-Topic: [PATCH] clocksource: vf_pit_timer: fix pit_read_sched_clock
Thread-Index: AQHPWJ5Dmf5uRix0PEiReOUo4THmtZsSnUCAgADIKWA=
Date: Wed, 16 Apr 2014 00:33:21 +0000
Message-ID: <a8ceaacf40194e60b85c6c1af17aabe4@DM2PR03MB509.namprd03.prod.outlook.com>
References: <1397558929-12123-1-git-send-email-Li.Xiubo@freescale.com>
 <534D27AB.7070109@linaro.org>
In-Reply-To: <534D27AB.7070109@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 01834E39B7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(51704005)(189002)(199002)(164054003)(92566001)(2201001)(20776003)(81542001)(80976001)(99396002)(85852003)(83072002)(86362001)(2656002)(87936001)(77982001)(99286001)(33646001)(76176999)(46102001)(4396001)(54356999)(81342001)(74662001)(31966008)(76482001)(79102001)(74502001)(50986999)(66066001)(77096999)(83322001)(80022001)(74316001)(76576001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB511;H:DM2PR03MB509.namprd03.prod.outlook.com;FPR:E869F52D.1CF2D4E2.6DF9B5A2.A8FE3233.20117;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3G0XYsf031422


> > diff --git a/drivers/clocksource/vf_pit_timer.c
> b/drivers/clocksource/vf_pit_timer.c
> > index 02821b0..a918bc4 100644
> > --- a/drivers/clocksource/vf_pit_timer.c
> > +++ b/drivers/clocksource/vf_pit_timer.c
> > @@ -54,7 +54,7 @@ static inline void pit_irq_acknowledge(void)
> >
> >   static u64 pit_read_sched_clock(void)
> >   {
> > -	return __raw_readl(clksrc_base + PITCVAL);
> > +	return ~__raw_readl(clksrc_base + PITCVAL);
> >   }
> >
> >   static int __init pit_clocksource_init(unsigned long rate)
> >
> 
> Hi Xiubo,
> 
> thanks for the patch but this has already been fixed [1] and is
> available in the timers/urgent branch.
> 

Good news and I will pull it.

Thanks,

BRs
Xiubo
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
