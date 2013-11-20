Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134Ab3KTQDF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 11:03:05 -0500
Received: from mail-by2lp0241.outbound.protection.outlook.com ([207.46.163.241]:10619
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753830Ab3KTQDB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 11:03:01 -0500
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
Thread-Index: AQHO5ctsbQuFm47B1katHCc9ePY1AJouSFwA
Date: Wed, 20 Nov 2013 16:02:57 +0000
Message-ID: <1384963376.20536.3.camel@x230>
References: <528C740A.6010407@jp.fujitsu.com>
In-Reply-To: <528C740A.6010407@jp.fujitsu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:6267:20ff:fec3:2318]
x-forefront-prvs: 0036736630
x-forefront-antispam-report: SFV:NSPM;SFS:(189002)(199002)(24454002)(377424004)(31966008)(47736001)(50986001)(47976001)(74662001)(49866001)(4396001)(53806001)(69226001)(74366001)(19580395003)(80976001)(19580405001)(87266001)(46102001)(83072001)(54316002)(51856001)(56776001)(54356001)(81342001)(2656002)(65816001)(77096001)(80022001)(74876001)(77982001)(81816001)(56816003)(59766001)(87936001)(76482001)(47446002)(74502001)(83322001)(81542001)(33716001)(76796001)(74706001)(63696002)(33646001)(85306002)(76786001)(81686001)(79102001)(3826001);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR05MB424;H:BN1PR05MB423.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:6267:20ff:fec3:2318;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <EF699C1FFAC7AD4885B63996E56B9E61@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rAKG39Rv010549

On Wed, 2013-11-20 at 17:34 +0900, Yasuaki Ishimatsu wrote:

> When booting my system, remaining space of efi variable storage is about
> 5KB. So there is no room that sets a new variable to the storage. On my
> system, trigger of gc is when EFI_OUT_OF_RESOURCES occurs on pre OS
> environment with UEFI. So if EFI_OUT_OF_RESOURCES occurs by the 5Kbyte
> threshold, nvram storage cannot be used until EFI_OUT_OF_RESOURCES occurs
> on pre OS environment with UEFI.

By "remaining space is about 5KB", do you mean that the rest of the
space is filled with variables or do you mean that there is more free
space but it hasn't been garbage collected?

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
