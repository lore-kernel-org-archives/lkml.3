Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482AbaH2SSJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 14:18:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752813AbaH2SSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 14:18:06 -0400
Date: Fri, 29 Aug 2014 20:15:33 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>, Suresh Siddha <sbsiddha@gmail.com>,
        Bean Anderson <bean@azulsystems.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] x86, fpu: kernel_fpu_begin/end cleanups
Message-ID: <20140829181533.GA30659@redhat.com>
References: <20140827185138.GA12487@redhat.com> <CA+55aFwi-S27_maZXU+baOqPAYfi_NTGcfbnRnk45+B8+i4hVQ@mail.gmail.com> <20140828111628.GB15276@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140828111628.GB15276@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let me first try to avoid another angry email.

Sure, I understand that it is easy to say "I do not understand your code,
do not know how to test, please review".

But what else can I do if I believe it is buggy? IOW, please consider this
as the questions, not the patches. Better yet, as a bug report. Feel free
to ignore if you are busy or you are not interested enough.

But of course, I'll appreciate any comment very much.

On 08/28, Oleg Nesterov wrote:
>
> On 08/27, Linus Torvalds wrote:
> >
> > On Wed, Aug 27, 2014 at 11:51 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> > >
> > > Who can review this? And where should I send FPU changes?
> >
> > FWIW, I have nothing against this series (or, indeed, the last series
> > with the exception of 2/5 that got replaced by just the preemption
> > disable).
>
> OK, thanks. (that last series needs more work, kernel_fpu_begin/end).

And to remind, rightly or not I believe they need changes anyway.

Linus, according to git-log/blame you understand these paths better than
anybody else. I hope you can take a look.

Not for inclusion of course, although I hope that 1-2 and perhaps 3 make
sense anyway.

Oleg.

