Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757869Ab3FLSvj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 14:51:39 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:50256 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756131Ab3FLSvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 14:51:37 -0400
Message-ID: <51B8C336.4050700@codeaurora.org>
Date: Wed, 12 Jun 2013 14:51:34 -0400
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, arm@kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHv3 3/3] arm64: Move to generic sched_clock infrastructure
References: <1370476485-468-1-git-send-email-sboyd@codeaurora.org> <1370476485-468-4-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1370476485-468-4-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2013 07:54 PM, Stephen Boyd wrote:
> Use the generic sched_clock infrastructure instead of rolling our
> own. This has the added benefit of fixing suspend/resume as
> outlined in 6a4dae5 (ARM: 7565/1: sched: stop sched_clock()
> during suspend, 2012-10-23) and correcting the timestamps when
> the hardware returns a value instead of 0 upon the first read.

Builds and runs for me on software models.

Tested-by: Christopher Covington <cov@codeaurora.org>

Cheers,
Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.
