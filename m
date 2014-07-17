Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408AbaGQCOR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 22:14:17 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:35953 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbaGQCOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 22:14:15 -0400
X-Originating-IP: 50.43.32.211
Date: Wed, 16 Jul 2014 19:14:06 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, paulmck@linux.vnet.ibm.com,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] rcu: Remove stale comment in tree.c
Message-ID: <20140717021405.GA1102@thin>
References: <1405463509-2468-1-git-send-email-bobby.prani@gmail.com>
 <1405463509-2468-2-git-send-email-bobby.prani@gmail.com>
 <20140715225313.GB24290@cloud>
 <53C5B1F7.3000409@gmail.com>
 <20140716124729.GR8690@linux.vnet.ibm.com>
 <53C67E2E.7080402@gmail.com>
 <53C71EF3.8010901@cn.fujitsu.com>
 <53C72080.5040501@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C72080.5040501@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 09:01:52PM -0400, Pranith Kumar wrote:
> Sure, please find an updated patch with Josh Triplett's sign-off added:

It appears to have a reviewed-by from someone named "Joe Tripplett"
instead. ;)

> From: Pranith Kumar <bobby.prani@gmail.com>
> Date: Mon, 14 Jul 2014 16:01:05 -0400
> Subject: [PATCH 2/3] rcu: Remove stale comment in tree.c
> 
> 
> This commit removes a stale comment in rcu/tree.c which was left out in
> commit 2036d94a7b61ca5032ce (rcu:  Rework detection of use of RCU by offline CPUs)
> 
> For reference, the following updated comment exists a few lines below this which
> means the same.
> 
> /* Remove the outgoing CPU from the masks in the rcu_node hierarchy. */
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> Reviewed-by: Joe Tripplett <josh@joshtriplett.org>
> ---
>  kernel/rcu/tree.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> index a1abaa8..e67246e 100644
> --- a/kernel/rcu/tree.c
> +++ b/kernel/rcu/tree.c
> @@ -2211,8 +2211,6 @@ static void rcu_cleanup_dead_cpu(int cpu, struct rcu_state *rsp)
>  	/* Adjust any no-longer-needed kthreads. */
>  	rcu_boost_kthread_setaffinity(rnp, -1);
>  
> -	/* Remove the dead CPU from the bitmasks in the rcu_node hierarchy. */
> -
>  	/* Exclude any attempts to start a new grace period. */
>  	mutex_lock(&rsp->onoff_mutex);
>  	raw_spin_lock_irqsave(&rsp->orphan_lock, flags);
> -- 
> 1.9.1
> 
