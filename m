Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933675Ab3CVJif (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 05:38:35 -0400
Received: from multi.imgtec.com ([194.200.65.239]:41157 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932853Ab3CVJid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 05:38:33 -0400
Message-ID: <514C268F.40401@imgtec.com>
Date: Fri, 22 Mar 2013 09:38:23 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, "Peter Zijlstra" <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [patch 03/34] idle: Implement set/clr functions for need_resched
 poll
References: <20130321214930.752934102@linutronix.de> <20130321215233.518839807@linutronix.de>
In-Reply-To: <20130321215233.518839807@linutronix.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_03_22_09_38_24
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/03/13 21:52, Thomas Gleixner wrote:
> Implement set/clear functions for the idle need_resched poll
> implementation.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  include/linux/sched.h |   23 ++++++++++++++++++++++-
>  1 file changed, 22 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/include/linux/sched.h
> ===================================================================
> --- linux-2.6.orig/include/linux/sched.h
> +++ linux-2.6/include/linux/sched.h
> @@ -2473,7 +2473,7 @@ static inline unsigned long *end_of_stac
>  #endif
>  
>  /*
> - * Idle thread specific functions to determine the need_resched
> + * Idle thread specific functions for the the need_resched
>   * polling state. We have two versions, one based on TS_POLLING in

s/the the/the/?

Cheers
James

