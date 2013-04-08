Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935272Ab3DHQqr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 12:46:47 -0400
Received: from f48.mail.ru ([94.100.178.228]:49449 "EHLO f48.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934118Ab3DHQqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 12:46:45 -0400
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?TWFyayBCcm93bg==?= <broonie@opensource.wolfsonmicro.com>
Cc: =?UTF-8?B?U2FzY2hhIEhhdWVy?= <s.hauer@pengutronix.de>,
        =?UTF-8?B?QXJuZCBCZXJnbWFubg==?= <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        =?UTF-8?B?TGlhbSBHaXJkd29vZA==?= <lgirdwood@gmail.com>
Subject: =?UTF-8?B?UmVbMl06IFtQQVRDSF0gcmVndWxhdG9yOiBtYzEzNzgzOiBBZGQgZGV2aWNl?=
 =?UTF-8?B?IHRyZWUgcHJvYmUgc3VwcG9ydA==?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [188.134.40.128]
Date: Mon, 08 Apr 2013 20:46:39 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1365439599.786794300@f48.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Spam: Not detected
X-Mras: Ok
In-Reply-To: <20130407192157.GQ6597@opensource.wolfsonmicro.com>
References: <1365354131-9770-1-git-send-email-shc_work@mail.ru>
 <20130407192157.GQ6597@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r38GkjWe028814

Hello.

> On Sun, Apr 07, 2013 at 09:02:11PM +0400, Alexander Shiyan wrote:
> > Patch adds device tree probe support for mc13783-regulator driver.
> 
> I'd expect to see a document describing the binding for any new binding.
OK.
 
> > +	if (num_parsed != num_regulators) {
> > +		dev_warn(&pdev->dev,
> > +		"parsed %d != regulators %d - check your device tree!\n",
> > +			num_parsed, num_regulators);
> >  
> > -		init_data = &pdata->regulators[i];
> > -		desc = &mc13783_regulators[init_data->id].desc;
> > +		num_regulators = num_parsed;
> > +		priv->num_regulators = num_regulators;
> 
> Why is this something we warn about?  Users should be able to omit
> unused regulators, no point in adding nodes that don't have any real
> information.

Warning is appear on nonexistent regulators names only.
I will rewrite warning procedure in the v2 globally for mc13xx.
Thanks.

---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
