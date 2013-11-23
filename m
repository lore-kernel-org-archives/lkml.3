Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab3KWSvG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 13:51:06 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:60109 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755624Ab3KWSvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 13:51:02 -0500
MIME-Version: 1.0
In-Reply-To: <5290F68C.4060900@roeck-us.net>
References: <5290F68C.4060900@roeck-us.net>
Date: Sat, 23 Nov 2013 19:51:01 +0100
X-Google-Sender-Auth: ckYPWpmgX9MhCEQhnsfB1uZaxvM
Message-ID: <CAMuHMdW-YO6WyL3F7M+q5PqATPwxD9zKLtA3tCc9-Z2wKo-mPg@mail.gmail.com>
Subject: Re: New build failures in v3.13-rc1
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kirill Tkhai <tkhai@yandex.ru>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 23, 2013 at 7:40 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> drivers/tty/ehv_bytechan.c:363:1: error: type defaults to 'int' in
> declaration of 'console_initcall' [-Werror=implicit-int]
>
> Not really surprising as console_initcall() is not defined for modules.
> I am a bit at loss why this is only seen now, though.

On kissb that's been seens since v3.2-rc1.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
