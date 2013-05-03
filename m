Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762109Ab3ECA5y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 20:57:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4535 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761818Ab3ECA5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 20:57:53 -0400
X-Authority-Analysis: v=2.0 cv=GtrACzJC c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5eKZcm_OZmQA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=jz4g3xt9QgwA:10 a=myHqRekJXIowLchbwCkA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1367542669.7373.10.camel@gandalf.local.home>
Subject: Re: [patch 4/4] sched: Distangle worker accounting from rq->lock
From: Steven Rostedt <rostedt@goodmis.org>
To: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 02 May 2013 20:57:49 -0400
In-Reply-To: <20130503001206.GA19814@mtj.dyndns.org>
References: <20110622174659.496793734@linutronix.de>
	 <20110622174919.135236139@linutronix.de>
	 <20130430133722.GA477@home.goodmis.org>
	 <20130430224710.GB9583@home.goodmis.org>
	 <20130503001206.GA19814@mtj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-02 at 17:12 -0700, Tejun Heo wrote:
> On Tue, Apr 30, 2013 at 06:47:10PM -0400, Steven Rostedt wrote:
> > On Tue, Apr 30, 2013 at 09:37:22AM -0400, Steven Rostedt wrote:
> > > [ Blast from the past! ]
> > > 
> > > When merging in 3.4.42 into the 3.4-rt branch I hit a conflict with the
> > > try_to_wake_up_local() call. It seems that the 3.4-rt patch has this
> > > patch applied. Although, this is not applied to any of the other -rt patches.
> > > 
> > 
> > I take that back. It's in 3.0-rt, 3.2-rt and 3.4-rt, but it's not in 3.6-rt
> > nor in 3.8-rt.
> 
> So, it's all good?  Or is there something I need to look into?

It looks good to me. I don't know why it's not in 3.6-rt or 3.8-rt. Was
there a reason that Thomas took it out? I don't know. Maybe it's not
needed or he thought it went mainline?

-- Steve


