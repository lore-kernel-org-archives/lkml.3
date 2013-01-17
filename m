Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab3AQOfG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 09:35:06 -0500
Received: from mga11.intel.com ([192.55.52.93]:12674 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753867Ab3AQOfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 09:35:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,486,1355126400"; 
   d="scan'208";a="274985056"
Message-ID: <1358433288.20319.7.camel@rzhang1-mobl4>
Subject: Re: [PATCH v6 1/3] tick: export nohz tick idle symbols for module
 use
From: Zhang Rui <rui.zhang@intel.com>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Linux PM <linux-pm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Joe Perches <joe@perches.com>, Rob Landley <rob@landley.net>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Date: Thu, 17 Jan 2013 22:34:48 +0800
In-Reply-To: <1357297965-17839-2-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1357297965-17839-1-git-send-email-jacob.jun.pan@linux.intel.com>
	 <1357297965-17839-2-git-send-email-jacob.jun.pan@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-01-04 at 03:12 -0800, Jacob Pan wrote:
> Allow drivers such as intel_powerclamp to use these apis for
> turning on/off ticks during idle.
> 
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>

applied to thermal -next.

thanks,
rui
> ---
>  kernel/time/tick-sched.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index d58e552..a767757 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -553,6 +553,7 @@ void tick_nohz_idle_enter(void)
>  
>  	local_irq_enable();
>  }
> +EXPORT_SYMBOL_GPL(tick_nohz_idle_enter);
>  
>  /**
>   * tick_nohz_irq_exit - update next tick event from interrupt exit
> @@ -681,6 +682,7 @@ void tick_nohz_idle_exit(void)
>  
>  	local_irq_enable();
>  }
> +EXPORT_SYMBOL_GPL(tick_nohz_idle_exit);
>  
>  static int tick_nohz_reprogram(struct tick_sched *ts, ktime_t now)
>  {


