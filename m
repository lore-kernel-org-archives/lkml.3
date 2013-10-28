Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985Ab3J1QTz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 12:19:55 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:33752 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756949Ab3J1QTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 12:19:53 -0400
Message-ID: <526E8EA7.2050801@codeaurora.org>
Date: Mon, 28 Oct 2013 09:19:51 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        daniel.lezcano@linaro.org, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] clocksource: sun4i: change CPU mask to cpu_possible_mask
References: <1382699771-4396-1-git-send-email-maxime.ripard@free-electrons.com> <1382699771-4396-3-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1382699771-4396-3-git-send-email-maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/13 04:16, Maxime Ripard wrote:
> The interrupt for the timer is a shared processor interrupt, so any CPU
> found in the system can handle it. Switch to our cpumask to
> cpu_possible_mask instead of cpumask_of(0).
>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---

Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

