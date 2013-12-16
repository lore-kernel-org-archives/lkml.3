Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177Ab3LPOKQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 09:10:16 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:45011 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab3LPOKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 09:10:13 -0500
MIME-Version: 1.0
In-Reply-To: <1387140035-12234-1-git-send-email-olaf@aepfle.de>
References: <1387140035-12234-1-git-send-email-olaf@aepfle.de>
Date: Mon, 16 Dec 2013 15:10:11 +0100
X-Google-Sender-Auth: jq4pmLh_vHVN_m-hTtRjOyKJt-s
Message-ID: <CAMuHMdX1fLsmRmJfOB3+CzDomT67G+d-S23YGtvvJad3Kthz-Q@mail.gmail.com>
Subject: Re: [PATCH] fbmem: really support wildcard video=options for all
 fbdev drivers
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Olaf Hering <olaf@aepfle.de>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 15, 2013 at 9:40 PM, Olaf Hering <olaf@aepfle.de> wrote:
> Documentation/fb/modedb.txt states that video=option should be
> considered a global option. But video_setup and fb_get_options are not
> coded that way. Instead its required to boot with video=driver:option to
> set a given option in drvier.  This is cumbersome because it requires to
> know in advance which driver will be active for a given board/kernel.

That's an interesting finding: this definitely was working fine a few years ago.
Unfortunately I have no idea when I used it recently. I'm 100% sure I used it
with ps3fb ca. 5 years ago.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
