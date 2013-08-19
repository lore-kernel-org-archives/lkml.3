Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751119Ab3HSRPn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 13:15:43 -0400
Received: from mail-bn1lp0155.outbound.protection.outlook.com ([207.46.163.155]:57138
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751080Ab3HSRPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 13:15:41 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Kees Cook <keescook@chromium.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Josh Boyer <jwboyer@redhat.com>
Subject: Re: [PATCH 05/10] asus-wmi: Restrict debugfs interface when module
 loading is restricted
Thread-Topic: [PATCH 05/10] asus-wmi: Restrict debugfs interface when module
 loading is restricted
Thread-Index: AQHOnPa6Tah/7plIa0O2SRc9QXB0Upmctg6AgAAPbIA=
Date: Mon, 19 Aug 2013 17:15:37 +0000
Message-ID: <1376932529.5987.0.camel@x230>
References: <1376928619-3775-1-git-send-email-matthew.garrett@nebula.com>
	 <1376928619-3775-5-git-send-email-matthew.garrett@nebula.com>
	 <CAGXu5jJtvVx76ZZrk+s4KwopT-ocZcMbwWNM1ELxH4crm=QGLw@mail.gmail.com>
In-Reply-To: <CAGXu5jJtvVx76ZZrk+s4KwopT-ocZcMbwWNM1ELxH4crm=QGLw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:6267:20ff:fec3:2318]
x-forefront-prvs: 09435FCA72
x-forefront-antispam-report: SFV:NSPM;SFS:(199002)(189002)(24454002)(377424004)(51856001)(74366001)(59766001)(77982001)(65816001)(558084003)(80022001)(19580405001)(19580395003)(76796001)(83072001)(33646001)(81816001)(81686001)(83322001)(76786001)(33716001)(46102001)(63696002)(47976001)(50986001)(49866001)(47736001)(79102001)(4396001)(81542001)(74876001)(69226001)(53806001)(54316002)(56776001)(80976001)(54356001)(77096001)(74706001)(56816003)(47446002)(74662001)(76482001)(74502001)(81342001)(31966008)(3826001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR05MB222;H:BY2PR05MB222.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:6267:20ff:fec3:2318;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <695EF098D7BCA54F88E1810AE7500603@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r7JHFnJN006394

On Mon, 2013-08-19 at 09:20 -0700, Kees Cook wrote:

> Looks like this and the next chunk weren't changed to the
> secure_modules() API...

Bother. Yeah, looks like my test config had this left out.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
