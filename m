Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060AbaBJHq3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 02:46:29 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:40076 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbaBJHq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 02:46:27 -0500
MIME-Version: 1.0
In-Reply-To: <1392017862.4594.3.camel@AMDC1943>
References: <1391859219-3102-1-git-send-email-lpapp@kde.org>
	<1392017862.4594.3.camel@AMDC1943>
Date: Mon, 10 Feb 2014 07:46:26 +0000
X-Google-Sender-Auth: 66-OLLBfs2viXia4hzjKLJBSu3E
Message-ID: <CAOMwXhNB7Jmx9qjbY=_HH8SdwkTG70pOwDd7xQ5U5Xtw+r3Afg@mail.gmail.com>
Subject: Re: [PATCH v2] mfd: MAX6650/6651 support
From: Laszlo Papp <lpapp@kde.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +     help
>> +       Say yes here to support for Maxim Semiconductor MAX6650/MAX6651. This is
>> +       a fan speed regulator and monitor IC. This driver provies common support
>
> s/provies/provides/

Good catch!

(Note to myself: I should have run my vim spellchecker... )

>> +     max665x->map = regmap_init_i2c(i2c, &max665x_regmap_config);
>
> Use devm_regmap_init_i2c() (or add missing regmap_exit()).

Ah, okay, I was not aware of that, thanks.
