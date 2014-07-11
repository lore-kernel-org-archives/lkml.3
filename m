Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083AbaGKQRe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 12:17:34 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:54699 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbaGKQRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 12:17:33 -0400
MIME-Version: 1.0
In-Reply-To: <20140711161341.GF12054@laptop.lan>
References: <20140711161341.GF12054@laptop.lan>
Date: Fri, 11 Jul 2014 18:17:31 +0200
X-Google-Sender-Auth: sNTBxIh54WZA41i_QilHqiCUm74
Message-ID: <CAMuHMdWj=aJsxZJPM=v-z8+=yTAopPWYe5T-+ovnnuEydFuGvA@mail.gmail.com>
Subject: Re: [PATCH] Remove soon to be dead email address
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 6:13 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> My Red Hat email address will soon cease to be; remove it from the
> tree in order to save the interweb some bounces.

> --- a/include/linux/jump_label.h
> +++ b/include/linux/jump_label.h
> @@ -4,8 +4,8 @@
>  /*
>   * Jump label support
>   *
> - * Copyright (C) 2009-2012 Jason Baron <jbaron@redhat.com>
> - * Copyright (C) 2011-2012 Peter Zijlstra <pzijlstr@redhat.com>
> + * Copyright (C) 2009-2012 Red Hat, Inc., Jason Baron <jbaron@redhat.com>

Change not mentioned in comment (there are a few more of these).

> + * Copyright (C) 2011-2012 Red Hat, Inc., Peter Zijlstra

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
