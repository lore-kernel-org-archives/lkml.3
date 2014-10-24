Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbaJXJPi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 05:15:38 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:55821 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaJXJPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 05:15:33 -0400
MIME-Version: 1.0
In-Reply-To: <1414139071-3818-5-git-send-email-lftan@altera.com>
References: <1414139071-3818-1-git-send-email-lftan@altera.com>
	<1414139071-3818-5-git-send-email-lftan@altera.com>
Date: Fri, 24 Oct 2014 11:15:30 +0200
X-Google-Sender-Auth: zvmj_NeFzJbpkWq_Hg5R9yk4PzM
Message-ID: <CAMuHMdVb8k_6zHm0deAWUKcKNfTpt2VL3RkJuv-99SCRwtUQEQ@mail.gmail.com>
Subject: Re: [PATCH v5 04/29] nios2: Exception handling
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Ley Foon Tan <lftan@altera.com>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, LeyFoon Tan <lftan.linux@gmail.com>,
        Chung-Lin Tang <cltang@codesourcery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 10:24 AM, Ley Foon Tan <lftan@altera.com> wrote:
> --- /dev/null
> +++ b/arch/nios2/kernel/entry.S
> @@ -0,0 +1,559 @@
> +/*
> + * linux/arch/nios2/kernel/entry.S
> + *
> + * Copyright (C) 2013-2014  Altera Corporation
> + * Copyright (C) 2009, Wind River Systems Inc
> + *
> + * Implemented by fredrik.markstrom@gmail.com and ivarholmqvist@gmail.com
> + *
> + * Based on:
> + *
> + * linux/arch/nios2/kernel/entry.S

And here you did one s/m68k/nios2/ too much ;-)

As this doesn't seem to come from a single file
"Based on the various m68k entry.S files"?

> + *  Copyright (C) 1999-2002, Greg Ungerer (gerg@snapgear.com)
> + *  Copyright (C) 1998  D. Jeff Dionne <jeff@lineo.ca>,
> + *                      Kenneth Albanowski <kjahds@kjahds.com>,
> + *  Copyright (C) 2000  Lineo Inc. (www.lineo.com)
> + *  Copyright (C) 2004  Microtronix Datacom Ltd.
> + *
> + * This file is subject to the terms and conditions of the GNU General Public
> + * License.  See the file "COPYING" in the main directory of this archive
> + * for more details.
> + *
> + * Linux/m68k support by Hamish Macdonald
> + *
> + * 68060 fixes by Jesper Skov
> + * ColdFire support by Greg Ungerer (gerg@snapgear.com)
> + * 5307 fixes by David W. Miller
> + * linux 2.4 support David McCullough <davidm@snapgear.com>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
