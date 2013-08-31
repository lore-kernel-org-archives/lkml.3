Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab3HaVAm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 17:00:42 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:37561 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753916Ab3HaVAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 17:00:41 -0400
Date: Sat, 31 Aug 2013 14:00:27 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org,
        John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.10.9-rt5
Message-ID: <20130831210027.GD3871@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130822182127.GA7606@linutronix.de>
 <20130822182423.GA8685@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130822182423.GA8685@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13083121-7182-0000-0000-000008434A80
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 08:24:23PM +0200, Sebastian Andrzej Siewior wrote:
> * Sebastian Andrzej Siewior | 2013-08-22 20:21:27 [+0200]:
> 
> >Changes since v3.10.9-rt4
> >- swait fixes from Steven. It fixed the issues with CONFIG_RCU_NOCB_CPU
> >  where the system suddenly froze and RCU wasn't doing its job 
> 
> Also a big thanks to Carsten Emde and Paul E. McKenney for finding and
> debugging the problem.

And Clark Williams as well!

							Thanx, Paul

> Sebastian
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

