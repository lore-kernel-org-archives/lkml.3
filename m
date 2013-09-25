Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113Ab3IYKIN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 06:08:13 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:58154 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754861Ab3IYKIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 06:08:12 -0400
Date: Wed, 25 Sep 2013 11:08:06 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: sameo@linux.intel.com, yongjun_wei@trendmicro.com.cn,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: twl6040: drop devm_free_irq of devm_ allocated irq
Message-ID: <20130925100806.GD5132@lee--X1>
References: <CAPgLHd-xSjXvn51RUP+dY-9_pK=HhHzb_R6rb4mKcLufms_jQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPgLHd-xSjXvn51RUP+dY-9_pK=HhHzb_R6rb4mKcLufms_jQA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Sep 2013, Wei Yongjun wrote:

> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> The devm_request_irq function allocates irq that is released
> when a driver detaches. Thus, there is no reason to explicitly
> call devm_free_irq in probe or remove functions.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/mfd/twl6040.c | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
