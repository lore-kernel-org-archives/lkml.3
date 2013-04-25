Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004Ab3DYGwX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 02:52:23 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:39362 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab3DYGwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 02:52:22 -0400
Date: Thu, 25 Apr 2013 08:52:18 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, ajax@redhat.com,
        gusld@br.ibm.com, a.p.zijlstra@chello.nl, paulus@samba.org,
        acme@ghostprotocols.net, torvalds@linux-foundation.org
Subject: Re: [GIT PULL events/urgent] Protect access via
 task_subsys_state_check()
Message-ID: <20130425065218.GB7806@gmail.com>
References: <20130424172912.GA31818@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130424172912.GA31818@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> Hello, Ingo,
> 
> This pull request is for an RCU-related bug fix in perf_event_comm().
> Without this fix, RCU-lockdep splats and other failures result.
> 
> This fix is available in the git repository at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/urgent
> 
> It has been subjected to -next testing and was posted to LKML at
> https://lkml.org/lkml/2013/4/19/403.
> 
> 							Thanx, Paul
> 
> ----------------------------------------------------------------
> Paul E. McKenney (1):
>       events: Protect access via task_subsys_state_check()
> 
>  kernel/events/core.c | 2 ++
>  1 file changed, 2 insertions(+)

So, I already have this as:

  c79aa0d96548 events: Protect access via task_subsys_state_check()

Given the urgency I applied it out of email and will send it to Linus 
later today.

Thanks,

	Ingo
