Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572Ab3D0Mqx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 08:46:53 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:48076 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605Ab3D0Mqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 08:46:52 -0400
MIME-Version: 1.0
In-Reply-To: <20130427143721.2cfda24e.skraw@ithnet.com>
References: <20130427143721.2cfda24e.skraw@ithnet.com>
Date: Sat, 27 Apr 2013 14:46:51 +0200
X-Google-Sender-Auth: Yopbg4LixB-vAeiM6FGIrt-i8v0
Message-ID: <CAMuHMdXHaOviX4NLAup4-6tQeRtsb6t67o-t=o9LS8EyD9iGUA@mail.gmail.com>
Subject: Re: Question regarding include/linux/linkage.h (3.8.8)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephan von Krawczynski <skraw@ithnet.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 27, 2013 at 2:37 PM, Stephan von Krawczynski
<skraw@ithnet.com> wrote:
> if you look at the above file it contains:
>
> #include <asm/linkage.h>
>
> where should this file come from? There is no "asm" directory inside linux-3.8.8/include/ ... ?

It comes from arch/<arch>/include/asm/..., with <arch> the architecture you're
compiling for.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
