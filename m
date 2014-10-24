Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625AbaJXJKl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 05:10:41 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:47911 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbaJXJKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 05:10:38 -0400
MIME-Version: 1.0
In-Reply-To: <1414139071-3818-30-git-send-email-lftan@altera.com>
References: <1414139071-3818-1-git-send-email-lftan@altera.com>
	<1414139071-3818-30-git-send-email-lftan@altera.com>
Date: Fri, 24 Oct 2014 11:10:36 +0200
X-Google-Sender-Auth: vCw_lgvUB2oJe1F9KLB63WlhzSI
Message-ID: <CAMuHMdXTg3s_ZKL5M+=LwiNBa4gL8Z=eOchocD3qjvp-d=gW_Q@mail.gmail.com>
Subject: Re: [PATCH v5 29/29] nios2: Build infrastructure
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
> +++ b/arch/nios2/boot/install.sh
> @@ -0,0 +1,52 @@
> +#!/bin/sh
> +#
> +# This file is subject to the terms and conditions of the GNU General Public
> +# License.  See the file "COPYING" in the main directory of this archive
> +# for more details.
> +#
> +# Copyright (C) 1995 by Linus Torvalds
> +#
> +# Adapted from code in arch/i386/boot/Makefile by H. Peter Anvin
> +#
> +# "make install" script for m68k architecture

You probably want to s/m68k/nios2/ here.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
