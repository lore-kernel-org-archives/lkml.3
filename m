Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205AbaJ0Djq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 23:39:46 -0400
Received: from mail-bl2on0116.outbound.protection.outlook.com ([65.55.169.116]:31618
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751984AbaJ0Djo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 23:39:44 -0400
From: Yuantian Tang <Yuantian.Tang@freescale.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>
Subject: RE: [PATCH] cpufreq: qoriq: Make the driver usable on all QorIQ
 platforms
Thread-Topic: [PATCH] cpufreq: qoriq: Make the driver usable on all QorIQ
 platforms
Thread-Index: AQHP6bh2NIuvlhOTzUyj6ABxjLiyN5wz774AgAZVyiCAAALMgIAJE1uw
Date: Mon, 27 Oct 2014 03:39:40 +0000
Message-ID: <c94b68be09dd4bfaa8a80d9877362fb5@DM2PR03MB574.namprd03.prod.outlook.com>
References: <1413515616-15874-1-git-send-email-B29983@freescale.com>
	<CAKohpokotKSvQ13uU4MnCer+qzBUUbGVTd19y7xswCAEKk3nGQ@mail.gmail.com>
	<6aaa50ef5f234fe2896f1c66eb646dfb@DM2PR03MB574.namprd03.prod.outlook.com>
 <CAKohpokSuKOwZ3-OWFtU0z7E1fsMg4tyPiUoFUfw26pD9Py=MA@mail.gmail.com>
In-Reply-To: <CAKohpokSuKOwZ3-OWFtU0z7E1fsMg4tyPiUoFUfw26pD9Py=MA@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [192.88.158.211]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB576;UriScan:;
x-forefront-prvs: 0377802854
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(377454003)(51704005)(199003)(24454002)(13464003)(86362001)(110136001)(74316001)(33646002)(50986999)(54356999)(21056001)(92566001)(76576001)(4396001)(101416001)(76176999)(93886004)(120916001)(85306004)(106356001)(122556002)(107046002)(19580405001)(19580395003)(40100003)(106116001)(105586002)(95666004)(99286002)(20776003)(108616004)(66066001)(64706001)(76482002)(31966008)(87936001)(46102003)(80022003)(97736003)(2656002)(85852003)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR03MB576;H:DM2PR03MB574.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB335;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9R3dpIR002924


> -----Original Message-----
> From: Viresh Kumar [mailto:viresh.kumar@linaro.org]
> Sent: Tuesday, October 21, 2014 5:04 PM
> To: Tang Yuantian-B29983
> Cc: Rafael J. Wysocki; Linux Kernel Mailing List; linux-pm@vger.kernel.org;
> linuxppc-dev@ozlabs.org
> Subject: Re: [PATCH] cpufreq: qoriq: Make the driver usable on all QorIQ
> platforms
> 
> On 21 October 2014 14:29, Yuantian Tang <Yuantian.Tang@freescale.com>
> wrote:
> > If I do so, menuconfig will display like this(on PPC):
> >         PowerPC CPU frequency scaling drivers  ----
> >     QorIQ CPU Frequency scaling  --->
> >                 <*> CPU frequency scaling driver for Freescale QorIQ
> > SoCs On ARM, there should be a similar problem.
> > Isn't weird?
> 
> Similar is true for cpufreq-cpu0 driver as well.. Maybe we can create a
> Kconfig.drivers configuration and include it from all architecture specific ones ?
> 
> @ Rafael ?

Do we have a conclusion yet?

Regards,
Yuantian
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
