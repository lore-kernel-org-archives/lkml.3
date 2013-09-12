Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823Ab3ILSKk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:10:40 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:64049 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756229Ab3ILSKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 14:10:37 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwgyjqRHxLaWGxxsg_v07FrxbVTeLdHTGp7MfeSRjrKsQ@mail.gmail.com>
References: <20130912133855.GA23780@gmail.com>
	<CA+55aFwgyjqRHxLaWGxxsg_v07FrxbVTeLdHTGp7MfeSRjrKsQ@mail.gmail.com>
Date: Thu, 12 Sep 2013 11:10:37 -0700
X-Google-Sender-Auth: pM0ZI6C4SjA9YijLjRKkTfHQJUE
Message-ID: <CA+55aFyCeXXr=57em8CC_Uzfk5PvOw0RHyA309wuOP-oDL7VxA@mail.gmail.com>
Subject: Re: [GIT PULL] perf fixes
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 11:03 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> When I compiled "perf" at the same time as doing a big kernel compile,
> the kernel compile failed

Oops. That may actually have been me being a bit *too* eager with a
"make allmodconfig" build. I can't reproduce it, and I'm starting to
suspect that I instead had two kernel compiles going, not one kernel
compile and a tools/perf/ compile.

  "Yo Dawg, I heard you like kernel compiles, so I put a kernel
compile in your kernel compile so that you can compile the kernel
while you compile the kernel".

But at least the "make install" problem is repeatable, though.

              Linus
