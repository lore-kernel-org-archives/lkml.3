Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbaCFJU0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 04:20:26 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:39374 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbaCFJUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 04:20:19 -0500
Date: Thu, 6 Mar 2014 17:20:13 +0800
From: Lee Jones <lee.jones@linaro.org>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: pm8921: fixup probe() error path when irq invalid
Message-ID: <20140306092013.GC16034@lee--X1>
References: <1394048065-14200-1-git-send-email-joshc@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1394048065-14200-1-git-send-email-joshc@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> platform_get_irq() returns a negative error code when an IRQ is invalid
> or unspecified.  Make 'irq' signed to properly handle this.
> 
> Cc: Stephen Boyd <sboyd@codeaurora.org>
> Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> ---
>  drivers/mfd/pm8921-core.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Applied thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
