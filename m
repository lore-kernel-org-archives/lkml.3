Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240Ab3AVMb3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 07:31:29 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:42640 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab3AVMb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 07:31:28 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdY1sJPkPJx8zFbYOsvHFUM4S_6_eLWjifBpNyqH7cCrDA@mail.gmail.com>
References: <201301202124.BFJ81722.SFOHtJFOLQFVOM@I-love.SAKURA.ne.jp>
	<CACRpkdY1sJPkPJx8zFbYOsvHFUM4S_6_eLWjifBpNyqH7cCrDA@mail.gmail.com>
Date: Tue, 22 Jan 2013 13:25:17 +0100
X-Google-Sender-Auth: QXgHPAwoiLNnWuZDdoqwjx3QM_w
Message-ID: <CAMuHMdUJq-CWeYqrQMdxeb4WXrHRRZn05npWxRGYnGX=V+7OEQ@mail.gmail.com>
Subject: Re: [3.8-rc4 arm] SCSI_SYM53C8XX_2 module cannot register IRQ
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, rmk+kernel@arm.linux.org.uk,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 9:03 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> 1.  Get hold of the patch fixing the boot regression:
>     git format-patch
> f5565295892eb93c3191aa241405fe8b685542d6^..f5565295892eb93c3191aa241405fe8b685542d6

git format-patch -1 f5565295892eb93c3191aa241405fe8b685542d6

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
