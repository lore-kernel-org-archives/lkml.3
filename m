Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199Ab3IIQot (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 12:44:49 -0400
Received: from mail-bl2lp0212.outbound.protection.outlook.com ([207.46.163.212]:21787
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753741Ab3IIQor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 12:44:47 -0400
X-Greylist: delayed 873 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Sep 2013 12:44:46 EDT
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
Thread-Index: AQHOrXST0kcK6RTzv06SuZIfeWETyJm9l/EAgAAEfuGAAABrAA==
Date: Mon, 9 Sep 2013 16:44:42 +0000
Message-ID: <1378745082.17982.4.camel@x230.lan>
References: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>
	 <1378741786-18430-2-git-send-email-matthew.garrett@nebula.com>
	 <522DF6DC.1050303@zytor.com> <1378744207.17982.3.camel@x230.lan>
	 <522DFA93.50308@zytor.com>
In-Reply-To: <522DFA93.50308@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:5d52:9ee3:3e84:6668]
x-forefront-prvs: 09645BAC66
x-forefront-antispam-report: SFV:NSPM;SFS:(377424004)(24454002)(199002)(189002)(51856001)(59766001)(56776001)(19580405001)(54316002)(83322001)(80022001)(65816001)(81342001)(76796001)(36756003)(49866001)(4396001)(47736001)(81542001)(47976001)(76786001)(50986001)(79102001)(46102001)(74366001)(77982001)(69226001)(33646001)(81686001)(81816001)(19580395003)(63696002)(56816003)(77096001)(83072001)(74876001)(558084003)(80976001)(54356001)(74502001)(53806001)(47446002)(74662001)(31966008)(76482001)(74706001)(3826001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR05MB221;H:BY2PR05MB222.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:5d52:9ee3:3e84:6668;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <C86F9D3FBC12644497466A7D1D722418@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r89Gis0o021530

On Mon, 2013-09-09 at 09:42 -0700, H. Peter Anvin wrote:

> Neither of this tend to be true long time... which leads one back to
> capabilities.

We can't use capabilities. Doing so breaks existing userspace.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
