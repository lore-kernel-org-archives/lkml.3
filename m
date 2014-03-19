Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964892AbaCSMAo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 08:00:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58864 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933380AbaCSMAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 08:00:43 -0400
Date: Wed, 19 Mar 2014 12:59:04 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, dietmar.eggemann@arm.com,
        preeti@linux.vnet.ibm.com, tony.luck@intel.com, fenghua.yu@intel.com,
        schwidefsky@de.ibm.com, james.hogan@imgtec.com, cmetcalf@tilera.com,
        benh@kernel.crashing.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH v2 5/7] sched: add a new SD_SHARE_POWERDOMAIN for
 sched_domain
Message-ID: <20140319115904.GJ27632@laptop.programming.kicks-ass.net>
References: <1395165409-18055-1-git-send-email-vincent.guittot@linaro.org>
 <1395165409-18055-6-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395165409-18055-6-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 06:56:47PM +0100, Vincent Guittot wrote:


> @@ -5946,7 +5948,8 @@ static int sched_domains_curr_level;
>  	(SD_SHARE_CPUPOWER |		\
>  	 SD_SHARE_PKG_RESOURCES |	\
>  	 SD_NUMA |			\
> -	 SD_ASYM_PACKING)
> +	 SD_ASYM_PACKING |		\
> +	 SD_SHARE_POWERDOMAIN)

You forgot to update the pretty comment above that :-)
