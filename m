Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab3IIURu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 16:17:50 -0400
Received: from mail-bn1lp0150.outbound.protection.outlook.com ([207.46.163.150]:39101
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755694Ab3IIURr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 16:17:47 -0400
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
Thread-Index: AQHOrYDL2QYLBLFVskGOdCrAsfX2cpm9uPUAgAAESG6AAAOVwIAAEpjdgAAEZKOAAAB0AA==
Date: Mon, 9 Sep 2013 20:17:41 +0000
Message-ID: <1378757860.17982.22.camel@x230.lan>
References: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>
	 <19562.1378747124@turing-police.cc.vt.edu>
	 <alpine.DEB.2.02.1309091119330.2479@nftneq.ynat.uz>
	 <1378751318.17982.10.camel@x230.lan>
	 <alpine.DEB.2.02.1309091139490.2479@nftneq.ynat.uz>
	 <1378752158.17982.15.camel@x230.lan>
	 <alpine.DEB.2.02.1309091150570.2479@nftneq.ynat.uz>
	 <1378753619.17982.16.camel@x230.lan>
	 <alpine.DEB.2.02.1309091247340.2479@nftneq.ynat.uz>
	 <1378757201.17982.20.camel@x230.lan>
	 <alpine.DEB.2.02.1309091311040.2479@nftneq.ynat.uz>
In-Reply-To: <alpine.DEB.2.02.1309091311040.2479@nftneq.ynat.uz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:5d52:9ee3:3e84:6668]
x-forefront-prvs: 09645BAC66
x-forefront-antispam-report: SFV:NSPM;SFS:(24454002)(51704005)(189002)(199002)(377424004)(74876001)(80976001)(53806001)(56816003)(77096001)(19580405001)(19580395003)(83322001)(76482001)(54356001)(79102001)(77982001)(59766001)(83072001)(56776001)(54316002)(80022001)(63696002)(46102001)(81342001)(81816001)(65816001)(69226001)(74366001)(47446002)(74706001)(31966008)(74662001)(74502001)(47736001)(50986001)(47976001)(49866001)(51856001)(4396001)(76786001)(81686001)(81542001)(76796001)(33646001)(36756003)(3826001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR05MB222;H:BY2PR05MB222.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:5d52:9ee3:3e84:6668;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <E1663DDF9E8297439C5E7F6DA3C8A90A@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r89KHuAl022929

On Mon, 2013-09-09 at 13:15 -0700, David Lang wrote:
> On Mon, 9 Sep 2013, Matthew Garrett wrote:
> 
> > On Mon, 2013-09-09 at 12:59 -0700, David Lang wrote:
> >
> >> At least you should be able to unify the implementation, even if you don't unify
> >> the user visible knob
> >
> > Well sure, I could take this integer and merge another integer into it,
> > but now you have the same value being modified by two different
> > user-visible interfaces which aren't guaranteed to have the same
> > semantics.
> 
> It's not that you merge integers, it's that the knob that currently sets the 
> signed module only loading but not anything else would have it's implementation 
> changed so that instead of doing whatever it currently does, it would instead 
> make an internal call to set the "require signed modules" bit, and that one 
> place would implement the lockdown.

Thanks.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
