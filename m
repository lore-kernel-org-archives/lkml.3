Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751204AbaHaIxd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 04:53:33 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:44708 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaHaIxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 04:53:30 -0400
MIME-Version: 1.0
In-Reply-To: <1409369788-22563-1-git-send-email-bobby.prani@gmail.com>
References: <1409369788-22563-1-git-send-email-bobby.prani@gmail.com>
Date: Sun, 31 Aug 2014 10:53:28 +0200
X-Google-Sender-Auth: DqqGoydFvRsUI-IokB_1H3LTwGw
Message-ID: <CAMuHMdV_naTfQOLwOshWq1Q15kSE39a8GWChsjt3RrWRcd6peg@mail.gmail.com>
Subject: Re: [RFC PATCH] powerpc: Wire up three syscalls
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Anton Blanchard <anton@samba.org>, Fabian Frederick <fabf@skynet.be>,
        Andrew Morton <akpm@linux-foundation.org>,
        "open list:LINUX FOR POWERPC..." <linuxppc-dev@lists.ozlabs.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pranith,

On Sat, Aug 30, 2014 at 5:36 AM, Pranith Kumar <bobby.prani@gmail.com> wrote:
> I see that the three syscalls seccomp, getrandom and memfd_create are not wired
> because of which we get a warning while compilation.
>
> So I wired them up in this patch. What else needs to be done? I tried the
> memfd_test after compiling this kernel, but it is failing. What am I missing for
> this to work? Any advice is really appreciated! :)

Did it fail due to the (silly) "ifeq ($(ARCH),X86)" checks in
tools/testing/selftests/memfd/Makefile?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
