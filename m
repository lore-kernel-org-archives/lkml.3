Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987AbaFKTCs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 15:02:48 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:45959 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbaFKTCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 15:02:46 -0400
MIME-Version: 1.0
In-Reply-To: <1401731125-19780-1-git-send-email-emilgoode@gmail.com>
References: <1401731125-19780-1-git-send-email-emilgoode@gmail.com>
Date: Wed, 11 Jun 2014 21:02:44 +0200
X-Google-Sender-Auth: E7PMw-5E27RT_X87Uw8TK87QEuM
Message-ID: <CAMuHMdVwhtkoy4m6LzF_EZ6aZneHzELEufw7DYkebZp7n7c=dg@mail.gmail.com>
Subject: Re: [PATCH] usb: usb5303: make use of uninitialized err variable
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Emil Goode <emilgoode@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@linaro.org>, Olof Johansson <olof@lixom.net>,
        Dongjin Kim <tobetter@gmail.com>, Julius Werner <jwerner@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        USB list <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 2, 2014 at 7:45 PM, Emil Goode <emilgoode@gmail.com> wrote:
> The variable err is not initialized here, this patch uses it
> to store an eventual error value from devm_clk_get().
>
> Signed-off-by: Emil Goode <emilgoode@gmail.com>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
