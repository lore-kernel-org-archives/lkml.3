Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998AbaHWRZ0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 13:25:26 -0400
Received: from fallback3.mail.ru ([94.100.181.189]:41434 "EHLO
	fallback3.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbaHWRZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 13:25:24 -0400
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?R3VlbnRlciBSb2Vjaw==?= <linux@roeck-us.net>
Cc: =?UTF-8?B?RXZnZW55IEJvZ2Vy?= <boger@contactless.ru>,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: =?UTF-8?B?UmU6IFtQQVRDSF0gQWRkIHN1cHBvcnQgZm9yIGFsd2F5cyBlbmFibGVkIHdh?=
 =?UTF-8?B?dGNoZG9nIHRpbWVycw==?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [5.18.98.7]
Date: Sat, 23 Aug 2014 21:25:02 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1408814702.730436497@f133.i.mail.ru>
X-Cloud-Ids: 
Content-Type: text/plain; charset=utf-8
X-Mras: Ok
X-Spam: undefined
In-Reply-To: <53F8CC58.2030406@roeck-us.net>
References: <1408236338-12555-1-git-send-email-boger@contactless.ru>
 <53F8CC58.2030406@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s7NHPWgj019217

Sat, 23 Aug 2014 10:16:08 -0700 Ğ¾Ñ‚ Guenter Roeck <linux@roeck-us.net>:
> On 08/16/2014 05:45 PM, Evgeny Boger wrote:
> > From: Evgeny Boger <boger@contactless.ru>
> >
> > Add option to use with watchdog timers which are always enabled
> > in hardware, i.e. there is no way to enable/disable it via GPIO pin.
> > The driver will start pinging WDT immediately upon loading
> > and will continue to do so even after stopping the watchdog.
> >
> The headline needs a reference to the affected driver.
> 
> Also, please copy the dt mailing list and maintainers.
> 
> > Signed-off-by: Evgeny Boger <boger@contactless.ru>
> > ---
> >   .../devicetree/bindings/watchdog/gpio-wdt.txt      | 14 ++++++-
> >   drivers/watchdog/gpio_wdt.c                        | 45 +++++++++++++++++-----
> >   2 files changed, 48 insertions(+), 11 deletions(-)
> >
> > diff --git a/Documentation/devicetree/bindings/watchdog/gpio-wdt.txt b/Documentation/devicetree/bindings/watchdog/gpio-wdt.txt
> > index 37afec1..1f8ca46 100644
> > --- a/Documentation/devicetree/bindings/watchdog/gpio-wdt.txt
> > +++ b/Documentation/devicetree/bindings/watchdog/gpio-wdt.txt
> > @@ -12,8 +12,11 @@ Required Properties:
> >       the opposite level disables the WDT. Active level is determined
> >       by the GPIO flags.
> >   - hw_margin_ms: Maximum time to reset watchdog circuit (milliseconds).
> > +- always-enabled: Use with wathdog timer which is always enabled
 
Similar to NOWAYOUT?

---

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
