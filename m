Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab3GYKLf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 06:11:35 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:59497 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779Ab3GYKLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 06:11:33 -0400
MIME-Version: 1.0
In-Reply-To: <51F0F88D.8060903@cn.fujitsu.com>
References: <51F0F88D.8060903@cn.fujitsu.com>
Date: Thu, 25 Jul 2013 12:11:32 +0200
X-Google-Sender-Auth: AApd2wEjCkaTf2basAWF4VMeyEw
Message-ID: <CAMuHMdXWpdTD4sHat9sm5pvXVeGNNKMF6eEN=bUK4qU0H6i1Aw@mail.gmail.com>
Subject: Re: [PATCH V2] driver/vga16fb.c: remove the unused variable "dev" of
 function vga16fb_destroy()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 12:06 PM, Gu Zheng <guz.fnst@cn.fujitsu.com> wrote:
> Commit e21d2170f36602ae2708 ("video: remove unnecessary
> platform_set_drvdata()") removed the unnecessary platform_set_drvdata(),
> but left the variable "dev" unused, delete it.
>
> v2:
>    Following Geert's suggestion to make change log easier reading.
>
> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> ---

Please send a v3, which has the version info under the above "---",
instead of making it a part of the patch description to be committed.

Thanks again!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
