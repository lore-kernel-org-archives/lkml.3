Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677AbaANRRW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 12:17:22 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:48694 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbaANRRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 12:17:19 -0500
MIME-Version: 1.0
In-Reply-To: <CAOMwXhMtc44SpA5yoGBP38muMqPMi3EkxeAKh3V5c_H=3qoXhw@mail.gmail.com>
References: <1387814889-16670-1-git-send-email-lpapp@kde.org>
	<1387814889-16670-4-git-send-email-lpapp@kde.org>
	<CACRpkdbAPYs=48RXr6r5kqkYj2V9GitRMT2BRKkn4_gT77wUEg@mail.gmail.com>
	<CAOMwXhNcmbk92TsNTGVQdfWrbVycVW++-+46+8onDZ5xPCD-Jw@mail.gmail.com>
	<CACRpkdbih0xQWqnuouhuiRCzYmou++76ex5zC1nh=iBQWJ9otA@mail.gmail.com>
	<CAOMwXhMtc44SpA5yoGBP38muMqPMi3EkxeAKh3V5c_H=3qoXhw@mail.gmail.com>
Date: Tue, 14 Jan 2014 17:17:18 +0000
X-Google-Sender-Auth: BTXewU4USb1o5-AnwzqzccgXkn0
Message-ID: <CAOMwXhNBNa4EKe8rVTtQeAwXGGwFaRu9az+4yHARdH1PnPW1yQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] gpio: MAX6650/6651 support
From: Laszlo Papp <lpapp@kde.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Guenter Roeck <linux@roeck-us.net>, Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Even the gpio functionality itself? So, to clarify my question above,
> I thought it would be something like this:
>
> - gpio
>           \
>            ---
>               \
> - alarm ----- pinctrol
>               /
>          ----
> - etc /
>
> So, pinctrl on top of them, and only this high layer would be moved to
> pinctrl. Perhaps, I should check existing drivers and the pinctrl
> before asking this... Will have a look very soon.

I have just had a quick look and I am now worried.... It seems that
the pinctrl system was not as mature in 3.2 that I need to support as
these days... The short term task of mine is to get it working for
that release, and trying to upstream all this is an additional
bonus....

Hence, my question is: would it be acceptable to leave the gpio
functionality clearly separate and keep the pinctrl functionality on
top of it?

Failing that, is it somehow possible to get this functionality nicely
working with both versions? I am trying to do my best, but even I have
the limits. The definite target is 3.2.1 for us as of now. If it
cannot be nicely done without maintaining two relatively different
drivers until our update, I am afraid I would need to skip the
upstream now due to the lack of appropriate position.

I would appreciate any suggestion about it. The pinctrl system was
introduced in 3.1 if I am not mistaken, and 3.2 has lotta less drivers
around, etc... Not quite sure about the core foundation though.
