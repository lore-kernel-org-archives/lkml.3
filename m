Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab3LZLSj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 06:18:39 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:41218 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826Ab3LZLSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 06:18:38 -0500
MIME-Version: 1.0
In-Reply-To: <1387895407-28031-1-git-send-email-lgxue@hotmail.com>
References: <1387895407-28031-1-git-send-email-lgxue@hotmail.com>
Date: Thu, 26 Dec 2013 12:18:37 +0100
X-Google-Sender-Auth: kh12CCws8gHDYH7SFi-7vaSr6L4
Message-ID: <CAMuHMdUnOyeJ8opD9wwcS0RGJ-js+p3fXkA0iVJO1Vcri_RcbA@mail.gmail.com>
Subject: Re: [PATCH] Add the LED burst trigger
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: lgxue@hotmail.com
Cc: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Rob Landley <rob@landley.net>, "Milo(Woogyom) Kim" <milo.kim@ti.com>,
        linux-leds@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-doc@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 24, 2013 at 3:30 PM,  <lgxue@hotmail.com> wrote:
> +Three properties are exported. They are freq, times and delay_off.
> +
> +     freq      - the blink frequency, default value is 3 means 3HZ

Please write "3 Hz". In the kernel "HZ" means the number of jiffies per
second, and "3 HZ" thus represents a 3-second period.

> +     times     - burst blink times in one cycle, no default value
> +     delay_off - off time between two burst blinks, default value is 500 ms
> +
> +2. Case studies
> +
> +     Example 1
> +
> +     echo burst > trigger
> +     echo 2 > times
> +
> +     The behaviour is like below:
> +
> +     on(1/6s)off(1/6s)on(1/6s)off(1/6m)
> +     ...off 500ms...
> +     on(1/6s)off(1/6s)on(1/3s)off(1/6m)

on(1/6s)off(1/6s)on(1/6s)off(1/6s)

> +     ...off 500ms

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
