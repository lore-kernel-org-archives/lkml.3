Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160AbaGEN4q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 09:56:46 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:37841 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824AbaGEN4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 09:56:44 -0400
MIME-Version: 1.0
In-Reply-To: <1404564740-22066-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1404564740-22066-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Sat, 5 Jul 2014 15:56:42 +0200
X-Google-Sender-Auth: BUuPvOFjCGd0z2E0A8a2g-e9WJw
Message-ID: <CAMuHMdX6fdwWPQoBpHTGpatd+MZQqYZauUpC0w4rp_u2R0oZqQ@mail.gmail.com>
Subject: Re: [PATCH] video: fbdev: valkyriefb.c: Cleaning up variable that is
 never used
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Rickard Strandqvist <rickard.strandqvist@sonymobile.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Joe Perches <joe@perches.com>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 5, 2014 at 2:52 PM, Rickard Strandqvist
<rickard_strandqvist@spectrumdigital.se> wrote:
> From: Rickard Strandqvist <rickard.strandqvist@sonymobile.com>
>
> Variable ar assigned a value that is never used.
> I have also removed all the code that thereby serves no purpose.
>
> This was found using a static code analysis program called cppcheck
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
