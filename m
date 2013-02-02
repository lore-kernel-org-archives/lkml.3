Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab3BCCz5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 21:55:57 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:43912 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298Ab3BCCzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 21:55:55 -0500
Date: Sat, 2 Feb 2013 14:22:14 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jiang Fang <jiang.xx.fang@gmail.com>
Cc: dipankar@in.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rcu: indent: fix leading space
Message-ID: <20130202222214.GM2632@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1359039617-6472-1-git-send-email-jiang.xx.fang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359039617-6472-1-git-send-email-jiang.xx.fang@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020302-9360-0000-0000-0000100FF019
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 11:00:17PM +0800, Jiang Fang wrote:
> 
> Signed-off-by: Jiang Fang <jiang.xx.fang@gmail.com>

Queued for 3.10, thank you!

							Thanx, Paul

> ---
>  kernel/rcutree.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index e441b77..dbf7d7f 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -3064,7 +3064,7 @@ void __init rcu_init(void)
>  	rcu_init_one(&rcu_bh_state, &rcu_bh_data);
>  	__rcu_init_preempt();
>  	rcu_init_nocb();
> -	 open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
> +	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
> 
>  	/*
>  	 * We don't need protection against CPU-hotplug here because
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

