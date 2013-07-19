Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760199Ab3GSLZj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 07:25:39 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:64173 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760125Ab3GSLZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 07:25:35 -0400
Date: Fri, 19 Jul 2013 13:25:30 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Rob Landley <rob@landley.net>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, Darren Hart <dvhart@linux.intel.com>
Subject: Re: [ 00/19] 3.10.1-stable review
Message-ID: <20130719112530.GE26716@gmail.com>
References: <20130715155202.GC29526@xanatos>
 <1373915059.3719.4@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373915059.3719.4@driftwood>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rob Landley <rob@landley.net> wrote:

> On 07/15/2013 10:52:48 AM, Sarah Sharp wrote:
> >On Fri, 12 Jul 2013 18:17:08 +0200, Ingo Molnar <mingo@kernel.org>
> >wrote:
> >> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> >Let's discuss this at Kernel Summit where we can at least yell at each
> >other in person.  Yeah, just try yelling at me about this.  I'll roar
> >right back, louder, for all the people who lose their voice when they
> >get yelled at by top maintainers.  I won't be the nice girl anymore.
> 
> Not _all_ of us lose our voice when yelled at by Linus's lieutenants. 
> Some of us just post updates to the same darn patch series for 5 years 
> (yes really; my perl removal series started in 2008 and was applied 
> earlier this year), on the theory it's useful to the people actually 
> applying it to their own trees (at one point, gentoo), and that someday 
> the stars might be right and cthulu will arise from the deep and accept 
> the patch series into his tree. (Or in my case, Andrew Morton.)

I think part of the root cause was that kbuild maintainership changed 
several times over the years and nobody really felt strongly enough about 
the Perl removal series.

Despite best efforts there will always be long-lived Linux forks: the 
-rt/PREEMPT_RT kernel is meanwhile nearly a decade old now... :-/

Thanks,

	Ingo
