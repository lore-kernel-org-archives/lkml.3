Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502Ab3IJS0U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 14:26:20 -0400
Received: from mail-bl2lp0208.outbound.protection.outlook.com ([207.46.163.208]:21806
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750977Ab3IJS0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 14:26:18 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: David Lang <david@lang.hm>,
        "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
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
Thread-Index: AQHOrYDL2QYLBLFVskGOdCrAsfX2cpm9uPUAgABSI3WAADlnjYAABsNQgADupTuAABGKgA==
Date: Tue, 10 Sep 2013 18:26:12 +0000
Message-ID: <1378837571.17615.0.camel@x230.lan>
References: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>
	 <19562.1378747124@turing-police.cc.vt.edu>
	 <alpine.DEB.2.02.1309091119330.2479@nftneq.ynat.uz>
	 <1378767723.17982.27.camel@x230.lan>
	 <alpine.DEB.2.02.1309091614010.2479@nftneq.ynat.uz>
	 <1378774394.17982.36.camel@x230.lan>
	 <alpine.DEB.2.02.1309091938420.1820@nftneq.ynat.uz>
	 <1378781715.17982.42.camel@x230.lan>
	 <alpine.DEB.2.02.1309092002060.1820@nftneq.ynat.uz>
	 <1378785208.17982.54.camel@x230.lan>
	 <20130910172318.GB21530@khazad-dum.debian.net>
In-Reply-To: <20130910172318.GB21530@khazad-dum.debian.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:6143:33b7:cfa:e8ea]
x-forefront-prvs: 096507C068
x-forefront-antispam-report: SFV:NSPM;SFS:(24454002)(51704005)(189002)(199002)(377424004)(80976001)(74876001)(56816003)(53806001)(77096001)(76482001)(19580395003)(83322001)(19580405001)(54356001)(83072001)(79102001)(77982001)(59766001)(54316002)(56776001)(80022001)(63696002)(46102001)(81342001)(81816001)(65816001)(69226001)(76796001)(36756003)(81686001)(51856001)(4396001)(76786001)(74502001)(31966008)(74706001)(74366001)(47446002)(74662001)(50986001)(49866001)(47976001)(33646001)(81542001)(47736001)(3826001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR05MB223;H:BY2PR05MB222.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:6143:33b7:cfa:e8ea;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <7805D8FF968FF4488773BD9DF88CD5C0@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r8AIQOsC029750

On Tue, 2013-09-10 at 14:23 -0300, Henrique de Moraes Holschuh wrote:
> On Tue, 10 Sep 2013, Matthew Garrett wrote:
> > That's why modern systems require signed firmware updates.
> 
> Linux doesn't.  Is someone working on adding signature support to the
> runtime firmware loader?

It'd be simple to do so, but so far the model appears to be that devices
that expect signed firmware enforce that themselves.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
