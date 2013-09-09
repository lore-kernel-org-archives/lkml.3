Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab3IISmq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 14:42:46 -0400
Received: from mail-by2lp0239.outbound.protection.outlook.com ([207.46.163.239]:18212
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755372Ab3IISmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 14:42:44 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: David Lang <david@lang.hm>
CC: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 00/12] One more attempt at useful kernel lockdown
Thread-Topic: [PATCH 00/12] One more attempt at useful kernel lockdown
Thread-Index: AQHOrYDL2QYLBLFVskGOdCrAsfX2cpm9uPUAgAAESG6AAAB4AA==
Date: Mon, 9 Sep 2013 18:42:38 +0000
Message-ID: <1378752158.17982.15.camel@x230.lan>
References: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>
	 <19562.1378747124@turing-police.cc.vt.edu>
	 <alpine.DEB.2.02.1309091119330.2479@nftneq.ynat.uz>
	 <1378751318.17982.10.camel@x230.lan>
	 <alpine.DEB.2.02.1309091139490.2479@nftneq.ynat.uz>
In-Reply-To: <alpine.DEB.2.02.1309091139490.2479@nftneq.ynat.uz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:5d52:9ee3:3e84:6668]
x-forefront-prvs: 09645BAC66
x-forefront-antispam-report: SFV:NSPM;SFS:(57704003)(24454002)(51704005)(189002)(199002)(377424004)(74876001)(80976001)(53806001)(56816003)(77096001)(19580405001)(19580395003)(83322001)(76482001)(54356001)(79102001)(77982001)(59766001)(83072001)(56776001)(54316002)(80022001)(63696002)(46102001)(81342001)(81816001)(65816001)(69226001)(74366001)(47446002)(74706001)(31966008)(74662001)(74502001)(47736001)(50986001)(47976001)(49866001)(51856001)(4396001)(76786001)(81686001)(81542001)(76796001)(33646001)(36756003)(3826001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR05MB223;H:BY2PR05MB222.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:5d52:9ee3:3e84:6668;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <675D3E44FBA49246BBE4AA8E17510CA0@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r89Igp1L022161

On Mon, 2013-09-09 at 11:40 -0700, David Lang wrote:
> On Mon, 9 Sep 2013, Matthew Garrett wrote:
> 
> > On Mon, 2013-09-09 at 11:25 -0700, David Lang wrote:
> >
> >> Given that we know that people want signed binaries without blocking kexec, you
> >> should have '1' just enforce module signing and '2' (or higher) implement a full
> >> lockdown including kexec.
> >
> > There's already a kernel option for that.
> 
> So, if there is an existing kernel option for this, why do we need a new one?

There's an existing kernel option for "I want to enforce module
signatures but I don't care about anything else". There isn't for "I
want to prevent userspace from modifying my running kernel".

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
