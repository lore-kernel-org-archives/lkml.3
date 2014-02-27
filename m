Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516AbaB0IeQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 03:34:16 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:44940 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbaB0IeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 03:34:13 -0500
Date: Thu, 27 Feb 2014 08:34:08 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 2/8] mfd: pm8921: Update for genirq changes
Message-ID: <20140227083408.GV9195@lee--X1>
References: <1393441166-32692-1-git-send-email-sboyd@codeaurora.org>
 <1393441166-32692-3-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1393441166-32692-3-git-send-email-sboyd@codeaurora.org>
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
> Acked-by: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  drivers/mfd/Kconfig       | 1 -
>  drivers/mfd/pm8921-core.c | 7 +++++--
>  2 files changed, 5 insertions(+), 3 deletions(-)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
