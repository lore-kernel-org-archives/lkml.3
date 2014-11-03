Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751240AbaKCXKt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 18:10:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40427 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733AbaKCXKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 18:10:46 -0500
Date: Tue, 4 Nov 2014 00:10:45 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Jan Beulich <jbeulich@suse.com>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sebastian Lackner <sebastian@fds-team.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chuck Ebbert <cebbert.lkml@gmail.com>, Anish Bhatt <anish@chelsio.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/asm] sched/x86_64: Don't save flags on context switch
Message-ID: <20141103231045.GA12824@redhat.com>
References: <bf6fb790787eb95b922157838f52712c25dda157.1412187233.git.luto@amacapital.net> <tip-2c7577a7583747c9b71f26dced7f696b739da745@git.kernel.org> <CALCETrWM2wVynp1rrip9AWtNYDzjC4M8JqKR82ew5dpyrTWMgA@mail.gmail.com> <20141103214712.GA8711@redhat.com> <20141103215837.GB8711@redhat.com> <CALCETrUMLaz_McO=f-v6JmPY7pJSU4M4g1+p1un1UiVcNf+4XQ@mail.gmail.com> <20141103225721.GA12117@redhat.com> <CALCETrWoqu=7=-JYgZzcOcPsvYkA0eFTpbpmDUNA5=CLT3ykSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWoqu=7=-JYgZzcOcPsvYkA0eFTpbpmDUNA5=CLT3ykSw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03, Andy Lutomirski wrote:
>
> On Mon, Nov 3, 2014 at 2:57 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > I actually tried to say that irqs should be always disabled (afaics!).
> > IOW "interrupts on" should not be possible, not "interrupts off".
>
> But this is checking whether interrupts were on in the frame we're
> returning to, not whether they're on right now, right?

OOPS ;) Thanks!

Oleg.

