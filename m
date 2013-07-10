Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab3GJOeb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 10:34:31 -0400
Received: from mail-bl2lp0209.outbound.protection.outlook.com ([207.46.163.209]:48941
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754423Ab3GJOe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 10:34:29 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
CC: Matt Fleming <matt.fleming@intel.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Seth Forshee <seth.forshee@canonical.com>
Subject: Re: [REGRESSION] "UEFI: Don't pass boot services regions to
 SetVirtualAddressMap()" breaks macbook efi boot
Thread-Topic: [REGRESSION] "UEFI: Don't pass boot services regions to
 SetVirtualAddressMap()" breaks macbook efi boot
Thread-Index: AQHOfWFmAn+4E7lsoEaLg7g6V1YplZld+kuA
Date: Wed, 10 Jul 2013 14:34:06 +0000
Message-ID: <1373466845.24233.19.camel@x230.lan>
References: <51DD46AD.2010800@canonical.com>
In-Reply-To: <51DD46AD.2010800@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.84.4]
x-forefront-prvs: 0903DD1D85
x-forefront-antispam-report: SFV:NSPM;SFS:(377424004)(24454002)(189002)(199002)(51704005)(79102001)(53806001)(4396001)(80022001)(31966008)(16406001)(77982001)(74662001)(81542001)(56776001)(47736001)(81342001)(59766001)(54356001)(49866001)(50986001)(46102001)(54316002)(74876001)(69226001)(83072001)(74366001)(65816001)(63696002)(47446002)(56816003)(74706001)(77096001)(76796001)(36756003)(76482001)(76786001)(51856001)(33646001)(47976001)(74502001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR05MB221;H:BY2PR05MB222.namprd05.prod.outlook.com;CLIP:10.255.84.4;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <5DDF843518DDC5429C22E7CFB9DD5E2B@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6AEYZ2E017438

On Wed, 2013-07-10 at 13:34 +0200, Maarten Lankhorst wrote:
> Hey,
> 
> It seems that in the merge window my macbook pro stopped working at some point. I looked for suspicious
> efi related commits, and found that reverting commit 1acba98f810a14b1255e34bc620594f83de37e36 worked,
> letting my macbook pro boot succesfully.
> 
> Is there anything I can do to help diagnose this issue?

Well bother. Yeah, reverting this is the right thing to do for now -
I'll spend some time looking into it more closely later in the week.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
