Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394Ab3CYJvF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 05:51:05 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:28857 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971Ab3CYJvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 05:51:03 -0400
X-AuditID: cbfee690-b7f656d0000007e3-26-51501df03ef0
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Doug Anderson'" <dianders@chromium.org>
Cc: "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Stephen Warren'" <swarren@nvidia.com>,
        "'Changhwan Youn'" <chaos.youn@samsung.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>, "'Olof Johansson'" <olof@lixom.net>,
        "'Simon Glass'" <sjg@chromium.org>,
        "'John Stultz'" <john.stultz@linaro.org>,
        "'Thomas Gleixner'" <tglx@linutronix.de>, linux-kernel@vger.kernel.org
References: <1363967587-19154-1-git-send-email-dianders@chromium.org>
In-reply-to: <1363967587-19154-1-git-send-email-dianders@chromium.org>
Subject: RE: [PATCH] ARM: EXYNOS: Add missing semicolons in exynos_mct.c
Date: Mon, 25 Mar 2013 18:50:40 +0900
Message-id: <177201ce293e$35753cf0$a05fb6d0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4nFYzHc5cbeMU/TPm/xNx7B7wcdwB5fXaw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42I5/e+Zge4H2YBAg64P6hZ/Jx1jt2hvULR4
	eUjT4uyyg2wWZ37rWlzeNYfN4tT1z2wW37ZsY7S4Mb2F1WLzpqnMFsdmLGF04Pb4/WsSo8fs
	hossHneu7WHzeHfuHLvHlRNNrB69ze/YPPq2rGL0+LxJLoAjissmJTUnsyy1SN8ugSuje9Vh
	toJb3BW3Fzs2MH7k7GLk5JAQMJHY/283K4QtJnHh3nq2LkYuDiGBZYwSL5/eYYcp2n1iMitE
	YjqjxJmG68wQzl9GiWf737KAVLEJaEgcfv8MrENEQFvi5YOVYEXMAg+YJB4dO8AEkhAScJW4
	8XYRmM0p4CbxtG0WI4gtLOAhcfTwXrA7WARUJVavms8MYvMK2Eq0nL/FCmELSvyYfA9sGbOA
	lsT6nceZIGx5ic1r3gLVcwCdqi7x6K8uxA1GEqt7e9khSkQk9r14xwhyj4TAXA6JbXd+s0Ps
	EpD4NvkQC0SvrMSmA8wQH0tKHFxxg2UCo8QsJJtnIdk8C8nmWUhWLGBkWcUomlqQXFCclF5k
	olecmFtcmpeul5yfu4kREv8TdjDeO2B9iDEZaP1EZinR5Hxg+sgriTc0NjOyMDUxNTYytzQj
	TVhJnFe9xTpQSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA6Pljx3fP/hqnU/YdIP56/NVdhb3
	HnfI/yj3nKnNIHHI/WXXOm7WXEnNCy/tVtuf5PNqbDwZJ+yrPvVRMXNQorpEuHSH0erpKoVl
	GjHB/yWuyD0vnmddcnYHZ0PfvoO7678zPoroqYt7fXD3z5fZxxQf3L+07JXr0+yG/EdSLx/E
	1Sve/pZq76TEUpyRaKjFXFScCACHtrqUFQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPKsWRmVeSWpSXmKPExsVy+t9jQd0PsgGBBh0blSz+TjrGbtHeoGjx
	8pCmxdllB9kszvzWtbi8aw6bxanrn9ksvm3ZxmhxY3oLq8XmTVOZLY7NWMLowO3x+9ckRo/Z
	DRdZPO5c28Pm8e7cOXaPKyeaWD16m9+xefRtWcXo8XmTXABHVAOjTUZqYkpqkUJqXnJ+SmZe
	uq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QnUoKZYk5pUChgMTiYiV9O0wTQkPc
	dC1gGiN0fUOC4HqMDNBAwjrGjO5Vh9kKbnFX3F7s2MD4kbOLkZNDQsBEYveJyawQtpjEhXvr
	2boYuTiEBKYzSpxpuM4M4fxllHi2/y0LSBWbgIbE4ffP2EFsEQFtiZcPVoIVMQs8YJJ4dOwA
	E0hCSMBV4sbbRWA2p4CbxNO2WYwgtrCAh8TRw3vB1rEIqEqsXjWfGcTmFbCVaDl/ixXCFpT4
	Mfke2DJmAS2J9TuPM0HY8hKb17wFqucAOlVd4tFfXYgbjCRW9/ayQ5SISOx78Y5xAqPQLCST
	ZiGZNAvJpFlIWhYwsqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECE4uz6R2MK5ssDjEKMDB
	qMTDK1DjHyjEmlhWXJl7iFGCg1lJhFdLKCBQiDclsbIqtSg/vqg0J7X4EGMy0KMTmaVEk/OB
	iS+vJN7Q2MTMyNLIzMLIxNycNGElcd4DrdaBQgLpiSWp2ampBalFMFuYODilGhhXOi3Pf/hw
	65+7yazd5f/0E2bu8basL9w1M2x2Y5bX9r+sx34rNS9q/Nm95/TFwN/8pwt2KHe6vfr6xe6Y
	/ssL9ydPOsbDF/4g9rzFbxezsCWPpma+37o4/kU/42tRUZbXEqkfd+V8eKjgvo595camU9Ou
	iy+zd/zzcnXYH9V7N/inKrjecZbarcRSnJFoqMVcVJwIAFHdW7FyAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug Anderson wrote:
> 
> The CLOCKSOURCE_OF_DECLARE lines were added without a semicolon at the
> end.  On my system this causes a compile-time error that looks like:
> 
>  .../drivers/clocksource/exynos_mct.c:557:202: warning: comparison of
> distinct pointer types lacks a cast [enabled by default]
>  .../drivers/clocksource/exynos_mct.c:558:1: error: expected ',' or ';'
> before 'static'
> 
> The error didn't show up till now because there was an extra semicolon

Yeah.

> at end of the CLOCKSOURCE_OF_DECLARE definition that was removed by
> Arnd Bergmann in "clocksource: make CLOCKSOURCE_OF_DECLARE type safe"
> 
OK, thanks.

> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>  drivers/clocksource/exynos_mct.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/clocksource/exynos_mct.c
> b/drivers/clocksource/exynos_mct.c
> index 203ac05..106228d 100644
> --- a/drivers/clocksource/exynos_mct.c
> +++ b/drivers/clocksource/exynos_mct.c
> @@ -554,5 +554,5 @@ void __init mct_init(void)
>  	exynos4_clocksource_init();
>  	exynos4_clockevent_init();
>  }
> -CLOCKSOURCE_OF_DECLARE(exynos4210, "samsung,exynos4210-mct", mct_init)
> -CLOCKSOURCE_OF_DECLARE(exynos4412, "samsung,exynos4412-mct", mct_init)
> +CLOCKSOURCE_OF_DECLARE(exynos4210, "samsung,exynos4210-mct", mct_init);
> +CLOCKSOURCE_OF_DECLARE(exynos4412, "samsung,exynos4412-mct", mct_init);
> --
> 1.8.1.3

Applied, thanks.

- Kukjin

