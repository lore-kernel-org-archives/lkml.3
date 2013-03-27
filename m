Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345Ab3C0VZB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 17:25:01 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:65468 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980Ab3C0VZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 17:25:00 -0400
MIME-Version: 1.0
In-Reply-To: <CAPgLHd8yrZbidfvavg2nrO77zpx_NvKS7QDk=oDWD4T6Vb5+zQ@mail.gmail.com>
References: <CAPgLHd8yrZbidfvavg2nrO77zpx_NvKS7QDk=oDWD4T6Vb5+zQ@mail.gmail.com>
Date: Wed, 27 Mar 2013 22:24:59 +0100
Message-ID: <CACRpkdZ7Kmy+DXN2Xnt1K1hbZo5FTcHCKuDOmHU9zmJsNj_PQA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: exynos5440: fix invalid use of sizeof in exynos5440_pinctrl_probe()
From: Linus Walleij <linus.walleij@linaro.org>
To: Wei Yongjun <weiyj.lk@gmail.com>,
        Thomas Abraham <thomas.abraham@linaro.org>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com,
        yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 2:59 PM, Wei Yongjun <weiyj.lk@gmail.com> wrote:

> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> sizeof() when applied to a pointer typed expression gives the
> size of the pointer, not that of the pointed data.
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/pinctrl/pinctrl-exynos5440.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied, unless the Exynos maintainer protest..

Yours,
Linus Walleij
