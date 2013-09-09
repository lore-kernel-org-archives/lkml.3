Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509Ab3IIS2p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 14:28:45 -0400
Received: from mail-bn1lp0151.outbound.protection.outlook.com ([207.46.163.151]:55491
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844Ab3IIS2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 14:28:43 -0400
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
Thread-Index: AQHOrYDL2QYLBLFVskGOdCrAsfX2cpm9uPUAgAAA1gA=
Date: Mon, 9 Sep 2013 18:28:38 +0000
Message-ID: <1378751318.17982.10.camel@x230.lan>
References: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>
	 <19562.1378747124@turing-police.cc.vt.edu>
	 <alpine.DEB.2.02.1309091119330.2479@nftneq.ynat.uz>
In-Reply-To: <alpine.DEB.2.02.1309091119330.2479@nftneq.ynat.uz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:5d52:9ee3:3e84:6668]
x-forefront-prvs: 09645BAC66
x-forefront-antispam-report: SFV:NSPM;SFS:(199002)(189002)(24454002)(377424004)(77096001)(56816003)(63696002)(74876001)(83072001)(76482001)(74706001)(74502001)(53806001)(47446002)(31966008)(74662001)(80976001)(54356001)(80022001)(83322001)(19580405001)(56776001)(54316002)(65816001)(51856001)(59766001)(77982001)(69226001)(74366001)(79102001)(46102001)(81816001)(19580395003)(33646001)(81686001)(49866001)(36756003)(81342001)(76796001)(76786001)(50986001)(47976001)(81542001)(4396001)(47736001)(3826001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR05MB221;H:BY2PR05MB222.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:5d52:9ee3:3e84:6668;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <63EBBBCD32C4F8429673D8F0533598BF@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r89ISnb3022084

On Mon, 2013-09-09 at 11:25 -0700, David Lang wrote:

> Given that we know that people want signed binaries without blocking kexec, you 
> should have '1' just enforce module signing and '2' (or higher) implement a full 
> lockdown including kexec.

There's already a kernel option for that.
-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
