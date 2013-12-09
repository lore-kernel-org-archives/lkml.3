Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932496Ab3LIKUS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 05:20:18 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:51720 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760303Ab3LIKUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 05:20:13 -0500
Date: Mon, 9 Dec 2013 10:20:07 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: sbkim73@samsung.com, sameo@linux.intel.com, grant.likely@linaro.org,
        rob.herring@calxeda.com, yongjun_wei@trendmicro.com.cn,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] mfd: sec: fix sparse NULL pointer warning
Message-ID: <20131209102007.GF12675@lee--X1>
References: <CAPgLHd_=CTR36ye=YvRW81kpzb12Q-pNzbd8Ja-46DXbGD2_Uw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPgLHd_=CTR36ye=YvRW81kpzb12Q-pNzbd8Ja-46DXbGD2_Uw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 07 Dec 2013, Wei Yongjun wrote:

> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Fixes the following sparse warning:
> 
> drivers/mfd/sec-core.c:202:16: warning: Using plain integer as NULL pointer
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/mfd/sec-core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
