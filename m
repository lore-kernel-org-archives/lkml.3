Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931Ab3J1QTm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 12:19:42 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:33731 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755395Ab3J1QTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 12:19:41 -0400
Message-ID: <526E8E9C.2010304@codeaurora.org>
Date: Mon, 28 Oct 2013 09:19:40 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        daniel.lezcano@linaro.org, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] clockevent: sun4i: Fill the irq field in the clockevent
 structure
References: <1382699771-4396-1-git-send-email-maxime.ripard@free-electrons.com> <1382699771-4396-2-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1382699771-4396-2-git-send-email-maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/13 04:16, Maxime Ripard wrote:
> The clock event structure irq field was not filled previously to the
> interrupt we're using.
>
> This was resulting in the timer not being used at all when using a
> configuration with SMP enabled on a system with several CPUs, and with
> the cpumask set to the cpu_possible_mask.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---

Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

