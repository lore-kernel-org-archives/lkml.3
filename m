Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131AbbASJjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 04:39:19 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:43068 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbbASJjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 04:39:14 -0500
X-AuditID: cbfee68d-f79296d000004278-15-54bcd0b33f29
Date: Mon, 19 Jan 2015 09:38:59 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH v4 9/9] devfreq: exynos: Remove unused exynos4 memory
 busfreq driver
To: =?utf-8?Q?=EC=B5=9C=EC=B0=AC=EC=9A=B0?= <cw00.choi@samsung.com>,
        "kgene@kernel.org" <kgene@kernel.org>
Cc: =?utf-8?Q?=EB=B0=95=EA=B2=BD=EB=AF=BC?= <kyungmin.park@samsung.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        ABHILASH KESAVAN <a.kesavan@samsung.com>,
        "tomasz.figa@gmail.com" <tomasz.figa@gmail.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        =?utf-8?Q?=EB=8C=80=EC=9D=B8=EA=B8=B0?= <inki.dae@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20150119093849158@myungjoo.ham
Msgkey: 20150119093849158@myungjoo.ham
X-EPLocale: ko_KR.utf-8
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-MLAttribute: 
X-RootMTR: 20150119093849158@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
X-ConfirmMail: N,general
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <821926569.1255301421660336040.JavaMail.weblogic@epmlwas05d>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAIsWRmVeSWpSXmKPExsWyRsSkUHfzhT0hBrdOKlhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M9kt/2ApaOCruvdnA2sD4hL2LkZNDSEBdYtGSk2xdjBwcEgIm
	Est3B4KEJQTEJC7cWw8U5gIqWcoose/8eUaYms/nnSHicxgllsy7xgrSwCKgKrFi7mZ2kBo2
	AT2JmZ+TQUxhgQiJj82+IBUiAnkSV+7OYARpZRboYZPouPqdGeIEJYk1+16xgNi8AoISJ2c+
	YYG4QVVi/qvX7BBxNYlZ/1axQcTFJS7MvcQOYfNKzGh/ClUvJzHt6xpmCFta4vysDYwwvyz+
	/hgqzi9x7PYOJghbQGLqmYNQb2lJLPuvDBHmk1iz8C0LTPmuU8uZYVbd3zIXqlVCYmvLE7DP
	mQUUJaZ0PwT7nFlAU2L9Ln10n/AKeEhcXbyECeR1CYGZHBK7Ti9kn8CoNAtJ3Swko2YhjEJW
	soCRZRWjaGpBckFxUnqRoV5xYm5xaV66XnJ+7iZGYEI4/e9Z7w7G2wesDzEKcDAq8fBu8N0T
	IsSaWFZcmXuI0RQYRxOZpUST84FpJ68k3tDYzMjC1MTU2Mjc0kxJnFdR6mewkEB6Yklqdmpq
	QWpRfFFpTmrxIUYmDk6pBkbu9ASTHX2f/j13XMXQ6OXe6VlrHlRRU+zY8YljX8Nt8/QXz9r1
	7C6vdG64fZRt8iZvpe/R1Z+yGBf36kUttl155Gr4jqLe/4vsWPfF+344s5V7HdMPPWHBhb9f
	L5l8fNozu5OXF1y8ziMyrXBl5pV3aucFfWoVl+fvPWZ6JEu9nSlM/LBPs44SS3FGoqEWc1Fx
	IgBaAyixAwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEKsWRmVeSWpSXmKPExsVy+t/tXt3NF/aEGKw+J21xedccNgdGj8+b
	5AIYo9JsMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4CG
	KimUJeaUAoUCEouLlfTtbIryS0tSFTLyi0tslaINzY30jAz0TI30DI1jrQwNDIxMgWoS0jLa
	L/1hK2jhqLj3ZgNrA+MT9i5GTg4hAXWJRUtOsnUxcnBICJhIfD7vDBKWEBCTuHBvPVCYC6hk
	DqPEknnXWEESLAKqEivmbmYHqWcT0JOY+TkZxBQWiJD42OwLUiEikCdx5e4MRpBWZoEeNomO
	q9+ZIVYpSazZ94oFxOYVEJQ4OfMJC8QuVYn5r16zQ8TVJGb9W8UGEReXuDD3EjuEzSsxo/0p
	VL2cxLSva5ghbGmJ87M2MMLcvPj7Y6g4v8Sx2zuYIGwBialnDjJCvKglsey/MkSYT2LNwrcs
	MOW7Ti1nhll1f8tcqFYJia0tT8A+ZxZQlJjS/RDsc2YBTYn1u/TRfcIr4CFxdfESpgmMsrOQ
	pGYh6Z6F0I2sZAEjyypG0dSC5ILipPQKI73ixNzi0rx0veT83E2M4PTzbNEOxn/nrQ8xCnAw
	KvHwcgTsCRFiTSwrrsw9xCjBwawkwssITF5CvCmJlVWpRfnxRaU5qcWHGE2BMTaRWUo0OR+Y
	GvNK4g2NjU3MTEwtTSwMTM2VxHn/n8sNERJITyxJzU5NLUgtgulj4uCUamDMnMpZoi3sy9Qf
	UJT5V7qPo7TnxCprh40lCZPqtsyf5HqBsaD8bsCjdGYBdamFclsTHxp+v86xtPlsfaDJmo4V
	wq51rHZfnzQWnJspZOHO/GPDXTeuZUZ/EpYfTZA9Ji5z2/rNh5pft77knWo/wyQulrldpPfr
	juuKWS7G/UeEpRhvHWmZ36zEUpyRaKjFXFScCAB2ljqlVQMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0J9dNDi001852

>   
>  This patch removes the unused exynos4 memory busfreq driver by adding generic
> exynos memory bus frequency driver.
> 
> Cc: Myungjoo Ham <myungjoo.ham@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>

Reviewed-by: MyungJoo Ham <myungjoo.ham@samsung.com>

> ---
>  drivers/devfreq/Kconfig              |   12 -
>  drivers/devfreq/exynos/Makefile      |    1 -
>  drivers/devfreq/exynos/exynos4_bus.c | 1055 ----------------------------------
>  drivers/devfreq/exynos/exynos4_bus.h |  110 ----
>  4 files changed, 1178 deletions(-)
>  delete mode 100644 drivers/devfreq/exynos/exynos4_bus.c
>  delete mode 100644 drivers/devfreq/exynos/exynos4_bus.h
> 
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
