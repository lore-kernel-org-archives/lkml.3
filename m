Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606AbaELH7L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 03:59:11 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:52708 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbaELH7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 03:59:10 -0400
MIME-Version: 1.0
In-Reply-To: <e519609e20be6c6be87bbf0e2dd716abdfaa698e.1399678795.git.joe@perches.com>
References: <cover.1399678795.git.joe@perches.com>
	<e519609e20be6c6be87bbf0e2dd716abdfaa698e.1399678795.git.joe@perches.com>
Date: Mon, 12 May 2014 09:59:09 +0200
X-Google-Sender-Auth: -oZKvoXdH3l7s8-GeHCcUWKBIjs
Message-ID: <CAMuHMdUVzOtBtDc3atrsmEcrr0_xHR3ujnzWKSZaN_mvKs_jkA@mail.gmail.com>
Subject: Re: [uml-devel] [PATCH 1/4] UserModeLinux: Convert UM_KERN_<LEVEL> to KERN_<LEVEL>
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Joe Perches <joe@perches.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Weinberger <richard@nod.at>, Jeff Dike <jdike@addtoit.com>,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 10, 2014 at 1:43 AM, Joe Perches <joe@perches.com> wrote:
> The defines are the same since commit 9429ec96c2718
> ("um: Preinclude include/linux/kern_levels.h")
> so just convert them to the normal KERN_<LEVEL> uses.
>
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Cfr.
https://lkml.org/lkml/2012/9/29/77
https://lkml.org/lkml/2012/9/29/106

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus
Torvaldshttps://lkml.org/lkml/2012/9/29/106
