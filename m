Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387Ab3BVNiw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 08:38:52 -0500
Received: from mail-ve0-f169.google.com ([209.85.128.169]:39397 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757099Ab3BVNit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 08:38:49 -0500
Date: Fri, 22 Feb 2013 14:38:37 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Kevin Hilman <khilman@linaro.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 1/2] cpustat: use accessor functions for get/set/add
Message-ID: <20130222133835.GF17948@somewhere.redhat.com>
References: <1361512604-2720-1-git-send-email-khilman@linaro.org>
 <1361512604-2720-2-git-send-email-khilman@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361512604-2720-2-git-send-email-khilman@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good, just a minor neat:

On Thu, Feb 21, 2013 at 09:56:43PM -0800, Kevin Hilman wrote:
> diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
> index 66b7078..df8ad75 100644
> --- a/include/linux/kernel_stat.h
> +++ b/include/linux/kernel_stat.h
> @@ -32,7 +32,7 @@ enum cpu_usage_stat {
>  };
>  
>  struct kernel_cpustat {
> -	u64 cpustat[NR_STATS];
> +	u64 _cpustat[NR_STATS];

Why do you need the underscore?



