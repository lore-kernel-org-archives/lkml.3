Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757179AbaEFLWL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 07:22:11 -0400
Received: from mail.skyhub.de ([78.46.96.112]:34409 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754671AbaEFLWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 07:22:08 -0400
Date: Tue, 6 May 2014 13:22:04 +0200
From: Borislav Petkov <bp@alien8.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: lkml <linux-kernel@vger.kernel.org>, x86-ml <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.com>,
        Mike Galbraith <mgalbraith@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Slow down stupid pounders
Message-ID: <20140506112204.GB25013@pd.tnic>
References: <20140506102924.GA25013@pd.tnic>
 <20140506070854.757fd3ea@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140506070854.757fd3ea@gandalf.local.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2014 at 07:08:54AM -0400, Steven Rostedt wrote:
> Hey, I'm one of those that jerk off to CPU hotplug stress test scripts!

I know you are, Mike gave me your script. Like you haven't done enough!

:-P

> We were just bitching about this yesterday, but -rt related. As
> anything crap in mainline just becomes exponentially more crap in -rt.
> The CPU hotplug case becomes a mountain of crap that we just dig
> tunnels through to get by.
> 
> A while ago Thomas had a proof of concept patch I believe that was
> suppose to pick up traction but unfortunately never went anywhere, even
> after being told it would.
> 
> The real option is to rewrite cpu hotplug.

I know, and we might get lucky, after all.

I'm proposing this as a temporary thing until we have the real deal in
place. I simply would like to shoo those pounding beaks in the interim.

:-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
