Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714AbaB0L6L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 06:58:11 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48566 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbaB0L6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 06:58:09 -0500
Date: Thu, 27 Feb 2014 12:58:05 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        josh@joshtriplett.org
Subject: Re: [PATCH 18/46] kernel: Mark functions as static in sched/fair.c
Message-ID: <20140227115805.GE9987@twins.programming.kicks-ass.net>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
 <8addb2b0ca590ad5b3492ce1c6cb86b67905acd5.1393493277.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8addb2b0ca590ad5b3492ce1c6cb86b67905acd5.1393493277.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 05:20:19PM +0530, Rashika Kheria wrote:
> @@ -5266,7 +5266,7 @@ static unsigned long default_scale_smt_power(struct sched_domain *sd, int cpu)
>  	return smt_gain;
>  }
>  
> -unsigned long __weak arch_scale_smt_power(struct sched_domain *sd, int cpu)
> +static unsigned long arch_scale_smt_power(struct sched_domain *sd, int cpu)
>  {
>  	return default_scale_smt_power(sd, cpu);
>  }

Fuck no; please think before sending.

I'm going to ignore all patches from you henceforth.
