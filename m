Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965742AbaH1Kle (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 06:41:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45251 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934503AbaH1Klc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 06:41:32 -0400
Date: Thu, 28 Aug 2014 12:38:55 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Suresh Siddha <sbsiddha@gmail.com>,
        Bean Anderson <bean@azulsystems.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] x86, fpu: copy_process's FPU paths cleanups
Message-ID: <20140828103855.GA15276@redhat.com>
References: <20140827185138.GA12487@redhat.com> <acea7803-1ed3-437e-9f4c-df8dd56feef8@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acea7803-1ed3-437e-9f4c-df8dd56feef8@email.android.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27, H. Peter Anvin wrote:
>
> Oleg, this is unacceptable.
>
> Last week was Kernel Summit and that was right on the heels
> of a merge window.  We are backlogged like crazy and being
> rude doesn't help one iota.

Me? Rude??

I really hope that this is the first (and last) email from me which
can be interpreted this way ;)

Trust me this was not intentional, and I am sorry if it looked
like it.

> On August 27, 2014 11:51:38 AM PDT, Oleg Nesterov <oleg@redhat.com> wrote:
> >Hello,
> >
> >Who can review this? And where should I send FPU changes?
> >
> >And it seems that nobody cares about 2 fixes I sent before.
> >Linus, I understand that you won't take them into v3.17, but
> >perhaps you can ack/nack them explicitly? It seems that nobody
> >can do this.
> >
> >Oleg.
> >
> > arch/x86/include/asm/fpu-internal.h |    2 +-
> > arch/x86/kernel/process.c           |   16 +++++++++-------
> > arch/x86/kernel/process_32.c        |    2 --
> > arch/x86/kernel/process_64.c        |    1 -
> > 4 files changed, 10 insertions(+), 11 deletions(-)
> 
> -- 
> Sent from my mobile phone.  Please pardon brevity and lack of formatting.

