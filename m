Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbaAZJsx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 04:48:53 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:55239 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaAZJss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 04:48:48 -0500
MIME-Version: 1.0
In-Reply-To: <20131217123352.692059839@infradead.org>
References: <20131217122720.950475833@infradead.org>
	<20131217123352.692059839@infradead.org>
Date: Sun, 26 Jan 2014 10:48:48 +0100
X-Google-Sender-Auth: Ut25HLtQX_WB5vcDg_zdBYqjvXs
Message-ID: <CAMuHMdU574ojqZ2wK4bAM_c8_1GCHRDPpco+iF-rHaF8Kdbaxg@mail.gmail.com>
Subject: Re: [PATCH 01/13] sched: Add 3 new scheduler syscalls to support an
 extended scheduling parameters ABI
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Peter Zijlstra <peterz@infradead.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Claudio Scordino <claudio@evidence.eu.com>,
        Michael Trimarchi <michael@amarulasolutions.com>,
        Fabio Checconi <fchecconi@gmail.com>,
        Tommaso Cucinotta <tommaso.cucinotta@sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, Dhaval Giani <dhaval.giani@gmail.com>,
        hgu1972@gmail.com, Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Dario Faggioli <raistlin@linux.it>, insop.song@gmail.com,
        liming.wang@windriver.com, John Kacur <jkacur@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 1:27 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> From: Dario Faggioli <raistlin@linux.it>
>
> Add the syscalls needed for supporting scheduling algorithms
> with extended scheduling parameters (e.g., SCHED_DEADLINE).

>  - defines and implements the new scheduling related syscalls that
>    manipulate it, i.e., sched_setscheduler2(), sched_setattr()
>    and sched_getattr().

> Syscalls are introduced for x86 (32 and 64 bits) and ARM only, as a
> proof of concept and for developing and testing purposes. Making them
> available on other architectures is straightforward.

Please cc linux-arch on new syscalls.

They're now in mainline, and in the end there are only 2 (sched_setattr() and
sched_getattr()).

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
