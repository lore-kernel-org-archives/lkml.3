Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab3K2L5O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 06:57:14 -0500
Received: from fallback1.mail.ru ([94.100.176.18]:52204 "EHLO
	fallback1.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636Ab3K2L5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 06:57:13 -0500
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?TWFyYyBLbGVpbmUtQnVkZGU=?= <mkl@pengutronix.de>
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?B?RXZnZW5peSBQb2x5YWtvdg==?= <zbr@ioremap.net>,
        =?UTF-8?B?R3JlZyBLcm9haC1IYXJ0bWFu?= <gregkh@linuxfoundation.org>,
        =?UTF-8?B?U2hhd24gR3Vv?= <shawn.guo@linaro.org>,
        =?UTF-8?B?U2FzY2hhIEhhdWVy?= <kernel@pengutronix.de>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCAxLzNdIHcxOiBteGNfdzE6IFJlbW92ZSB1bnVzZWQgZmll?=
 =?UTF-8?B?bGQgImNsa2RpdiIgZnJvbSBwcml2YXRlIHN0cnVjdHVyZQ==?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [217.119.30.118]
Date: Fri, 29 Nov 2013 15:56:57 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1385726217.626946686@f256.i.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Mras: Ok
X-Spam: undefined
In-Reply-To: <52987EB1.4010503@pengutronix.de>
References: <1385725170-31515-1-git-send-email-shc_work@mail.ru>
 <52987EB1.4010503@pengutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rATBvJ0l032616

> On 11/29/2013 12:39 PM, Alexander Shiyan wrote:
> > Private field "clkdiv" is not used outside "probe", so there are
> > no reason to keep it in driver.
> 
> Where's the corresponding clk_disable_unprepare()?

I do not see any relation "clk_disable_unprepare" with this patch.

---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
