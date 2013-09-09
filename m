Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077Ab3IIQaP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 12:30:15 -0400
Received: from mail-bn1lp0158.outbound.protection.outlook.com ([207.46.163.158]:25995
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792Ab3IIQaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 12:30:13 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 01/12] Add BSD-style securelevel support
Thread-Topic: [PATCH 01/12] Add BSD-style securelevel support
Thread-Index: AQHOrXST0kcK6RTzv06SuZIfeWETyJm9l/EAgAAA1oA=
Date: Mon, 9 Sep 2013 16:30:08 +0000
Message-ID: <1378744207.17982.3.camel@x230.lan>
References: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>
	 <1378741786-18430-2-git-send-email-matthew.garrett@nebula.com>
	 <522DF6DC.1050303@zytor.com>
In-Reply-To: <522DF6DC.1050303@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:5d52:9ee3:3e84:6668]
x-forefront-prvs: 09645BAC66
x-forefront-antispam-report: SFV:NSPM;SFS:(377424004)(24454002)(189002)(199002)(81816001)(81342001)(69226001)(65816001)(80022001)(46102001)(63696002)(51856001)(4396001)(76786001)(76796001)(81686001)(81542001)(47736001)(47976001)(49866001)(50986001)(36756003)(33646001)(74366001)(47446002)(74706001)(31966008)(74502001)(74662001)(74876001)(80976001)(83072001)(77982001)(59766001)(56776001)(54316002)(79102001)(77096001)(56816003)(53806001)(76482001)(54356001)(83322001)(19580405001)(19580395003)(3826001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR05MB222;H:BY2PR05MB222.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:5d52:9ee3:3e84:6668;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <860D3B99ABD6164DAEF4DC702AB14891@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r89GULik021401

On Mon, 2013-09-09 at 09:27 -0700, H. Peter Anvin wrote:

> This will break or have to be redefined once you have signed kexec.

Yeah. I wasn't really sure how to define it based on an implementation
that isn't there yet - saying "kexec_load() of untrusted binaries"
implies that there's some way to do it for trusted binaries.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
