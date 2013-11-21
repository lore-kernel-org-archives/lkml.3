Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177Ab3KUUMS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 15:12:18 -0500
Received: from mail-bn1blp0187.outbound.protection.outlook.com ([207.46.163.187]:21882
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751226Ab3KUUMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 15:12:13 -0500
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "isimatu.yasuaki@jp.fujitsu.com" <isimatu.yasuaki@jp.fujitsu.com>
CC: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "jlee@suse.com" <jlee@suse.com>,
        "matt@console-pimps.org" <matt@console-pimps.org>,
        "richard@nod.at" <richard@nod.at>, "cxie@redhat.com" <cxie@redhat.com>
Subject: Re: [PATCH] x86, efi: add no_bricked_efi whitelist
Thread-Topic: [PATCH] x86, efi: add no_bricked_efi whitelist
Thread-Index: AQHO5ctsbQuFm47B1katHCc9ePY1AJovbqbwgACxpAA=
Date: Thu, 21 Nov 2013 20:12:05 +0000
Message-ID: <1385064722.12107.1.camel@x230>
References: <528C740A.6010407@jp.fujitsu.com>
	 <1384963376.20536.3.camel@x230> <528DD3E0.3050606@jp.fujitsu.com>
In-Reply-To: <528DD3E0.3050606@jp.fujitsu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:6267:20ff:fec3:2318]
x-forefront-prvs: 0037FD6480
x-forefront-antispam-report: SFV:NSPM;SFS:(24454002)(377424004)(189002)(199002)(56816003)(59766001)(77982001)(81816001)(87936001)(81342001)(74876001)(2656002)(65816001)(80022001)(77096001)(85306002)(76786001)(33646001)(63696002)(81686001)(79102001)(74706001)(76482001)(81542001)(74502001)(47446002)(76796001)(83322001)(33716001)(74366001)(19580395003)(53806001)(80976001)(50986001)(47736001)(31966008)(4396001)(69226001)(49866001)(47976001)(74662001)(83072001)(46102001)(54316002)(19580405001)(87266001)(54356001)(51856001)(56776001)(3826001);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR05MB424;H:BN1PR05MB423.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:6267:20ff:fec3:2318;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <AAA9EEF3E8E8834D8C669432D4B9A770@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rALKCOj7019653

On Thu, 2013-11-21 at 18:35 +0900, Yasuaki Ishimatsu wrote:

> Remaining space is free space that can be used by efi variable. But by 5KB
> threshold, we cannot use the space while running OS.

Is the situation something like(assuming a 128KB flash part):

1) 64KB of variables, 59KB of deleted variables, 5KB of free space,

or

2) 123KB of variables, 5KB of free space

?
-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
