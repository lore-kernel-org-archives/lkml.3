Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422AbaAMJWu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 04:22:50 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:48704 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbaAMJWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 04:22:46 -0500
MIME-Version: 1.0
In-Reply-To: <CAOMwXhNcmbk92TsNTGVQdfWrbVycVW++-+46+8onDZ5xPCD-Jw@mail.gmail.com>
References: <1387814889-16670-1-git-send-email-lpapp@kde.org>
	<1387814889-16670-4-git-send-email-lpapp@kde.org>
	<CACRpkdbAPYs=48RXr6r5kqkYj2V9GitRMT2BRKkn4_gT77wUEg@mail.gmail.com>
	<CAOMwXhNcmbk92TsNTGVQdfWrbVycVW++-+46+8onDZ5xPCD-Jw@mail.gmail.com>
Date: Mon, 13 Jan 2014 09:22:45 +0000
X-Google-Sender-Auth: -d1TRTelLgvoFrfChpJmPLvbxCw
Message-ID: <CAOMwXhNyntnu7h_VOLWq3rh1EprNCnm8yByza6Bz-J9XQmA-sA@mail.gmail.com>
Subject: Re: [PATCH 3/3] gpio: MAX6650/6651 support
From: Laszlo Papp <lpapp@kde.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Guenter Roeck <linux@roeck-us.net>, Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> +#define PIN_NUMBER 5
>>
>> As I can see this is really a GPIO+pin control driver it shall be
>> moved to drivers/pinctrl.
>
> Hmm, but then I am not sure why the gpio-max*.c are similar in the
> drivers/gpio area. Could you please elaborate? They are somewhat
> similar to my understanding, but perhaps there is some fundamental
> difference I am not aware of?

I was giving a second thought to this. Would it be acceptable to add
the gpio driver now, and once the need arises, add the pinctrl thin
layer on top of it? My concern is that I would not use anything else
than the gpio functionality of these pins. It would be a needless
additional work (i.e. investment) for my project and employer.

Perhaps, the layer on top of that can be added later without any
drawback if anyone ever finds the need to have more functionality
supported by these pins?

Shall look forward to hearing your opinion.
