Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933949Ab3D3WrP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 18:47:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2765 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933879Ab3D3WrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 18:47:12 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=wom5GMh1gUkA:10 a=5eKZcm_OZmQA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=jz4g3xt9QgwA:10 a=ANBB0tUNH_Ky0bj-MfgA:9 a=CjuIK1q_8ugA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Date: Tue, 30 Apr 2013 18:47:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 4/4] sched: Distangle worker accounting from rq->lock
Message-ID: <20130430224710.GB9583@home.goodmis.org>
References: <20110622174659.496793734@linutronix.de>
 <20110622174919.135236139@linutronix.de>
 <20130430133722.GA477@home.goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130430133722.GA477@home.goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 30, 2013 at 09:37:22AM -0400, Steven Rostedt wrote:
> [ Blast from the past! ]
> 
> When merging in 3.4.42 into the 3.4-rt branch I hit a conflict with the
> try_to_wake_up_local() call. It seems that the 3.4-rt patch has this
> patch applied. Although, this is not applied to any of the other -rt patches.
> 

I take that back. It's in 3.0-rt, 3.2-rt and 3.4-rt, but it's not in 3.6-rt
nor in 3.8-rt.

-- Steve

