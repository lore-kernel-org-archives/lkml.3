Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282Ab3IDS1s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 14:27:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21594 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300Ab3IDS1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 14:27:46 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=4-ZwMV12aaQA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=tmcskMfHKx0A:10 a=VwQbUJbxAAAA:8 a=zR0Pyx8a9TMKGtOXQ5oA:9 a=CjuIK1q_8ugA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Wed, 4 Sep 2013 14:27:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [for-next][PATCH 00/18] ftrace/rcu: Handle unsafe RCU functions
 and ftrace callbacks
Message-ID: <20130904142741.4d57aff4@gandalf.local.home>
In-Reply-To: <20130904143552.456506259@goodmis.org>
References: <20130904143552.456506259@goodmis.org>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Sep 2013 10:35:52 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> This is the latest patches to be queued for 3.12.
> 
> A little late, but as Dave Jones has been stumbling over this for a
> while, I thought it would be good to get it in now. It's not that
> complex to resolve any issues that may pop up.
> 
> I'll keep it in linux-next for a while to make sure it really is clean.
> 
> Note, the checker will stumble over a few functions in irq and scheduler
> code if enabled. This is because those patches have not received Acks
> from Thomas Gleixner and Peter Zijlstra. When I get those acks, I'll
> add the changes to silent those too.
> 
> Thanks to Paul McKenney for reviewing the patches.
> 
> Enjoy,
> 
> -- Steve
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> for-next
> 
> Head SHA1: 7fb3a66134ed5a40448131cf4195823d22f70aa3
> 

Wu's autobot has found a few stupid mistakes (nothing big, but should
be cleaned up before pushing to Linus). I reverted this change from my
for-next tree, and I'm pushing to another branch. If I don't get more
updates from Wu's checks by tomorrow, I'll push the updated branch to
for-next again.

-- Steve
