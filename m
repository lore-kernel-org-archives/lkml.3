Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904AbaEFXhy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 19:37:54 -0400
Received: from unicorn.mansr.com ([81.2.72.234]:37134 "EHLO unicorn.mansr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133AbaEFXhx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 19:37:53 -0400
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "the arch\/x86 maintainers" <x86@kernel.org>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [ABOMINATION] x86: Fast interrupt return to userspace
References: <e94ab903e725eaf9d98e56f3043878bde7fc1b58.1399408110.git.luto@amacapital.net>
	<CA+55aFy6NzQOfyne4xLqQQCvuhpi-KSXnJNLjXTRc7+4ChPAnQ@mail.gmail.com>
	<CA+55aFw_Dj7Lx_bE0B3mDxMUNz_K1yc=saziC9dmA_dKSkFWiw@mail.gmail.com>
	<CA+55aFwix8dSDQ1N1Qu2-9rzGxWeeGAv4fSPVQWGo1YNzJoCoA@mail.gmail.com>
	<CALCETrVHj1rd=ma-dW8C9RNyQNj3smRAyevWJSQXmvgshbQb6w@mail.gmail.com>
	<CA+55aFx8UQGS_anYJrSkkzeM+vx97-2sAUTTE6ZxDJNUKTkD0Q@mail.gmail.com>
	<20140506184922.61ba640b@gandalf.local.home>
Date: Wed, 07 May 2014 00:37:51 +0100
In-Reply-To: <20140506184922.61ba640b@gandalf.local.home> (Steven Rostedt's
	message of "Tue, 6 May 2014 18:49:22 -0400")
Message-ID: <yw1xeh06wka8.fsf@unicorn.mansr.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:

> On Tue, 6 May 2014 14:48:50 -0700
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>> Yeah, it's disgusting. I think it is worth fixing to get better
>> numbers (it *would* be very interesting to hear whether this plus the
>> kernel 'retq' thing actually makes real device interrupt overhead
>> lower), but I'd be very wary of using it in production.
>
> Darn it. I was actually hoping that someone else could have the
> reputation of doing "I can't believe they actually did this" code in the
> kernel.

Hey, I tried: http://article.gmane.org/gmane.linux.kernel/1594134

-- 
Måns Rullgård
mans@mansr.com
