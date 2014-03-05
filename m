Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934AbaCEBvC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 20:51:02 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:39719 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755102AbaCEBvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 20:51:00 -0500
Date: Wed, 5 Mar 2014 09:50:53 +0800
From: Lee Jones <lee.jones@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Josh Cartwright <joshc@codeaurora.org>
Subject: Re: [PATCH 2/2] mfd: pm8921: Use IRQCHIP_SKIP_SET_WAKE
Message-ID: <20140305015053.GJ10579@lee--X1>
References: <1393958932-3585-1-git-send-email-sboyd@codeaurora.org>
 <1393958932-3585-3-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1393958932-3585-3-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We don't need to implement a dummy irq_set_wake op if we just set
> IRQCHIP_SKIP_SET_WAKE.
> 
> Suggested-by: Josh Cartwright <joshc@codeaurora.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  drivers/mfd/pm8921-core.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
