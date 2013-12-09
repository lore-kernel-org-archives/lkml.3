Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab3LIKTb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 05:19:31 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:45487 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787Ab3LIKT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 05:19:29 -0500
Date: Mon, 9 Dec 2013 10:19:25 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: sameo@linux.intel.com, yongjun_wei@trendmicro.com.cn,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] mfd: sta2x11-mfd: fix return value check in
 sta2x11_mfd_platform_probe()
Message-ID: <20131209101925.GE12675@lee--X1>
References: <CAPgLHd88PwtNx0mjdzGe1K+uFafpxQwZhfDiJNfXPcBCKFA1Bg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPgLHd88PwtNx0mjdzGe1K+uFafpxQwZhfDiJNfXPcBCKFA1Bg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 07 Dec 2013, Wei Yongjun wrote:

> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> In case of error, the function devm_regmap_init_mmio() returns
> ERR_PTR() and never returns NULL. The NULL test in the return
> value check should be replaced with IS_ERR().
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/mfd/sta2x11-mfd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
