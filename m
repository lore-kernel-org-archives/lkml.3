Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab3ILPnM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 11:43:12 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:47478 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940Ab3ILPnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 11:43:10 -0400
Date: Thu, 12 Sep 2013 16:43:06 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: sameo@linux.intel.com, yongjun_wei@trendmicro.com.cn,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MFD: ucb1x00-core: fix error return code in
 ucb1x00_probe()
Message-ID: <20130912154306.GQ11227@lee--X1>
References: <CAPgLHd-xMHXoC6Qe1n3rBo+rZ6WK6nwz+zU82yBoA8z=M2o8AA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPgLHd-xMHXoC6Qe1n3rBo+rZ6WK6nwz+zU82yBoA8z=M2o8AA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Sep 2013, Wei Yongjun wrote:

> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Fix to return a negative error code in the irq alloc error handling
> case instead of 0, as done elsewhere in this function.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/mfd/ucb1x00-core.c | 1 +
>  1 file changed, 1 insertion(+)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
