Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933400AbaDIOg0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 10:36:26 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:33714 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932826AbaDIOgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 10:36:24 -0400
MIME-Version: 1.0
In-Reply-To: <20140409142447.GD13658@twins.programming.kicks-ass.net>
References: <5341707F.5000406@katamail.com>
	<20140407150337.GO10526@twins.programming.kicks-ass.net>
	<20140407150705.GB13658@twins.programming.kicks-ass.net>
	<5342EB78.3060002@gmx.de>
	<20140407185658.GK11096@twins.programming.kicks-ass.net>
	<20140408122128.GC13658@twins.programming.kicks-ass.net>
	<53450F7E.7040904@canonical.com>
	<20140409094515.GR11096@twins.programming.kicks-ass.net>
	<20140409142447.GD13658@twins.programming.kicks-ass.net>
Date: Wed, 9 Apr 2014 07:36:23 -0700
X-Google-Sender-Auth: 7dgNgWOAWqOM3Va6GnWsuxnBpCQ
Message-ID: <CA+55aFzBw0i2nmOGOKzjS_b_7M1Gha2OFEe9rXOO4c+s-2HTkg@mail.gmail.com>
Subject: Re: [PATCH -stable] x86,preempt: Fix preemption for i386
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stefan Bader <stefan.bader@canonical.com>,
        =?UTF-8?Q?Toralf_F=C3=B6rster?= <toralf.foerster@gmx.de>,
        Michele Ballabio <barra_cuda@katamail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 9, 2014 at 7:24 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> I'm not entirely clear on how acceptable it is to propose a different
> patch for -stable than what we have upstream.

It's not all that common, but it certainly happens.

It's fine, as long as it mentions the commits that fix it upstream.
And as long as it's well tested, of course.

                     Linus
