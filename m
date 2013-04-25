Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223Ab3DYNX6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 09:23:58 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:43699 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757068Ab3DYNX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 09:23:56 -0400
Date: Thu, 25 Apr 2013 06:23:17 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, ajax@redhat.com,
        gusld@br.ibm.com, a.p.zijlstra@chello.nl, paulus@samba.org,
        acme@ghostprotocols.net, torvalds@linux-foundation.org
Subject: Re: [GIT PULL events/urgent] Protect access via
 task_subsys_state_check()
Message-ID: <20130425132317.GH3427@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130424172912.GA31818@linux.vnet.ibm.com>
 <20130425065218.GB7806@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130425065218.GB7806@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042513-7282-0000-0000-0000168B7508
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 08:52:18AM +0200, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > Hello, Ingo,
> > 
> > This pull request is for an RCU-related bug fix in perf_event_comm().
> > Without this fix, RCU-lockdep splats and other failures result.
> > 
> > This fix is available in the git repository at:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/urgent
> > 
> > It has been subjected to -next testing and was posted to LKML at
> > https://lkml.org/lkml/2013/4/19/403.
> > 
> > 							Thanx, Paul
> > 
> > ----------------------------------------------------------------
> > Paul E. McKenney (1):
> >       events: Protect access via task_subsys_state_check()
> > 
> >  kernel/events/core.c | 2 ++
> >  1 file changed, 2 insertions(+)
> 
> So, I already have this as:
> 
>   c79aa0d96548 events: Protect access via task_subsys_state_check()
> 
> Given the urgency I applied it out of email and will send it to Linus 
> later today.

Thank you, and sorry for the noise!

							Thanx, Paul

