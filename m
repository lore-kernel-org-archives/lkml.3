Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206AbaAFJQe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 04:16:34 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:56331 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbaAFJQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 04:16:32 -0500
Date: Mon, 6 Jan 2014 09:16:27 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: sameo@linux.intel.com, peter.ujfalusi@ti.com,
        yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] mfd: twl6040: fix sparse non static symbol warning
Message-ID: <20140106091627.GA23772@lee--X1>
References: <CAPgLHd-UWsAD8_-o603e1MvXbUvMxacUGYjxuduV-D7LYHOQxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPgLHd-UWsAD8_-o603e1MvXbUvMxacUGYjxuduV-D7LYHOQxA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Dec 2013, Wei Yongjun wrote:

> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Fixes the following sparse warning:
> 
> drivers/mfd/twl6040.c:89:20: warning:
>  symbol 'twl6040_patch' was not declared. Should it be static?
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/mfd/twl6040.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
