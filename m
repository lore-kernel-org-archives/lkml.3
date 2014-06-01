Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170AbaFAWCQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 18:02:16 -0400
Received: from mail-by2lp0244.outbound.protection.outlook.com ([207.46.163.244]:36908
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752008AbaFAWCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 18:02:14 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "andreas.noever@gmail.com" <andreas.noever@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "greg@kroah.com" <greg@kroah.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>
Subject: Re: [PATCH v4 00/15] Thunderbolt driver for Apple MacBooks
Thread-Topic: [PATCH v4 00/15] Thunderbolt driver for Apple MacBooks
Thread-Index: AQHPfNyYVDcE17ZFH0KR3hCN8Vnny5tcCgKpgACxVyyAABUsAA==
Date: Sun, 1 Jun 2014 22:02:04 +0000
Message-ID: <1401660124.7663.22.camel@x230>
References: <1401546480-2071-1-git-send-email-andreas.noever@gmail.com>
	 <1401580281.7663.14.camel@x230>
	 <CAMxnaaURVhZ_SiJW7Qy1bsye1bcPE=J=vjL5MgTN5znP15WnXw@mail.gmail.com>
	 <1401638869.7663.21.camel@x230>
	 <CAMxnaaUJKmRrP6f2U+0-BVY_Pgz+qOn1BekGUyOqUPvp33so0w@mail.gmail.com>
In-Reply-To: <CAMxnaaUJKmRrP6f2U+0-BVY_Pgz+qOn1BekGUyOqUPvp33so0w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:6267:20ff:fec3:2318]
x-microsoft-antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
x-forefront-prvs: 02296943FF
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(428001)(51704005)(24454002)(377454003)(377424004)(189002)(199002)(92726001)(79102001)(31966008)(64706001)(20776003)(76482001)(92566001)(80022001)(77982001)(74502001)(74662001)(46102001)(19580405001)(83322001)(21056001)(81342001)(103116003)(81542001)(76176999)(54356999)(50986999)(101416001)(2656002)(87936001)(85852003)(83072002)(33716001)(86362001)(99286001)(4396001)(33646001)(99396002)(19580395003);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR05MB424;H:BN1PR05MB423.namprd05.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=matthew.garrett@nebula.com; 
Content-Type: text/plain; charset="utf-8"
Content-ID: <30757F8DEE8D1D4E95EE247AB48F3D4A@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s51M2Nks025910

On Sun, 2014-06-01 at 22:45 +0200, Andreas Noever wrote:
> On Sun, Jun 1, 2014 at 6:07 PM, Matthew Garrett
> <matthew.garrett@nebula.com> wrote:
> > Yeah, it seems I don't need the suspend quirk - the NHI is still there
> > without it. I still think we should make the quirk general rather than
> > tying it to the machines, the worst case is that it'll just do nothing.
> Ok, agreed. The "wait" quirk has to run on all machines and the other
> one will fail if the ACPI methods are not there. Should I resend the
> series or just the patch or should I (or do you want to) make a
> separate patch?

Probably best to ask Greg - I'm fine with this stuff going through his
tree (note to Greg: the Apple ACPI patches I just sent need to be merged
before this stuff will work properly)

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
