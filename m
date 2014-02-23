Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbaBWXqK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 18:46:10 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:38168 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbaBWXqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 18:46:08 -0500
X-AuditID: cbfee68f-b7f156d00000276c-c6-530a883af0a9
Date: Sun, 23 Feb 2014 23:46:02 +0000 (GMT)
From: Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH v3 2/2] phy: Select PHY_EXYNOS_DP_VIDEO by default for
 ARCH_EXYNOS
To: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        "kishon@ti.com" <kishon@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jingoo Han <jg1.han@samsung.com>
Reply-to: jg1.han@samsung.com
MIME-version: 1.0
X-MTR: 20140223234534613@jg1.han
Msgkey: 20140223234534613@jg1.han
X-EPLocale: en_US.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20140223234534613@jg1.han
X-ParentMTR: 
X-ArchiveUser: EV
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <29724573.104451393199161967.JavaMail.weblogic@epml01>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMJsWRmVeSWpSXmKPExsVy+t8zA12rDq5ggxVbjS0u75rD5sDo8XmT
	XABjVAOjTWJRckZmWapCal5yfkpmXrqtUmiIm66FkkJGfnGJrVK0kYGxnpGpiZ6RibmepUGs
	lZGpkkJeYm6qrVKFLlSvkkJRcgFQbW5lMdCAnFQ9qLhecWpeikNWfinIJXrFibnFpXnpesn5
	uUoKZYk5pUAjlPQTpjJmdCzqZCvYwldx9tNjtgbGBr4uRk4OIQEliUkn9zKC2BICJhLnt9xk
	grDFJC7cW8/WxcgFVLOMUWL+mn3MMEXb76+BSsxnlFh38xw7SIJFQFVi2co9YJPYBNQlJvxu
	ZgGxhQXCJH4/3AJmiwiESExY/QasmVmgmUli0aI7LBBnyErcmzwbbAOvgKDEyZlPgOIcQNsU
	JF4sSoUIK0osWHmIBeIICYk79/ezQti8EjPan0LF5SSmfV0Ddai0xPlZGxhhvln8/TFUnF/i
	2O0dTBDjeSWe3A+GGbN78xc2CFtAYuqZg4wQJaoSJ79ClfBJrFn4FmqToMTpa93MMK33t8wF
	hxsz0JVTuh+yQ9haEl9+7GND9RSI7SSxYc9cpgmMyrOQpGYhaZ+FpB1ZzQJGllWMoqkFyQXF
	SelFxsiRvYkRkgb7dzDePWB9iHE/IzBKJjJLiSbnAxNpXkm8obGZkYWpiamxkbmlGYXCJqYW
	FiZGVBFWEue9/zApSEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAOjrsqlVSyiJyVmnGzqame8
	9P5fQCX3c32d7y5JPZVvSp//WXzvTuWS3y/OT58mpO5Q5n8lXtNA5Pipoq7uYzNPN7RViK/T
	L8w1z/m3+mSua9Zzo8z3/r15R6TKEvcf2Xo5MPnojfT33nFWdc8Cdl1/8fuI5gRuc/tHhrln
	m/cxCNQ0sk4UDFZXYinOSDTUYi4qTgQAHveutfYDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42I5/e/2dF2rDq5ggzf31Swu75rD5sDo8XmT
	XABjVIZNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBQ
	JYWyxJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUrSRgbGekamJnpGxgZ6xZayVoYGBkSlQVUJG
	RseiTraCLXwVZz89ZmtgbODrYuTkEBJQkph0ci8jiC0hYCKx/f4aNghbTOLCvfVANhdQzXxG
	iXU3z7GDJFgEVCWWrdwD1sAmoC4x4XczC4gtLBAm8fvhFjBbRCBEYsLqN2DNzALNTBKLFt1h
	gdgmK3Fv8mxmEJtXQFDi5MwnQHEOoG0KEi8WpUKEFSUWrDzEAnGEhMSd+/tZIWxeiRntT6Hi
	chLTvq5hhrClJc7P2sAIc/Ti74+h4vwSx27vYIIYzyvx5H4wzJjdm79A/SggMfXMQUaIElWJ
	k1+hSvgk1ix8C7VJUOL0tW5mmNb7W+YygdjMQFdO6X7IDmFrSXz5sY8N1VMgtpPEhj1zmSYw
	ys1CkpqFpH0WknZkNQsYWVYxiqYWJBcUJ6VXmOgVJ+YWl+al6yXn525iBCeoZ0t2MDZcsD7E
	KMDBqMTDK1HNFSzEmlhWXJl7iFGCg1lJhLemDCjEm5JYWZValB9fVJqTWnyIMRkYfxOZpUST
	84HJM68k3tDY2MTMxNTcwMLA0pw0YSVx3gW3koKEBNITS1KzU1MLUotgtjBxcEo1MMprdrPv
	Wmir/Uj2+la1DZt2Hl/hu6bDMVSAy6p5+73WSlPFVVWLFrourlq+9s+ieOebOXs42SYI+H7M
	6TLsSF3EtaL4QRpfDOulHcydM3snx7fMYk72LWR8mOAjs6Tx43pzpp2/Wj2d008cidF7KZDQ
	G1p83ab1q+3MLTPt7/z6tk/3/L3jp5VYijMSDbWYi4oTAdnAxlKUAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1NNkHvk010408

On Saturday, February 22, 2014 1:44 AM, Sylwester Nawrocki wrote:
> 
> Instead of requiring user to figure out when PHY_EXYNOS_DP_VIDEO needs
> to be selected select it by default for Exynos SoCs. Also enable it
> when COMPILE_TEST is selected. If required the display port PHY driver
> can be then disabled or compiled in as module.
> 
> Cc: Jingoo Han <jg1.han@samsung.com>

Acked-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
> Changes since v2:
>  - s/default y/default ARCH_EXYNOS
> 
> Changes since first version:
>  - use ARCH_EXYNOS instead of "ARCH_EXYNOS4 || ARCH_EXYNOS5"
>  - add dependency on COMPILE_TEST
> ---
>  drivers/phy/Kconfig |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index d71be95..fe1b1f4 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -57,6 +57,8 @@ config TWL4030_USB
>  config PHY_EXYNOS_DP_VIDEO
>  	tristate "EXYNOS SoC series Display Port PHY driver"
>  	depends on OF
> +	depends on ARCH_EXYNOS || COMPILE_TEST
> +	default ARCH_EXYNOS
>  	select GENERIC_PHY
>  	help
>  	  Support for Display Port PHY found on Samsung EXYNOS SoCs.
> --
> 1.7.9.5ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
