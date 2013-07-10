Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab3GJOjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 10:39:09 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:37164 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474Ab3GJOjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 10:39:07 -0400
Date: Wed, 10 Jul 2013 16:39:02 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mtosatti@redhat.com, mingo@redhat.com, gleb@redhat.com,
        glommer@parallels.com, tglx@linutronix.de, jeremy@goop.org,
        rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: sched: add notifier for cross-cpu migrations
Message-ID: <20130710143902.GA28514@gmail.com>
References: <20130710103440.GO25631@dyad.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130710103440.GO25631@dyad.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> Hi,
> 
> I just stumbled over commit 582b336ec2 and had a massive WTF moment.
> 
> The Changelog -- empty!
> The Implementation -- complete crap!
> 
> fail^2.
> 
> A git grep later I find its x86_64 paravirt only.. for this we add 
> unconditional crap to the scheduler?
> 
> At the _very_ least this should have been wrapped in a static_key and 
> the changelog should have given some clue as to the what and why of this 
> code.

My bad for letting it slip through...

Marcelo, mind implementing the suggestions from Peter?

Thanks,

	Ingo
