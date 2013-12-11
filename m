Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501Ab3LKJsu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 04:48:50 -0500
Received: from mail-yh0-f53.google.com ([209.85.213.53]:58592 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab3LKJsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 04:48:45 -0500
Date: Wed, 11 Dec 2013 09:48:39 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 6/8] mfd: pm8921: Update for genirq changes
Message-ID: <20131211094839.GH16780@lee--X1>
References: <1386718523-2587-1-git-send-email-sboyd@codeaurora.org>
 <1386718523-2587-7-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1386718523-2587-7-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Since this code has been marked broken for some time a few genirq
> tree wide changes weren't made. set_irq_wake() was renamed to
> irq_set_irq_wake() in commit a0cd9ca2b (genirq: Namespace
> cleanup, 2011-02-10) and commit 10a8c383 (irq: introduce entry
> and exit functions for chained handlers) introduced the chained
> irq functions but this driver wasn't updated to use them. Fix
> these problems and remove the BROKEN marking on this driver.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  drivers/mfd/Kconfig       | 1 -
>  drivers/mfd/pm8921-core.c | 7 +++++--
>  2 files changed, 5 insertions(+), 3 deletions(-)

This driver was marked as BROKEN due to compilation failures only, so
as long as it now compiles cleanly (which I'm sure you've tested) I'm
happy with this patch.

It doesn't apply, without your 5th patch, so for now I'll just Ack
it. Please remember to apply my Ack when you resubmit, as it will act
as a reminder and I won't have to re-review.

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
