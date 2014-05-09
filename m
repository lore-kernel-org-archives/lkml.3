Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbaEIJoS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 05:44:18 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:52562 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbaEIJoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 05:44:16 -0400
MIME-Version: 1.0
In-Reply-To: <20140509091646.GO30445@twins.programming.kicks-ass.net>
References: <20140508135840.956784204@infradead.org>
	<20140508135852.387473090@infradead.org>
	<CAMuHMdUrG6pR0_6VhL8P_=HDmVBQxa9kinRm=AFxddyHQFBNeQ@mail.gmail.com>
	<20140509091646.GO30445@twins.programming.kicks-ass.net>
Date: Fri, 9 May 2014 11:44:15 +0200
X-Google-Sender-Auth: WnB32I1a3_rj3VhdjnEGADsDdjE
Message-ID: <CAMuHMdUs2OyY9jrhjXLwu9Y6u9_6HVo2R5fofp93SaZH40Uf-w@mail.gmail.com>
Subject: Re: [PATCH 11/20] arch,m68k: Fold atomic_ops
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Will Deacon <will.deacon@arm.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 9, 2014 at 11:16 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, May 09, 2014 at 11:08:37AM +0200, Geert Uytterhoeven wrote:
>> These two chunks are identical, so please move them out of the #ifdef.
>
> More lines saved!
>
> ---
> Subject: arch,m68k: Fold atomic_ops
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Sun Mar 23 19:06:34 CET 2014
>
> Many of the atomic op implementations are the same except for one
> instruction; fold the lot into a few CPP macros and reduce LoC.
>
> This also prepares for easy addition of new ops.
>
> Requires asm_op due to eor.
>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
