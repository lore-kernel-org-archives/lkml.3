Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700Ab3CNI1t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 04:27:49 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:27138 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab3CNI1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 04:27:31 -0400
X-AuditID: cbfee690-b7f656d0000007e3-32-514189f27077
Date: Thu, 14 Mar 2013 08:27:13 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH] PM: devfreq: fix typo "CPU_EXYNOS4.12" twice
To: Paul Bolle <pebolle@tiscali.nl>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20130314082637309@myungjoo.ham
Msgkey: 20130314082637309@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130314082637309@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <28735630.135591363249633019.JavaMail.weblogic@epv6ml07>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+Zru6nTsdAg0/XOSwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGybcP2Aq28VRcaJjL3sDYwdPFyMkhJKAusWjJSTYQW0LARGL3
	3YuMELaYxIV764HiXEA1yxgl1p9eDVe0omsPI0RiPqPEjFttLCAJFgFViYlre9i7GDk42AT0
	JGZ+TgYJCws4SsxvecYGEhYRSJOYec4BJMwMFH50+Q4zxA1KEmv2vQKbwisgKHFy5hMWiFWq
	Em9O/2SHiKtJfDxzlgkiLiExa/oFVgibV2JG+1OoejmJaV/XMEPY0hLnZ22A+2Xx98dQcX6J
	Y7d3MIGcA9L75H4wzJjdm79AfSggMfXMQahWLYk3W19BreWTWLPwLQvMmF2nljPD9N7fMpcJ
	4i1FiSndD9khbC2JLz/2saF7i1fAReLr37VMExiVZyFJzULSPgtJO7KaBYwsqxhFUwuSC4qT
	0otM9IoTc4tL89L1kvNzNzFCksKEHYz3DlgfYkwGRshEZinR5HxgUskriTc0NjOyMDUxNTYy
	tzQjTVhJnFe9xTpQSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA2PATNE9rwMdfx0rt5OWtL8S
	wuU+58+OWzodWpUbTwdbHGY9JzPxq+/U9MMLN7m++1n6W2SNW/B/22tdGmkVN7LkVUwvtuuL
	+Wv727376ef1WL15WgSPdrVo3tUvy+uZpnw2Fih4VX3xYpKryneF+Hknjx4VUJlWfuTqUoOH
	d/Y8+8xxxm/ZjitKLMUZiYZazEXFiQAty3i5IAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgk+LIzCtJLcpLzFFi42I5/e/2DN2HnY6BBjdOqlhc3jWHzYHR4/Mm
	uQDGqAybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWgjA2M9I1MTPSNjAz0Tg1grQwMDI1OgqoSM
	jJNvH7AVbOOpuNAwl72BsYOni5GTQ0hAXWLRkpNsILaEgInEiq49jBC2mMSFe+uB4lxANfMZ
	JWbcamMBSbAIqEpMXNvD3sXIwcEmoCcx83MySFhYwFFifsszNpCwiECaxMxzDiBhZqDwo8t3
	mCFWKUms2fcKbAqvgKDEyZlPWCBWqUq8Of2THSKuJvHxzFkmiLiExKzpF1ghbF6JGe1Poerl
	JKZ9XcMMYUtLnJ+1Ae7kxd8fQ8X5JY7d3sEEcg5I75P7wTBjdm/+AvWtgMTUMwehWrUk3mx9
	BbWWT2LNwrcsMGN2nVrODNN7f8tcJoi3FCWmdD9kh7C1JL782MeG7i1eAReJr3/XMk1glJuF
	JDULSfssJO3IahYwsqxiFE0tSC4oTkqvMNErTswtLs1L10vOz93ECE5Pz5bsYGy4YH2IUYCD
	UYmH90C/Q6AQa2JZcWXuIUYJDmYlEV5PL8dAId6UxMqq1KL8+KLSnNTiQ4zJwOibyCwlmpwP
	TJ15JfGGxgbGhoaW5gamhkYWpAkrifM+a7UOFBJITyxJzU5NLUgtgtnCxMEp1cBYfSP/R52/
	3Nvo5RNXKnX7BSuu7C/VW9Z54c7KoCU/vs2wuX/8eKfrbBuRqkZ3Js5JIRuaLr29dOV0ytxw
	pWfi/Hem39FY+fH9odRTZz73PVFgbdrz5ZXl9516rNIu3KYifqp98s3GGuvWsoZvnrGDp3rW
	jP7TThwR35lO3SyzE9Re9Ghu2h1PJZbijERDLeai4kQArTPNeZMDAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r2E8RpgA028490

> Dependencies on CPU_EXYNOS4212 and CPU_EXYNOS4412 for the "ARM
> Exynos4210/4212/4412 Memory Bus DEVFREQ Driver" were added in commit
> 7b4050381127ae11fcfc74a106d715a5fbbf888a ("PM/Devfreq: Add Exynos4-bus
> device DVFS driver for Exynos4210/4212/4412."). The tree (at that time,
> v3.3, and currently) makes clear that this should have been dependencies
> on SOC_EXYNOS4212 and SOC_EXYNOS4412.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

> ---
>  drivers/devfreq/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/devfreq/Kconfig b/drivers/devfreq/Kconfig
> index 0f079be..0ec6572 100644
> --- a/drivers/devfreq/Kconfig
> +++ b/drivers/devfreq/Kconfig
> @@ -67,7 +67,7 @@ comment "DEVFREQ Drivers"
>  
>  config ARM_EXYNOS4_BUS_DEVFREQ
>  	bool "ARM Exynos4210/4212/4412 Memory Bus DEVFREQ Driver"
> -	depends on CPU_EXYNOS4210 || CPU_EXYNOS4212 || CPU_EXYNOS4412
> +	depends on CPU_EXYNOS4210 || SOC_EXYNOS4212 || SOC_EXYNOS4412
>  	select ARCH_HAS_OPP
>  	select DEVFREQ_GOV_SIMPLE_ONDEMAND
>  	help
> -- 
> 1.7.11.7
> 
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
