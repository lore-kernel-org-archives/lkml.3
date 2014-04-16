Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751019AbaDPAwC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 20:52:02 -0400
Received: from mail-bl2lp0209.outbound.protection.outlook.com ([207.46.163.209]:4937
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750893AbaDPAwA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 20:52:00 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
CC: "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] clocksource: vf_pit_timer: fix pit_read_sched_clock
Thread-Topic: [PATCH] clocksource: vf_pit_timer: fix pit_read_sched_clock
Thread-Index: AQHPWJ5Dmf5uRix0PEiReOUo4THmtZsSnUCAgACby4CAAC3BgA==
Date: Wed, 16 Apr 2014 00:51:46 +0000
Message-ID: <1c0b5bd606d34ecaa0742c9aaa17e7cf@DM2PR03MB509.namprd03.prod.outlook.com>
References: <1397558929-12123-1-git-send-email-Li.Xiubo@freescale.com>
 <534D27AB.7070109@linaro.org>
 <alpine.DEB.2.02.1404152352560.22697@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1404152352560.22697@ionos.tec.linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 01834E39B7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(164054003)(199002)(189002)(51704005)(81342001)(33646001)(76176999)(54356999)(4396001)(46102001)(77096999)(80022001)(83322001)(76576001)(74316001)(79102001)(76482001)(31966008)(74662001)(50986999)(66066001)(74502001)(558084003)(81542001)(99396002)(80976001)(92566001)(20776003)(77982001)(87936001)(99286001)(83072002)(85852003)(86362001)(2656002)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB511;H:DM2PR03MB509.namprd03.prod.outlook.com;FPR:EF4BA23F.1CC3E5D2.6AE68ABB.58857ED0.20097;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> > thanks for the patch but this has already been fixed [1] and is available in
> > the timers/urgent branch.
> 
> It's in Linus tree already and tagged for stable.
> 

Yes, I have found it, I was developing this in the old tree...
:)

Thanks,

BRs
Xiubo
