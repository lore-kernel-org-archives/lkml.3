Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933880AbaJUVZc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 17:25:32 -0400
Received: from na01-by1-obe.ptr.o365filtering.com ([64.4.22.91]:16240 "EHLO
	na01-by1-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933551AbaJUVZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 17:25:29 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Sitsofe Wheeler <sitsofe@gmail.com>, Long Li <longli@microsoft.com>
CC: David Miller <davem@davemloft.net>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: [PATCH net 1/1] hyperv: Fix a bug in netvsc_send()
Thread-Topic: [PATCH net 1/1] hyperv: Fix a bug in netvsc_send()
Thread-Index: AQHP4LqXSzhzQOY9SUC8nws4UsmIr5wiQ3WAgAWF5YCAAjppkIAAuTcAgBAlvfGAALmzAP//jDvw
Date: Tue, 21 Oct 2014 21:25:01 +0000
Message-ID: <19043471dd2242d993fbf4e22a8c246b@DFM-DB3MBX15-08.exchange.corp.microsoft.com>
References: <1412530971-29897-1-git-send-email-kys@microsoft.com>
	<20141005.211129.632749242463744635.davem@davemloft.net>
	<20141009133200.GA17134@sucs.org>
	<96f3d4f6b90a461686b23f64aedcb4fc@BL2PR03MB132.namprd03.prod.outlook.com>
	<20141011103630.GA22272@sucs.org>	<1413911624662.86334@microsoft.com>
 <CALjAwxj1jHUugt+vtJL7duXfTpdoxmCrwTzRmNHGgOdj+Ju3Aw@mail.gmail.com>
In-Reply-To: <CALjAwxj1jHUugt+vtJL7duXfTpdoxmCrwTzRmNHGgOdj+Ju3Aw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.159.99;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(51704005)(13464003)(189002)(377454003)(199003)(24454002)(92566001)(15202345003)(64706001)(20776003)(1511001)(106116001)(106466001)(21056001)(66066001)(4396001)(68736004)(84676001)(6806004)(50466002)(47776003)(19580405001)(86612001)(44976005)(77096999)(23676002)(50986999)(54356999)(31966008)(120916001)(76482002)(87936001)(46102003)(99396003)(108616004)(93886004)(33646002)(2656002)(19580395003)(15975445006)(85306004)(85852003)(2421001)(76176999)(80022003)(2009001)(107046002)(2561002)(97736003)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUSR01MB589;H:hybrid.exchange.microsoft.com;FPR:;PTR:InfoDomainNonexistent;MX:3;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUSR01MB589;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0371762FE7
Authentication-Results: spf=pass (sender IP is 131.107.159.99)
 smtp.mailfrom=haiyangz@microsoft.com; 
X-OriginatorOrg: msft.ccsctp.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9LLPbon002953



> -----Original Message-----
> From: Sitsofe Wheeler [mailto:sitsofe@gmail.com]
> Sent: Tuesday, October 21, 2014 5:16 PM
> To: Long Li
> Cc: David Miller; olaf@aepfle.de; netdev@vger.kernel.org;
> jasowang@redhat.com; linux-kernel@vger.kernel.org; apw@canonical.com;
> devel@linuxdriverproject.org; Haiyang Zhang
> Subject: Re: [PATCH net 1/1] hyperv: Fix a bug in netvsc_send()
> 
> On 21 October 2014 18:13, Long Li <longli@microsoft.com> wrote:
> > Thanks Sitsofe. This should have been fixed by this patch:
> > http://git.kernel.org/cgit/linux/kernel/git/next/linux-
> next.git/commit/?id=f88e67149f97d73c704d6fe6f492edde97463025
> >
> > Can you give it a try?
> 
> Ah this one went mainline a few days ago so I've already been trying
> it. Yes it resolves my problem (that system is no longer oopsing on
> startup). I'd have added my Tested-by but it's already been committed
> :-)

Thank you for the test!

- Haiyang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
