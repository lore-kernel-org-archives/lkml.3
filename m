Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935AbbAMJvJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 04:51:09 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:24112 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbbAMJvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 04:51:04 -0500
X-AuditID: cbfee68d-f79296d000004278-4e-54b4ea859ed0
Date: Tue, 13 Jan 2015 09:51:01 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCHv3 5/8] ARM: dts: Add memory bus node for Exynos4x12
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
X-MTR: 20150113092259284@myungjoo.ham
Msgkey: 20150113092259284@myungjoo.ham
X-EPLocale: ko_KR.utf-8
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-MLAttribute: 
X-RootMTR: 20150113092259284@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
X-ConfirmMail: N,general
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <36216978.973981421142658259.JavaMail.weblogic@epmlwas05d>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIIsWRmVeSWpSXmKPExsWyRsSkWLf11ZYQg1UP5C0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGkVPRBW8EK2ad3cjawLhGsIuRk0NIQF1i0ZKTbCC2hICJxISF
	pxghbDGJC/fWA8W5gGqWMkqc2HONEaZo4e52ZojmOYwSf77FgdgsAqoS+/9eY+pi5OBgE9CT
	mPk5GSQsLOAusWDiPLBWEYE8iSt3ZzCCzGQW6GGT6Lj6HWqOksSafa9YQGxeAUGJkzOfsEDs
	UpXY+34tM0RcTeLUjwVQN4hLXJh7iR3C5pWY0f4Uql5OYtrXNcwQtrTE+Vkb4J5Z/P0xVJxf
	4tjtHUwQtoDE1DMHGUFulhDQkjj5wgMizCexZuFbFpjyXaeWM8Osur9lLlSrhMTWliesIDaz
	gKLElO6H7CBjmAU0Jdbv0kf3Ca+Am8SkRf+ZQF6XEJjKIbHvz3L2CYxKs5DUzUIyahbCKGQl
	CxhZVjGKphYkFxQnpRcZ6hUn5haX5qXrJefnbmIEpoTT/5717mC8fcD6EKMAB6MSD++O7C0h
	QqyJZcWVuYcYTYGRNJFZSjQ5H5h48kriDY3NjCxMTUyNjcwtzZTEeRWlfgYLCaQnlqRmp6YW
	pBbFF5XmpBYfYmTi4JRqYNwQ7rXGk2G+q5iusvH/l3o7X5+Z88zzrPOnvTebT8/8FjT58m5Z
	x7zTvArrbkeqiEQ1ScVqpIebM70255mh9VOD442PUqH6hNTIhodZZeet+AKXmswIPfqotZSH
	x9Kd913st1Cvby9FeN+/mPeRWfi2YEn8mt4U2/bXgVJZ+/YeFrc4Kt71UomlOCPRUIu5qDgR
	AF7izXcEAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEKsWRmVeSWpSXmKPExsVy+t/tPt3WV1tCDL68l7C4vGsOmwOjx+dN
	cgGMUWk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StGG5kZ6RgZ6pkZ6hsaxVoYGBkamQDUJaRlH
	TkUXvBGsmHV2I2sD4xrBLkZODiEBdYlFS06ygdgSAiYSC3e3M0PYYhIX7q1ng6iZwyjx51sc
	iM0ioCqx/+81pi5GDg42AT2JmZ+TQcLCAu4SCybOYwSxRQTyJK7cnQFkc3EwC/SwSXRc/c4M
	MUdJYs2+VywgNq+AoMTJmU9YIHapSux9v5YZIq4mcerHAkaIuLjEhbmX2CFsXokZ7U+h6uUk
	pn1dA3WntMT5WRsYYW5e/P0xVJxf4tjtHUwQtoDE1DMHGUFulhDQkjj5wgMizCexZuFbFpjy
	XaeWM8Osur9lLlSrhMTWliesIDazgKLElO6H7CBjmAU0Jdbv0kf3Ca+Am8SkRf+ZJjDKzkKS
	moWkexZCN7KSBYwsqxhFUwuSC4qT0itM9IoTc4tL89L1kvNzNzGC08+zJTsYGy5YH2IU4GBU
	4uHdkb0lRIg1say4MvcQowQHs5II7/zbQCHelMTKqtSi/Pii0pzU4kOMpsAom8gsJZqcD0yN
	eSXxhsbGJmYmppYmFgam5krivP/P5YYICaQnlqRmp6YWpBbB9DFxcEo1MFpl8jw8kjM19SO3
	nsKK+/oTt/eYvjV6wpyv/66lfc+y0k+/J2X7KSpN729Zs/2viGCKIvN7x/O9Lm3d4sIdmZ93
	8XKvmczCuG5Cqhm339wf/q+qtFdHKyx5s2RGsZve6/R//a/Pmi5Q8pMPbb+yV3ralO+l2Uf8
	hBIS/+TNcEzfLPrzmafAOyWW4oxEQy3mouJEAH+HnJxVAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0D9pHr3026655

>   
>  This patch adds the memory bus node for Exynos4x12 SoC. Exynos4x12 SoC has
> two memory bus to translate data between DRAM and eMMC/sub-IPs.
> 
> Following list specifies the detailed relation between memory bus clock and DMC
> IP in MIF (Memory Interface) block:
> - DMC/ACP clock : DMC (Dynamic Memory Controller)
> 
> Following list specifies the detailed relation between memory bus clock and
> sub-IPs in INT (Internal) block:
> - ACLK100 clock : PERIL/PERIR/MFC(PCLK)
> - ACLK160 clock : CAM/TV/LCD
> - ACLK133 clock : FSYS
> - GDL/GDR clock : leftbus/rightbus
> - SCLK_MFC clock : MFC
> 
> Cc: Kukjin Kim <kgene@kernel.org>
> Cc: Myungjoo Ham <myungjoo.ham@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>

Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com> for all the other dts file patch with Exynos*.


Off Topic. Not urgent. Just out of curiousity:
  Do you have some idea on how to express voltage variations
with device tree? (not runtime-AVS, but boottime-AVS. runtime-AVS is rather
trivial)

  I think you remember that we often had multiple set of "OPP tables" and
we chose one of them based on the value extracted at boot time in order to
use lower voltage values without deteriorating the reliability.

  Basically, such a feature requires to express multiple OPP lists and let
the kernel choose one of the lists at the boot time, which I doubt the
expressiveness in the current device tree technique.

> ---
>  arch/arm/boot/dts/exynos4x12.dtsi | 121 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 121 insertions(+)
> 
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
