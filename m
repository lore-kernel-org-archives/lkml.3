Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426AbaEFWt1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 18:49:27 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:30109 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754409AbaEFWtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 18:49:24 -0400
Date: Tue, 6 May 2014 18:49:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [ABOMINATION] x86: Fast interrupt return to userspace
Message-ID: <20140506184922.61ba640b@gandalf.local.home>
In-Reply-To: <CA+55aFx8UQGS_anYJrSkkzeM+vx97-2sAUTTE6ZxDJNUKTkD0Q@mail.gmail.com>
References: <e94ab903e725eaf9d98e56f3043878bde7fc1b58.1399408110.git.luto@amacapital.net>
	<CA+55aFy6NzQOfyne4xLqQQCvuhpi-KSXnJNLjXTRc7+4ChPAnQ@mail.gmail.com>
	<CA+55aFw_Dj7Lx_bE0B3mDxMUNz_K1yc=saziC9dmA_dKSkFWiw@mail.gmail.com>
	<CA+55aFwix8dSDQ1N1Qu2-9rzGxWeeGAv4fSPVQWGo1YNzJoCoA@mail.gmail.com>
	<CALCETrVHj1rd=ma-dW8C9RNyQNj3smRAyevWJSQXmvgshbQb6w@mail.gmail.com>
	<CA+55aFx8UQGS_anYJrSkkzeM+vx97-2sAUTTE6ZxDJNUKTkD0Q@mail.gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2014 14:48:50 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:


> Yeah, it's disgusting. I think it is worth fixing to get better
> numbers (it *would* be very interesting to hear whether this plus the
> kernel 'retq' thing actually makes real device interrupt overhead
> lower), but I'd be very wary of using it in production.

Darn it. I was actually hoping that someone else could have the
reputation of doing "I can't believe they actually did this" code in the
kernel.

-- Steve
