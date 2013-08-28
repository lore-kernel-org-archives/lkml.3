Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab3H1XND (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 19:13:03 -0400
Received: from mail-bn1lp0150.outbound.protection.outlook.com ([207.46.163.150]:41874
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998Ab3H1XNC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 19:13:02 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Kees Cook <keescook@chromium.org>
CC: Lenny Szubowicz <lszubowi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Josh Boyer <jwboyer@redhat.com>
Subject: Re: [PATCH 0/10] Add additional security checks when module loading
 is restricted
Thread-Topic: [PATCH 0/10] Add additional security checks when module
 loading is restricted
Thread-Index: Nz5hbGPlr11vDxoZBtCj48/bXxVZzqCFps4AWFn4cQH9PTdHAIAAAaOA
Date: Wed, 28 Aug 2013 23:12:57 +0000
Message-ID: <1377731577.27493.11.camel@x230>
References: <1376933171-9854-1-git-send-email-matthew.garrett@nebula.com>
	 <1241952070.8587861.1377729463830.JavaMail.root@redhat.com>
	 <1377729714.27493.2.camel@x230>
	 <761791749.8594444.1377730692707.JavaMail.root@redhat.com>
	 <CAGXu5jKQtx1OEn8qT8+LgHL+xFgK_pHGrxtdwFfKT1q3FHhaNg@mail.gmail.com>
In-Reply-To: <CAGXu5jKQtx1OEn8qT8+LgHL+xFgK_pHGrxtdwFfKT1q3FHhaNg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:51f:6613:ec7a:9b2f]
x-forefront-prvs: 09525C61DB
x-forefront-antispam-report: SFV:NSPM;SFS:(199002)(189002)(51444003)(377424004)(24454002)(4396001)(81542001)(47736001)(83072001)(49866001)(19580405001)(80022001)(46102001)(19580395003)(69226001)(50986001)(47976001)(51856001)(83322001)(33716001)(65816001)(81342001)(76796001)(76786001)(81686001)(74662001)(79102001)(31966008)(74502001)(47446002)(77982001)(59766001)(33646001)(63696002)(81816001)(74876001)(74366001)(74706001)(80976001)(77096001)(53806001)(54316002)(56776001)(76482001)(54356001)(56816003)(3826001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR05MB221;H:BY2PR05MB222.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:51f:6613:ec7a:9b2f;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <516A42F5872C9848A2BAE370C4DB096C@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r7SND8x0010536

On Wed, 2013-08-28 at 16:07 -0700, Kees Cook wrote:

> Strictly speaking, RAM contents are not available via /dev/*mem, even
> to root. However, you can request a suspend image be written, but to
> not enter hibernation. Then modify the image, and request a resume
> from it.

Is that true? Oh, hm - I guess you could do it with uswsusp. Ugh. Now I
wonder what else you can do with uswsusp. Yeah, ok, I think that case
certainly needs handling.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
