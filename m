Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932497AbaGOWwS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 18:52:18 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:39211 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601AbaGOWwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 18:52:16 -0400
Date: Tue, 15 Jul 2014 15:52:11 -0700
From: josh@joshtriplett.org
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] rcu: tiny.c: Update reference to tree.c
Message-ID: <20140715225211.GA24290@cloud>
References: <1405463509-2468-1-git-send-email-bobby.prani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405463509-2468-1-git-send-email-bobby.prani@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 06:31:47PM -0400, Pranith Kumar wrote:
> This commit updates the references to rcutree.c which is now rcu/tree.c
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  kernel/rcu/tiny.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/rcu/tiny.c b/kernel/rcu/tiny.c
> index d9efcc1..6bd785c 100644
> --- a/kernel/rcu/tiny.c
> +++ b/kernel/rcu/tiny.c
> @@ -51,7 +51,7 @@ static long long rcu_dynticks_nesting = DYNTICK_TASK_EXIT_IDLE;
>  
>  #include "tiny_plugin.h"
>  
> -/* Common code for rcu_idle_enter() and rcu_irq_exit(), see kernel/rcutree.c. */
> +/* Common code for rcu_idle_enter() and rcu_irq_exit(), see kernel/rcu/tree.c. */
>  static void rcu_idle_enter_common(long long newval)
>  {
>  	if (newval) {
> @@ -114,7 +114,7 @@ void rcu_irq_exit(void)
>  }
>  EXPORT_SYMBOL_GPL(rcu_irq_exit);
>  
> -/* Common code for rcu_idle_exit() and rcu_irq_enter(), see kernel/rcutree.c. */
> +/* Common code for rcu_idle_exit() and rcu_irq_enter(), see kernel/rcu/tree.c. */
>  static void rcu_idle_exit_common(long long oldval)
>  {
>  	if (oldval) {
> -- 
> 1.9.1
> 
