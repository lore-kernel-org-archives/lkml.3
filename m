Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320AbaKUJQa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 04:16:30 -0500
Received: from mail-bn1bon0147.outbound.protection.outlook.com ([157.56.111.147]:51072
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751174AbaKUJQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 04:16:27 -0500
X-Greylist: delayed 6418 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Nov 2014 04:16:27 EST
From: Yuantian Tang <Yuantian.Tang@freescale.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        "Jason.Jin@freescale.com" <Jason.Jin@freescale.com>
Subject: RE: [PATCH 2/2] cpufreq: qoriq: rename the driver
Thread-Topic: [PATCH 2/2] cpufreq: qoriq: rename the driver
Thread-Index: AQHQBVzhF5TdVORmqkCz8HfXsQR2dJxqtngAgAAVqvA=
Date: Fri, 21 Nov 2014 09:16:23 +0000
Message-ID: <dedc11e3150d44ee89bb1e96b5447687@DM2PR03MB574.namprd03.prod.outlook.com>
References: <1416554882-16566-1-git-send-email-Yuantian.Tang@freescale.com>
	<1416554882-16566-2-git-send-email-Yuantian.Tang@freescale.com>
 <CAKohpo=xLOxXrCJNO0LmrVxMDNsFy2Kxg6bNzHm=vQCJnBvSaw@mail.gmail.com>
In-Reply-To: <CAKohpo=xLOxXrCJNO0LmrVxMDNsFy2Kxg6bNzHm=vQCJnBvSaw@mail.gmail.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.158.211]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1287;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1287;
x-forefront-prvs: 0402872DA1
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(13464003)(51704005)(199003)(189002)(24454002)(164054003)(24434003)(377454003)(97736003)(54356999)(2656002)(101416001)(122556002)(31966008)(74316001)(110136001)(87936001)(108616004)(46102003)(33646002)(19580405001)(76176999)(120916001)(76576001)(21056001)(50986999)(19580395003)(86362001)(20776003)(66066001)(95666004)(105586002)(99286002)(4396001)(40100003)(106356001)(99396003)(106116001)(77156002)(92566001)(64706001)(62966003)(107046002)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0301MB1287;H:DM2PR03MB574.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sAL9Gdo6016269

Hello Viresh,

When I use -C -M options, checkpatch reports error:

[tangyt@titan linux-pm]$ ./scripts/checkpatch.pl 0002-cpufreq-qoriq-rename-the-driver.patch 
WARNING: added, moved or deleted file(s), does MAINTAINERS need updating?
#15: 
 drivers/cpufreq/{ppc-corenet-cpufreq.c => qoriq-cpufreq.c} | 0

ERROR: Does not appear to be a unified-diff format patch

total: 1 errors, 1 warnings, 0 lines checked

0002-cpufreq-qoriq-rename-the-driver.patch has style problems, please review.

I just rename it and do not change anyting. Isn't that allowed?

Thanks,
Yuantian

> -----Original Message-----
> From: Viresh Kumar [mailto:viresh.kumar@linaro.org]
> Sent: Friday, November 21, 2014 3:56 PM
> To: Tang Yuantian-B29983
> Cc: Rafael J. Wysocki; Linux Kernel Mailing List; linux-pm@vger.kernel.org;
> linuxppc-dev@ozlabs.org; Jin Zhengxiong-R64188
> Subject: Re: [PATCH 2/2] cpufreq: qoriq: rename the driver
> 
> On 21 November 2014 12:58, Tang Yuantian <Yuantian.Tang@freescale.com>
> wrote:
> > This driver works on all QorIQ platforms which include ARM-based cores
> > and PPC-based cores.
> > Rename it in order to represent better.
> >
> > Signed-off-by: Tang Yuantian <Yuantian.Tang@freescale.com>
> > ---
> >  drivers/cpufreq/ppc-corenet-cpufreq.c | 371 ----------------------------------
> >  drivers/cpufreq/qoriq-cpufreq.c       | 371
> ++++++++++++++++++++++++++++++++++
> >  2 files changed, 371 insertions(+), 371 deletions(-)  delete mode
> > 100644 drivers/cpufreq/ppc-corenet-cpufreq.c
> >  create mode 100644 drivers/cpufreq/qoriq-cpufreq.c
> 
> This is not reviewable at all.. How do I verify that you haven't changed something
> in the files as well ?
> 
> To make life easy always create patches with:
> 
> git format-patch -C -M
> 
> Above options handle renames pretty well.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
