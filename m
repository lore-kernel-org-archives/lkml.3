Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758AbaIQTvx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 15:51:53 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:33945 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756223AbaIQTvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 15:51:52 -0400
Date: Wed, 17 Sep 2014 12:51:50 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Sudeep Holla <sudeep.holla@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH v2] clocksource: arm_arch_timer: discard unavailable
 timers correctly
Message-ID: <20140917195150.GC10233@codeaurora.org>
References: <1410911445-19067-1-git-send-email-sudeep.holla@arm.com>
 <1410982774-4724-1-git-send-email-sudeep.holla@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410982774-4724-1-git-send-email-sudeep.holla@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17, Sudeep Holla wrote:
> Currently we wait until both cp15 and mem timers are probed if we
> have both timer device nodes present in the device tree without
> checking if the device is actually available. If one of the timer
> device node present is disabled, the system locks up on the boot
> as no timer gets registered.
> 
> This patch adds the check for the availablity of the timer device
> so that we unavailable timers are discarded correctly. It also adds

s/we//

> the missing of_node_put.
> 
> Cc: Stephen Boyd <sboyd@codeaurora.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> ---

Thanks.

Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
