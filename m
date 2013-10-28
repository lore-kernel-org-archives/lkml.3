Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755784Ab3J1IrN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 04:47:13 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:58988 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755050Ab3J1IrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 04:47:11 -0400
Date: Mon, 28 Oct 2013 09:47:07 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] locking fix
Message-ID: <20131028084707.GA2981@gmail.com>
References: <20131026121902.GA24890@gmail.com>
 <CA+55aFwLwZ2SoqLdD9itnXrFJyS9szC+g4J01pLxHFgKYCvrog@mail.gmail.com>
 <526D62D8.8050001@canonical.com>
 <CA+55aFz3MLHcAFqF=WBwmHGQ+8+uU+Hd7avXt=P9L-ohv08bnw@mail.gmail.com>
 <526D6B6D.2000605@canonical.com>
 <CA+55aFz4Fd-dibRL0+VKxz3PhppasvqCU7E6ToW2AWfnsenP_w@mail.gmail.com>
 <526D6FF9.9020003@canonical.com>
 <CA+55aFyud32TExCVaL-k5dCPqrEBD9AZd-st6ooziwZCy9HZDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyud32TExCVaL-k5dCPqrEBD9AZd-st6ooziwZCy9HZDg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sun, Oct 27, 2013 at 12:56 PM, Maarten Lankhorst
> <maarten.lankhorst@canonical.com> wrote:
> >
> > And this is why ww_ctx == NULL is now passed as an inline 
> > argument. :)
> 
> Well, more than that - the "optimization" has been done at the 
> source code level, so that the behavior is no longer a matter 
> about how well the compiler optimizes it any more.
> 
> I'm not complaining about the fix. I'm complaining about how the 
> fix was claimed to be due to a compiler bug. The "documentation" 
> for the fix (ie the commit message) was actively misleading.

Agreed, there was quite a bit of back and forth and I genuinely got 
confused and thought it's purely about a compiler bug (hence the 
misleading pull request) - will watch out for that pattern better 
next time around.

Thanks,

	Ingo
