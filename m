Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373Ab3IGNzk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 09:55:40 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:63967 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab3IGNzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 09:55:38 -0400
MIME-Version: 1.0
In-Reply-To: <1378554210-943-1-git-send-email-teg@jklm.no>
References: <CANq1E4Rxo3Az0hwCzzQyKz6z_uyVq-9bgAzNzm9StkWoAbkN_A@mail.gmail.com>
	<1378554210-943-1-git-send-email-teg@jklm.no>
Date: Sat, 7 Sep 2013 15:55:37 +0200
X-Google-Sender-Auth: CzpyxWJlKy5mvs178KtYmrYSzQ0
Message-ID: <CAMuHMdXDAA3PgbgNrccStUZGByDXuSsMG_yJMwwUWXwMvyOfsA@mail.gmail.com>
Subject: Re: [PATCH v2] simplefb: print some info about the registered fb
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Tom Gundersen <teg@jklm.no>
Cc: Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        David Herrmann <dh.herrmann@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 7, 2013 at 1:43 PM, Tom Gundersen <teg@jklm.no> wrote:
> +       dev_info(&pdev->dev, "framebuffer at 0x%lx, 0x%lx bytes, mapped to 0x%p\n",
> +                            info->fix.smem_start, (unsigned long) info->fix.smem_len,

Please drop the cast, and use 0x%x. __u32 is unsigned int everywhere (where it
matters --- we don't do 16-bit ints).

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
