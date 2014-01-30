Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbaA3Pb7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 10:31:59 -0500
Received: from merlin.infradead.org ([205.233.59.134]:53091 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950AbaA3Pb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 10:31:56 -0500
Date: Thu, 30 Jan 2014 16:31:50 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: nicolas.pitre@linaro.org, mingo@redhat.com, tglx@linutronix.de,
        rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [RFC PATCH 3/3] idle: store the idle state index in the struct rq
Message-ID: <20140130153150.GD5002@laptop.programming.kicks-ass.net>
References: <1391090962-15032-1-git-send-email-daniel.lezcano@linaro.org>
 <1391090962-15032-4-git-send-email-daniel.lezcano@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391090962-15032-4-git-send-email-daniel.lezcano@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 03:09:22PM +0100, Daniel Lezcano wrote:
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index 90aef084..130debf 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -654,6 +654,9 @@ struct rq {
>  #endif
>  
>  	struct sched_avg avg;
> +#ifdef CONFIG_CPU_IDLE
> +	int idle_index;
> +#endif
>  };

So my 'problem' with this is that I've no ff'ing clue what the
idle_index is and what I can do with it.
