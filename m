Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982AbaKKELy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 23:11:54 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:55014 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbaKKELw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 23:11:52 -0500
Date: Mon, 10 Nov 2014 20:08:36 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Xie XiuQi <xiexiuqi@huawei.com>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        josh@joshtriplett.org, rostedt@goodmis.org,
        mathieu.desnoyers@efficios.com, laijs@cn.fujitsu.com, corbet@lwn.net,
        mingo@kernel.org
Subject: Re: [PATCH] documentation: Update sysfs path for
 rcu_cpu_stall_timeout
Message-ID: <20141111040836.GT4901@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1415678606-28216-1-git-send-email-xiexiuqi@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415678606-28216-1-git-send-email-xiexiuqi@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14111104-0013-0000-0000-00000627BA3D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 12:03:26PM +0800, Xie XiuQi wrote:
> Commit 6bfc09e2327d ("rcu: Provide RCU CPU stall warnings for tiny RCU")
> moved the rcu_cpu_stall_timeout module parameter from rcutree.c to
> rcupdate.c, but failed to update Documentation/RCU/stallwarn.txt. This
> commit therefore repairs this omission.
> 
> commit 96224daa16d6 ("documentation: Update sysfs path for rcu_cpu_stall_suppress")
> updated the path for rcu_cpu_stall_suppress, but failed to update for
> rcu_cpu_stall_timeout.
> 
> Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>

Good catch, thank you!  Queued for 3.20.

							Thanx, Paul

> ---
>  Documentation/RCU/stallwarn.txt |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/RCU/stallwarn.txt b/Documentation/RCU/stallwarn.txt
> index ef5a2fd..da6a801 100644
> --- a/Documentation/RCU/stallwarn.txt
> +++ b/Documentation/RCU/stallwarn.txt
> @@ -15,7 +15,7 @@ CONFIG_RCU_CPU_STALL_TIMEOUT
>  	21 seconds.
> 
>  	This configuration parameter may be changed at runtime via the
> -	/sys/module/rcutree/parameters/rcu_cpu_stall_timeout, however
> +	/sys/module/rcupdate/parameters/rcu_cpu_stall_timeout, however
>  	this parameter is checked only at the beginning of a cycle.
>  	So if you are 10 seconds into a 40-second stall, setting this
>  	sysfs parameter to (say) five will shorten the timeout for the
> -- 
> 1.7.1
> 

