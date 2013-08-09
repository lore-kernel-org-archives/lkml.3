Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967974Ab3HIQL0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 12:11:26 -0400
Received: from mail-bl2lp0204.outbound.protection.outlook.com ([207.46.163.204]:22297
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933806Ab3HIQLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 12:11:25 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Vivek Goyal <vgoyal@redhat.com>
CC: "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kexec: Disable at runtime if the kernel enforces module
 signing
Thread-Topic: [PATCH] kexec: Disable at runtime if the kernel enforces
 module signing
Thread-Index: AQHOlNUf4AGnYDKZIEqWyysq/RT6S5mMthMAgABEgACAAAfdgIAACeoA
Date: Fri, 9 Aug 2013 16:11:09 +0000
Message-ID: <1376064648.15604.5.camel@x230>
References: <1376033797-24970-1-git-send-email-matthew.garrett@nebula.com>
	 <20130809110200.GA9631@redhat.com> <1376060830.2021.12.camel@x230>
	 <20130809153519.GI12688@redhat.com>
In-Reply-To: <20130809153519.GI12688@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:6267:20ff:fec3:2318]
x-forefront-prvs: 0933E9FD8D
x-forefront-antispam-report: SFV:NSPM;SFS:(377424004)(24454002)(199002)(189002)(80022001)(33716001)(77982001)(16406001)(54316002)(81342001)(74876001)(49866001)(33646001)(80976001)(83072001)(54356001)(76786001)(56776001)(63696002)(77096001)(46102001)(56816003)(47976001)(81686001)(83322001)(53806001)(74662001)(31966008)(81542001)(51856001)(47446002)(69226001)(47736001)(19580405001)(76796001)(19580395003)(74366001)(59766001)(65816001)(76482001)(79102001)(74502001)(74706001)(50986001)(4396001)(3826001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR05MB224;H:BY2PR05MB222.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:6267:20ff:fec3:2318;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <1A1E39FF1A57E04996AF4100FB8EEEBF@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r79GBVK9011031

On Fri, 2013-08-09 at 11:35 -0400, Vivek Goyal wrote:

> Also what about all the other patches you had for secureboot where you
> closed down all the paths where root could write to kernel memory. So
> if you want to protect sig_enforce boolean, then you need to close down
> all these paths irrespective of secureboot?

Fair point. The bar is slightly higher there, but yes, it seems
reasonable to say that enforcing module signing (and, come to think of
it, modules_disabled) should also lock down the other obvious mechanisms
for root to get code into the kernel.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
