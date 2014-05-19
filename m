Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbaESB66 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 21:58:58 -0400
Received: from [207.46.163.241] ([207.46.163.241]:39266 "EHLO
	na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751046AbaESB65 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 21:58:57 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Stephen Boyd <sboyd@codeaurora.org>
CC: "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Jingchang Lu <jingchang.lu@freescale.com>
Subject: RE: [PATCHv3 3/3] clocksource: Add Freescale FlexTimer Module (FTM)
 timer support
Thread-Topic: [PATCHv3 3/3] clocksource: Add Freescale FlexTimer Module
 (FTM) timer support
Thread-Index: AQHPY1ed3mDRWUd51kaK8D+dt0JVM5tDYEWAgAPj/ZA=
Date: Mon, 19 May 2014 01:56:28 +0000
Message-ID: <561d7768407744d498a7f34a80a00af6@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1398737939-5334-1-git-send-email-Li.Xiubo@freescale.com>
 <1398737939-5334-4-git-send-email-Li.Xiubo@freescale.com>
 <5376212D.4080701@codeaurora.org>
In-Reply-To: <5376212D.4080701@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 021670B4D2
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(428001)(189002)(199002)(479174003)(51704005)(164054003)(99286001)(74662001)(76482001)(99396002)(33646001)(85852003)(81342001)(74502001)(80022001)(20776003)(31966008)(64706001)(66066001)(4396001)(83072002)(21056001)(79102001)(76576001)(81542001)(54356999)(74316001)(76176999)(46102001)(77096999)(87936001)(86362001)(92566001)(50986999)(101416001)(2656002)(83322001)(77982001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB473;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Li.Xiubo@freescale.com; 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: Re: [PATCHv3 3/3] clocksource: Add Freescale FlexTimer Module (FTM)
> timer support
> 
> On 04/28/14 19:18, Xiubo Li wrote:
> > +bool big_endian;
> > +
> 
> static?
> 

I will fix this.

Thanks,

BRs
Xiubo


> --
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> hosted by The Linux Foundation

