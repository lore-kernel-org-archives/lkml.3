Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714AbaICDuf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 23:50:35 -0400
Received: from mail-bn1lp0140.outbound.protection.outlook.com ([207.46.163.140]:56489
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753439AbaICDue convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 23:50:34 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>
CC: "Dongsheng.Wang@freescale.com" <Dongsheng.Wang@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/5] Clocksource: Flextimer: Merged to LS1
Thread-Topic: [PATCH 0/5] Clocksource: Flextimer: Merged to LS1
Thread-Index: AQHPwPGd9AH53fMtSU2fkniGB8TfU5vu0l4A
Date: Wed, 3 Sep 2014 03:50:29 +0000
Message-ID: <55643a67eb1a4157b18fc8483d072908@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1409031951-39021-1-git-send-email-Li.Xiubo@freescale.com>
In-Reply-To: <1409031951-39021-1-git-send-email-Li.Xiubo@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;UriScan:;
x-forefront-prvs: 032334F434
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(199003)(51704005)(189002)(164054003)(13464003)(377454003)(66066001)(79102001)(101416001)(46102001)(76482001)(74316001)(76176999)(50986999)(99396002)(81542001)(81342001)(80022001)(85306004)(2501002)(74662001)(31966008)(2656002)(20776003)(54356999)(107046002)(64706001)(99286002)(86362001)(106116001)(95666004)(106356001)(108616004)(77096002)(105586002)(83072002)(85852003)(4396001)(87936001)(21056001)(83322001)(33646002)(92566001)(90102001)(77982001)(19580395003)(74502001)(19580405001)(76576001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB191;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping :)

Thanks,

BRs
Xiubo




> -----Original Message-----
> From: Xiubo Li [mailto:Li.Xiubo@freescale.com]
> Sent: Tuesday, August 26, 2014 1:46 PM
> To: daniel.lezcano@linaro.org; tglx@linutronix.de
> Cc: Wang Dongsheng-B40534; linux-kernel@vger.kernel.org; Xiubo Li-B47053
> Subject: [PATCH 0/5] Clocksource: Flextimer: Merged to LS1
> 
> 
> Xiubo Li (5):
>   Clocksource: Flextimer: Set cpumask to cpu_possible_mask
>   Clocksource: Flextimer: Use internal clocksource read API.
>   Clocksource: Flextimer: Remove the useless code.
>   Clocksource: Flextimer: Fix counter clock prescaler calculation.
>   Clocksource: Flextimer: Use Macro for clock source selection.
> 
>  drivers/clocksource/fsl_ftm_timer.c | 20 +++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)
> 
> --
> 1.8.5

