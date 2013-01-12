Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207Ab3ALSNm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 13:13:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14385 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754010Ab3ALSNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 13:13:41 -0500
Date: Sat, 12 Jan 2013 19:12:58 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: u3557@miso.sublimeip.com
Cc: Pedro Alves <palves@redhat.com>, Denys Vlasenko <dvlasenk@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: PTRACE_SYSCALL && vsyscall (Was: arch_check_bp_in_kernelspace:
	fix the range check)
Message-ID: <20130112181258.GA24903@redhat.com>
References: <20121125225533.GA24905@redhat.com> <20121125234834.DAC34592076@miso.sublimeip.com> <20121202193058.GA4264@redhat.com> <841b7a319f9d22402d269eed23d03835.squirrel@mail.sublimeip.com> <20121204175933.GA11537@redhat.com> <50EC527C.5030800@redhat.com> <20130109175203.GA32191@redhat.com> <6dff6dcdbfd7444f0b43d8b8bea6ca7c.squirrel@mail.sublimeip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6dff6dcdbfd7444f0b43d8b8bea6ca7c.squirrel@mail.sublimeip.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10, u3557@miso.sublimeip.com wrote:
>
> Hi Everyone,
>
> > On 01/08, Pedro Alves wrote:
> >>
> >> On 12/04/2012 05:59 PM, Oleg Nesterov wrote:
> >>
> >> > But If we want to allow to trace vsyscall's, hw bp doesn't look very
> >> > nice imo. HBP_NUM = 4 and you need to setup 3 bp's to trace them all.
> >>
> >> Irrespective of the whole syscall tracing issue, allowing HW bkpts in
> >> the vsyscall just seems like a bug fix to me.
> >
> > And I never argued. I sent the patch iirc ;)
>
> Exactly, it is a bug and I am still waiting for it to be fixed in the
> Linux kernel.

I would not say this is a bug but let me repeat, no need to convince me.

Please feel free to re-send the patch(es) I sent to maintainers. Sorry,
I can't push these changes into Linus's tree.

Oleg.

