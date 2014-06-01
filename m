Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbaFAWIA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 18:08:00 -0400
Received: from [207.46.163.207] ([207.46.163.207]:6583 "EHLO
	na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752008AbaFAWH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 18:07:59 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "andreas.noever@gmail.com" <andreas.noever@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "greg@kroah.com" <greg@kroah.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>
Subject: Re: [PATCH] Thunderbolt: Add support for Thunderbolt 2 host
 controllers
Thread-Topic: [PATCH] Thunderbolt: Add support for Thunderbolt 2 host
 controllers
Thread-Index: AQHPfbSCcKtGQUzwlE2mL0IcdUz35ZtcuJSAgAAXOQA=
Date: Sun, 1 Jun 2014 22:05:32 +0000
Message-ID: <1401660332.7663.26.camel@x230>
References: <1401639223-3441-1-git-send-email-matthew.garrett@nebula.com>
	 <CAMxnaaUh0s5A6x=N9VEeHGFkATDsYAtfz3JoLOLYA5jKSVyFwA@mail.gmail.com>
In-Reply-To: <CAMxnaaUh0s5A6x=N9VEeHGFkATDsYAtfz3JoLOLYA5jKSVyFwA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:6267:20ff:fec3:2318]
x-microsoft-antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
x-forefront-prvs: 02296943FF
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(428001)(51704005)(24454002)(377424004)(189002)(199002)(86362001)(76482001)(46102001)(92566001)(92726001)(77982001)(99286001)(31966008)(74662001)(99396002)(74502001)(81542001)(81342001)(101416001)(20776003)(79102001)(64706001)(54356999)(76176999)(50986999)(87936001)(19580395003)(83322001)(2656002)(85852003)(103116003)(33716001)(4396001)(33646001)(80022001)(21056001)(19580405001)(83072002);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR05MB422;H:BN1PR05MB423.namprd05.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=matthew.garrett@nebula.com; 
Content-Type: text/plain; charset="utf-8"
Content-ID: <4FED8E880E8E3A46B20F9C8AD7EAF5B8@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s51M8Inn025918

On Sun, 2014-06-01 at 22:42 +0200, Andreas Noever wrote:

> Just to check: Did they split up the device ids? Is 0x156d for the
> bridges and 0x156c for the NHI?

Yes. Some kind of progress. I did notice that the Apple driver binds to
all devices with the system peripheral class, vendor 8086 and device
15xx - I don't think we can represent that in Linux at the moment.

> I have had a look at what os x does. They split between:
> 1513, 151a, 1549 and 1547, 1548, 1567, 1569, 156b, 156d (the latter
> group gets bit 3 set)
> 
> It looks like the first 3 are legacy devices, so maybe reverse the check?

Seems fair. I probably won't have time to resend for a couple of days -
if it's easier, please do just rework this yourself.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
