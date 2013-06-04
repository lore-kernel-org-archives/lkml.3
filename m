Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124Ab3FDM1q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 08:27:46 -0400
Received: from mail-bn1lp0157.outbound.protection.outlook.com ([207.46.163.157]:16553
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752908Ab3FDM1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 08:27:42 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Matt Fleming <matt.fleming@intel.com>
CC: "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] UEFI: Don't pass boot services regions to
 SetVirtualAddressMap()
Thread-Topic: [PATCH] UEFI: Don't pass boot services regions to
 SetVirtualAddressMap()
Thread-Index: AQHOX95QV2ajzPqiAkOZ2NQHahADkpklIiEAgABb7gA=
Date: Tue, 4 Jun 2013 12:27:40 +0000
Message-ID: <1370348858.6315.19.camel@x230.lan>
References: <1370211145-7273-1-git-send-email-matthew.garrett@nebula.com>
	 <51AD901C.30607@intel.com>
In-Reply-To: <51AD901C.30607@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.84.4]
x-forefront-antispam-report: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:BL2PR05MB211;H:BL2PR05MB211.namprd05.prod.outlook.com;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <697A63B60EA1AF4899149BDFCDBF1A60@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r54CRrxb016421

On Tue, 2013-06-04 at 07:58 +0100, Matt Fleming wrote:

> Is there any point in calling efi_ioremap() for non-runtime regions in
> this case? In other words, why not the following patch?

Yeah, we need the boottime services regions to be mapped while we make
this call.
-- 
Matthew Garrett | mjg59@srcf.ucam.org
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
