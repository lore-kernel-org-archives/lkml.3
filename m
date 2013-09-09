Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab3IIQzZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 12:55:25 -0400
Received: from mail-by2lp0238.outbound.protection.outlook.com ([207.46.163.238]:25898
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751409Ab3IIQzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 12:55:23 -0400
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
Thread-Index: AQHOrXST0kcK6RTzv06SuZIfeWETyJm9l/EAgAAEfuGAAAKHTYAAANmA
Date: Mon, 9 Sep 2013 16:55:18 +0000
Message-ID: <1378745717.17982.6.camel@x230.lan>
References: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>
	 <1378741786-18430-2-git-send-email-matthew.garrett@nebula.com>
	 <522DF6DC.1050303@zytor.com> <1378744207.17982.3.camel@x230.lan>
	 <522DFA93.50308@zytor.com> <1378745082.17982.4.camel@x230.lan>
	 <522DFCAC.40607@zytor.com>
In-Reply-To: <522DFCAC.40607@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:5d52:9ee3:3e84:6668]
x-forefront-prvs: 09645BAC66
x-forefront-antispam-report: SFV:NSPM;SFS:(377454003)(479174003)(377424004)(24454002)(51704005)(199002)(189002)(51856001)(59766001)(56776001)(19580405001)(54316002)(83322001)(80022001)(65816001)(81342001)(76796001)(36756003)(49866001)(4396001)(47736001)(81542001)(47976001)(76786001)(50986001)(79102001)(46102001)(74366001)(77982001)(69226001)(33646001)(81686001)(81816001)(19580395003)(63696002)(56816003)(77096001)(83072001)(74876001)(80976001)(54356001)(74502001)(53806001)(47446002)(74662001)(31966008)(76482001)(74706001)(3826001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR05MB221;H:BY2PR05MB222.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:5d52:9ee3:3e84:6668;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <732A9583FBC1474EAC05180D77E76AB9@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r89GtU7x021618

On Mon, 2013-09-09 at 09:51 -0700, H. Peter Anvin wrote:
> On 09/09/2013 09:44 AM, Matthew Garrett wrote:
> > On Mon, 2013-09-09 at 09:42 -0700, H. Peter Anvin wrote:
> > 
> >> Neither of this tend to be true long time... which leads one back to
> >> capabilities.
> > 
> > We can't use capabilities. Doing so breaks existing userspace.
> > 
> 
> Capabilities don't have to mean "POSIX capabilities"... although the
> POSIX capability system in Linux really is a massive fail which it would
> be nice to find some kind of fix for.

Designing a worthwhile capabilities interface certainly seems like a
great thing for someone to spend a few years on, but I'm not going to be
happy if it's the only way to solve this problem.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
