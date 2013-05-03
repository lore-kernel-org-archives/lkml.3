Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762058Ab3ECAMN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 20:12:13 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:64389 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760547Ab3ECAMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 20:12:12 -0400
Date: Thu, 2 May 2013 17:12:06 -0700
From: Tejun Heo <tj@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 4/4] sched: Distangle worker accounting from rq->lock
Message-ID: <20130503001206.GA19814@mtj.dyndns.org>
References: <20110622174659.496793734@linutronix.de>
 <20110622174919.135236139@linutronix.de>
 <20130430133722.GA477@home.goodmis.org>
 <20130430224710.GB9583@home.goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130430224710.GB9583@home.goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 30, 2013 at 06:47:10PM -0400, Steven Rostedt wrote:
> On Tue, Apr 30, 2013 at 09:37:22AM -0400, Steven Rostedt wrote:
> > [ Blast from the past! ]
> > 
> > When merging in 3.4.42 into the 3.4-rt branch I hit a conflict with the
> > try_to_wake_up_local() call. It seems that the 3.4-rt patch has this
> > patch applied. Although, this is not applied to any of the other -rt patches.
> > 
> 
> I take that back. It's in 3.0-rt, 3.2-rt and 3.4-rt, but it's not in 3.6-rt
> nor in 3.8-rt.

So, it's all good?  Or is there something I need to look into?

Thanks.

-- 
tejun
