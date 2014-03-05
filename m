Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827AbaCEBug (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 20:50:36 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:51690 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299AbaCEBue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 20:50:34 -0500
Date: Wed, 5 Mar 2014 09:50:28 +0800
From: Lee Jones <lee.jones@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Josh Cartwright <joshc@codeaurora.org>
Subject: Re: [PATCH 1/2] mfd: pm8921: Drop irq_set_lockdep_class() code
Message-ID: <20140305015028.GI10579@lee--X1>
References: <1393958932-3585-1-git-send-email-sboyd@codeaurora.org>
 <1393958932-3585-2-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1393958932-3585-2-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This isn't necessary as we aren't setting the summary interrupt
> to wake up the system in the irq_wake() callback.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  drivers/mfd/pm8921-core.c | 3 ---
>  1 file changed, 3 deletions(-)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
