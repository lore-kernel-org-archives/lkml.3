Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab3D2HU2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 03:20:28 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:54063 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784Ab3D2HU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 03:20:26 -0400
MIME-Version: 1.0
In-Reply-To: <1367214005-14302-1-git-send-email-chanho.min@lge.com>
References: <1367214005-14302-1-git-send-email-chanho.min@lge.com>
Date: Mon, 29 Apr 2013 09:20:25 +0200
X-Google-Sender-Auth: wmD9O-lLUgsiMVxVim8xYwjRGFU
Message-ID: <CAMuHMdWk4oi_KCmZv7hLZ7JSwy=meziKPBMQ1HJiJR9W8AdrDg@mail.gmail.com>
Subject: Re: [PATCH] lib: add weak __clzsi2()/__clzdi2() functions
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chanho Min <chanho.min@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Kyungsik Lee <kyungsik.lee@lge.com>,
        Yann Collet <yann.collet.73@gmail.com>,
        Bob Pearson <rpearson@systemfabricworks.com>,
        Richard Weinberger <richard@nod.at>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        sparclinux <sparclinux@vger.kernel.org>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>,
        Linux-Next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 7:40 AM, Chanho Min <chanho.min@lge.com> wrote:
> Some architectures need __clzsi2() or __clzdi2() for __builtin_clz and
> It causes build failure. They can be implemented using the fls() and
> overridden by linking arch-specific versions may not be implemented yet.
>
> Reference: https://lkml.org/lkml/2013/4/18/603
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Chanho Min <chanho.min@lge.com>

Thanks, this fixes the link error on m68k, so

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
