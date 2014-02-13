Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341AbaBMWPV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 17:15:21 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:33714 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbaBMWPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 17:15:19 -0500
Date: Thu, 13 Feb 2014 17:15:15 -0500
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>, Tommi Rantala <tt.rantala@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, trinity@vger.kernel.org
Subject: Re: lockdep: strange %s#5 lock name
Message-ID: <20140213221515.GL17608@htj.dyndns.org>
References: <CA+ydwtqC7En++T5S7q5qzaDe_tf9dcMx3Y3aH=+Fcss_NU7stA@mail.gmail.com>
 <20140210192846.GF27965@twins.programming.kicks-ass.net>
 <20140210215224.GB25350@mtj.dyndns.org>
 <20140211110036.GT9987@twins.programming.kicks-ass.net>
 <20140211152741.GA24490@htj.dyndns.org>
 <1392266124.4974.35.camel@ThinkPad-T5421.cn.ibm.com>
 <20140213212645.GG17608@htj.dyndns.org>
 <20140213213253.GF27965@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140213213253.GF27965@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 10:32:53PM +0100, Peter Zijlstra wrote:
> On Thu, Feb 13, 2014 at 04:26:45PM -0500, Tejun Heo wrote:
> > > It seems to me that when the second time alloc_workqueue() is called
> > > from the same code path, it would have two locks with the same key, but
> > > not the same &wq->name, which doesn't meet lockdep's assumption.
> > 
> > Dang...  I reverted the previous patch for now.  Peter, does this
> > approach sound good to you?
> 
> Whatever works I suppose; like Li said; a little ugly but not sure we
> can do better.

Cool, Li, can you please spin it on top of v3.14-rc1 w/ SOB and
description.

Thanks.

-- 
tejun
