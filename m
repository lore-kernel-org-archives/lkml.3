Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783Ab3GQUmj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 16:42:39 -0400
Received: from mail-bl2lp0207.outbound.protection.outlook.com ([207.46.163.207]:4370
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753370Ab3GQUmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 16:42:23 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Joseph Salisbury <joseph.salisbury@canonical.com>
CC: "matt.fleming@intel.com" <matt.fleming@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Brad Figg <brad.figg@canonical.com>
Subject: Re: [RESEND][v3.8] [v3.9] [v3.10] [Regression]  efi: be more
 paranoid about available space when creating variables
Thread-Topic: [RESEND][v3.8] [v3.9] [v3.10] [Regression]  efi: be more
 paranoid about available space when creating variables
Thread-Index: AQHOgy0XsNF1noMDeEabk9KR1N+rTJlpVdKA
Date: Wed, 17 Jul 2013 20:42:02 +0000
Message-ID: <1374093721.2670.0.camel@x230>
References: <51E6FFD2.7010505@canonical.com>
In-Reply-To: <51E6FFD2.7010505@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.84.4]
x-forefront-prvs: 0910AAF391
x-forefront-antispam-report: SFV:NSPM;SFS:(51704005)(24454002)(377424004)(199002)(189002)(53806001)(50986001)(33646001)(74662001)(74502001)(51856001)(33716001)(76482001)(63696002)(74876001)(54356001)(83322001)(81342001)(74366001)(19580395003)(56816003)(76796001)(46102001)(49866001)(81542001)(79102001)(74706001)(65816001)(77982001)(31966008)(47976001)(56776001)(69226001)(47736001)(54316002)(83072001)(16406001)(76786001)(80022001)(77096001)(59766001)(47446002)(4396001)(19580405001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR05MB224;H:BY2PR05MB222.namprd05.prod.outlook.com;CLIP:10.255.84.4;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <0C5B31AD18C0504DB65B54FF0B70B3E8@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6HKgpLJ029871

On Wed, 2013-07-17 at 16:34 -0400, Joseph Salisbury wrote:
> Hi Matthew,
> 
> A bug was opened that reports a regression that prevents a system from
> booting[0].  After a kernel bisect, it was found that reverting the
> following commit resolved this bug:

This should be fixed by f8b8404337de4e2466e2e1139ea68b1f8295974f

-- 
Matthew Garrett | mjg59@srcf.ucam.org
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
