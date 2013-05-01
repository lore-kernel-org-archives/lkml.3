Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759586Ab3EAKd3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 06:33:29 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:63149 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757427Ab3EAKdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 06:33:23 -0400
Date: Wed, 1 May 2013 12:33:19 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Your action on perf bug report is requested was Re: Basic perf
 PMU support for Haswell v11
Message-ID: <20130501103319.GB17360@gmail.com>
References: <1366484783-15613-1-git-send-email-andi@firstfloor.org>
 <20130426065503.GA31197@gmail.com>
 <20130426225235.GI16732@two.firstfloor.org>
 <20130501101041.GG17814@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130501101041.GG17814@two.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> > I found a similar system (not same stepping, but same model) and tested
> > perf top works fine here. Also on a couple of other systems.
> > 
> > Since I cannot reproduce I would need your help debugging it.
> 
> Ingo, I haven't heard back from you on this. 

FYI, the v3.10 merge window has started 3+ days ago.

The merge window is a very busy time period for Linus and maintainers 
alike, and developers should generally not expect maintainers to deal with 
new experimental patches near to or especially during the merge window!

As a special exception I tried and tested your patches on Friday and 
reported back to you the bug, 2 days before the opening of the merge 
window - but you should not expect out of order treatment of development 
patches during the merge window

I might have time to look at your patches in a few days. No promises - I 
still haven't merged all trees to Linus. I think the 11 review cycles of 
your Haswell patch-set are proof enough of my willingness to deal with 
your patches.

> You reported an unreproducable bug. I gave you several steps to diagnose 
> the problem, so that we can make progress on this.

It's entirely reproducible here on that testbox, and was caused by your 
patches - I partially bisected it to your series. (but not to a specific 
patch in your series - ran out of time.)

> You've had several days time now to to this, but I have not heard from 
> you.

FYI, you are entirely confused about how Linux maintenance works near and 
during the merge window. Many maintainers don't take any patches but only 
take fixes for already applied patches. (In -tip we generally try to 
freeze a week before the merge window, so your patches missed the v3.10 
merge window by a wide margin I'm afraid.)

Furthermore, frankly, the nasty, demanding tone of your mail, expecting 
and demanding a reply to your mail within two work days (!) is ridiculous 
and unacceptable and does not make it more likely for me to make special 
exceptions for your patches.

Thanks,

	Ingo
