Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758592AbaELVhL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 17:37:11 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:45683 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758420AbaELVhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 17:37:09 -0400
Date: Mon, 12 May 2014 17:37:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Darren Hart <darren@dvhart.com>,
        Davidlohr Bueso <davidlohr@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Clark Williams <williams@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Roland McGrath <roland@hack.frob.com>,
        Carlos ODonell <carlos@redhat.com>, Jakub Jelinek <jakub@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [patch 0/3] futex/rtmutex: Fix issues exposed by trinity
Message-ID: <20140512173705.0bbdb675@gandalf.local.home>
In-Reply-To: <20140512190438.314125476@linutronix.de>
References: <20140512190438.314125476@linutronix.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 May 2014 20:45:32 -0000
Thomas Gleixner <tglx@linutronix.de> wrote:

 
>    Steven, I told you more than once, that your damned performance and
>    feature mania is completely unacceptable.


Yes you have, and now you are yelling at me for something I did 3 years
ago. But this isn't one of my "performance and feature mania" things
you bitched at me about. This is something *you* asked me to look at!

http://marc.info/?l=linux-kernel&m=129242481625261

The "stress test" you recommend back then was just to port it to -rt
and test it there. Which I did, and it found various issues where I
helped Lai fix.

> 
>    When the patch was posted, you were reviewing it. When I wanted to
>    test it, it did not apply and you told me you'll fix it and pick it
>    up. Sure you made it apply and you sticked it into a git tree and
>    let Ingo pull it.
> 
>    I didn't pay much attention as I was happy with the idea in
>    general. I trusted your review and judgement. My problem.
> 
>    Why on earth did you merge that patch even if the changelog mentions
>    that Documentation was left stale and the tester broken?

Sure, I should have pushed Lai for that at the time. Lessons learned. I
was expecting he would do so after we got to a final version of the
patch but I was also working on other things at the time and forgot to
remind him.

I'm surprised you didn't mention to me to make sure the documentation
and test case got fixed before this went further. In fact, that was
never mentioned. These patches went through 4 revisions over a month,
and I even posted another RFC for them to get into the -rt tree.


> 
>    This is beyond sloppy and outright stupid.

Thomas, listen to yourself. You are calling something that got in
without updating the documentation and test case "beyond sloppy and
outright stupid". Sure, I'll agree it was a little sloppy, and today I'm
more on the ball to get things like this right (as we push much harder
today on documentation coming in along with code changes). But the
change log had:

    need updated after this patch is accepted
    1) Document/*
    2) the testcase scripts/rt-tester/t4-l2-pi-deboost.tst

I agree this should be fixed, but you temper tantrum over this seems a
bit over the top.


> 
>    Get this fixed now!
> 
>    And those fixes are not going to be merged without my Reviewed-by.
> 
>    I'm not going to let your multi-reader patches anywhere near RT,
>    unless this Documentation and tester issue is resolved.
> 
>    After that I'm going through them with a fine comb, as I really lost
>    the last modicom of hope, that you can do something without leaving
>    trainwrecks left and right.


And it boils down to this. In the past, I have screwed up where you
were the one (and usually the only one) that got hit by that mess. But
now you seem to take any little mistake done by me as a sign of
complete incompetence.

I'm sorry you feel this way.

I'll try to fix this up as I get a chance (I still have a day job to
do).

-- Steve


