Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbaCKIQJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 04:16:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44529 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbaCKIQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 04:16:06 -0400
Date: Tue, 11 Mar 2014 09:15:51 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando_b1@lab.ntt.co.jp>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched/clock: prevent tracing recursion in
 sched_clock_cpu()
Message-ID: <20140311081551.GS9987@twins.programming.kicks-ass.net>
References: <1394083528.4524.3.camel@nexus>
 <20140306055113.2306397d@gandalf.local.home>
 <531D66FE.20703@lab.ntt.co.jp>
 <20140310234706.3faf282b@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140310234706.3faf282b@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 11:47:06PM -0400, Steven Rostedt wrote:
> On Mon, 10 Mar 2014 16:17:18 +0900
> Fernando Luis Vázquez Cao <fernando_b1@lab.ntt.co.jp> wrote:
> 
> 
> > Thank you four your review, Peter, Steven.
> > 
> > By the way, who is going to pick this patch? Do you want
> > me to resend with Steven's Acked-by added?
> 
> I don't think you have to. I believe Peter got it. I know there's a
> bunch of patches he's trying to get pushed forward.

Yeah, I do have it (and the scheduler patch you were after Steve), I
just need to trick Ingo into actually looking at his computer somehow.
He seems busy with real life stuff for a bit.
