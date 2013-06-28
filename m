Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652Ab3F1HxH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 03:53:07 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:41010 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab3F1HxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 03:53:05 -0400
MIME-Version: 1.0
In-Reply-To: <1372363940-13023-1-git-send-email-khilman@linaro.org>
References: <1372363940-13023-1-git-send-email-khilman@linaro.org>
Date: Fri, 28 Jun 2013 09:53:04 +0200
X-Google-Sender-Auth: Qs8f_kOKJ0xJfUtlTC6lRYnfRuE
Message-ID: <CAMuHMdVoqKTwgYLCu2ktcWEOYHy+jGo4YZ7ithAgQ6EN0Nhnqw@mail.gmail.com>
Subject: Re: [PATCH] ARM: zImage: fix path to fonts which moved to lib/fonts
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Kevin Hilman <khilman@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 10:12 PM, Kevin Hilman <khilman@linaro.org> wrote:
> commit 1affee67 (lib: Move fonts from drivers/video/console/ to lib/fonts/)
> moved fonts from drivers/video/console/ to lib/fonts, but the ARM zImage
> build still references the old location.
>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Olof Johansson <olof@lixom.net>
> Signed-off-by: Kevin Hilman <khilman@linaro.org>
> ---
> Found due to build failures on ARM in next-20130627.
>
> Rather than go through the ARM tree, this should probably be included
> with the original series from Geert.

Thanks! Sorry for missing this.

There's a similar one in the unicore32 boot code, and a few stale references
in comments and documentation. I'll fold all of these in the original commit.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
