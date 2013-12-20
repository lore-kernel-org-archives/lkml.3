Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030335Ab3LTOFM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 09:05:12 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:43423 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030219Ab3LTOFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 09:05:09 -0500
Date: Fri, 20 Dec 2013 14:04:59 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: sameo@linux.intel.com, micky_ching@realsil.com.cn,
        yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] mfd: rtsx: fix sparse non static symbol warning
Message-ID: <20131220140459.GH3709@lee--X1>
References: <CAPgLHd8bi1rcqSx1YpCVLVmmv8jt97Hh7nvSsqc03YfGh7Jorw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPgLHd8bi1rcqSx1YpCVLVmmv8jt97Hh7nvSsqc03YfGh7Jorw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Dec 2013, Wei Yongjun wrote:

> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Fixes the following sparse warning:
> 
> drivers/mfd/rtl8411.c:473:6: warning:
>  symbol 'rtl8411_init_common_params' was not declared. Should it be static?
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/mfd/rtl8411.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
