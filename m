Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723AbbALILa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 03:11:30 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:44713 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbbALIL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 03:11:27 -0500
X-AuditID: cbfee68f-f791c6d000004834-a6-54b381ad0acc
Date: Mon, 12 Jan 2015 08:11:25 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCHv7 05/10] devfreq: event: Add documentation for exynos-ppmu
 devfreq-event driver
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
X-MTR: 20150112081113706@myungjoo.ham
Msgkey: 20150112081113706@myungjoo.ham
X-EPLocale: ko_KR.utf-8
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-MLAttribute: 
X-RootMTR: 20150112081113706@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
X-ConfirmMail: N,general
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <905389780.892831421050282747.JavaMail.weblogic@epmlwas09a>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRmVeSWpSXmKPExsWyRsSkRHdd4+YQg7O9TBaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSuj79xS1oIdUhXvJhxibmC8I9nFyMkhJKAusWjJSTYQW0LARGLr
	3QYmCFtM4sK99UBxLqCapYwSD3Z+Yu9i5AArappkCBGfwygxefIPFpA4i4CqxNqZjiAmm4Ce
	xMzPySBjhAWSJU41bQcbLyKQJ3Hl7gxGkFZmgR42iY6r35khblCSWLPvFQuIzSsgKHFy5hMW
	iBtUJdZMfMgEEVeT2Lr7H1RcXOLC3EvsEDavxIz2p1BxOYlpX9cwQ9jSEudnbWCE+WXx98dQ
	cX6JY7d3QP0oIDH1zEGoGi2J44uOQs3kk1iz8C0LTP2uU8uZYXbd3zIXqldCYmvLE1YQm1lA
	UWJK90Nw8DALaEqs36WP7hVeAXeJnUdmg4NTQmAmh8TKm0eYJzAqzUJSNwvJqFkIo5CVLGBk
	WcUomlqQXFCclF5krFecmFtcmpeul5yfu4kRmBRO/3vWv4Px7gHrQ4wCHIxKPLwWUptDhFgT
	y4orcw8xmgIjaSKzlGhyPjD15JXEGxqbGVmYmpgaG5lbmimJ8y6U+hksJJCeWJKanZpakFoU
	X1Sak1p8iJGJg1OqgdHBQ+/OigOL3tmfvr2ldk6Eo5PbzNU586aI8mzYvkZn6Z35taUBU9ym
	nN7PGugmwhP278y0QPWt/15tmyUpoFQSY/xchmP1cplYzrpfWqc5Gl/+sd23XHxRfX7xa++X
	S/wCc7K198+67aJZaii/1iIhxDj8TNfJ+3vzDjFx+q6uDlTUz8lYGq7EUpyRaKjFXFScCADH
	2bVDBQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMKsWRmVeSWpSXmKPExsVy+t/tXt21jZtDDFbdsLC4vGsOmwOjx+dN
	cgGMUWk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StGG5kZ6RgZ6pkZ6hsaxVoYGBkamQDUJaRl9
	55ayFuyQqng34RBzA+MdyS5GTg4hAXWJRUtOsnUxcnBICJhINE0yBAlLCIhJXLi3HijMBVQy
	h1Fi8uQfLCA1LAKqEmtnOoKYbAJ6EjM/J4OUCwskS5xq2s4GYosI5ElcuTuDEaSVWaCHTaLj
	6ndmiFVKEmv2vWIBsXkFBCVOznzCArFLVWLNxIdMEHE1ia27/0HFxSUuzL3EDmHzSsxofwoV
	l5OY9nUNM4QtLXF+1gZGmJsXf38MFeeXOHZ7BxOELSAx9cxBqBotieOLjkLN5JNYs/AtC0z9
	rlPLmWF23d8yF6pXQmJryxNWEJtZQFFiSvdDdpDfmQU0Jdbv0kf3Cq+Au8TOI7PZJjDKzkKS
	moWkexZCN7KSBYwsqxhFUwuSC4qT0iuM9IoTc4tL89L1kvNzNzGCE9CzRTsY/523PsQowMGo
	xMNrIbU5RIg1say4MvcQowQHs5IIr2sZUIg3JbGyKrUoP76oNCe1+BCjKTDKJjJLiSbnA5Nj
	Xkm8obGxiZmJqaWJhYGpuZI47/9zuSFCAumJJanZqakFqUUwfUwcnFINjOsd3ReG8MQ+yXnM
	e+F28Na83+LOk5RnN9720ljCdLq66/Sl7scS/DZfqtncVq+8mT/phKrPlSY3l43HRJh+lL2N
	CeI8/3Ci3enVu8yMWcVPcP+QrtY/HrS5c+muJ1wf5Rkzr0hd43/zLeKBwfqZN90uMxRcXa/p
	7nPgpUvA1k6T19+WMc7VlVNiKc5INNRiLipOBABom+uMVgMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0C8BbPm016448


I have rephrased part of the documentation for better readability.
Some semantics is guessed so you may need to re-rephrase.

Other than that, Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>


>  This patch adds the documentation for Exynos PPMU (Platform Performance
> Monitoring Unit) devfreq-event driver.
> 
> Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
>  .../bindings/devfreq/event/exynos-ppmu.txt         | 110 +++++++++++++++++++++
>  1 file changed, 110 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/devfreq/event/exynos-ppmu.txt
> 
> diff --git a/Documentation/devicetree/bindings/devfreq/event/exynos-ppmu.txt b/Documentation/devicetree/bindings/devfreq/event/exynos-ppmu.txt
> new file mode 100644
> index 0000000..e665d30
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/devfreq/event/exynos-ppmu.txt
> @@ -0,0 +1,110 @@
> +
> +* Samsung Exynos PPMU (Performance Profiling Monitoring Unit) device
> +
> +The Samsung Exynos SoC have PPMU (Performance Profiling Monitoring Unit) for

The Samsung Exynos SoC has PPMU (Performance Profiling Monitoring Unit) for
(have->has)

> +each IPs. PPMU provides the primitive values to get performance data. These

each IP. PPMU provides primitive values to get performance data.
(IPs->IP)

> +events provide useful information about the behavior of the SoC that you can

PPMU events provide information of the SoC's behaviors so that you may

> +use when analyzing system performance, and made visible and can be counted

use to analyze system performance, to make behaviors visible, and to count

> +using login in each IP (DMC, CPU, RIGHTBUS, LEFTBUS, CAM interface, LCD, G3D,

usages of each IP ( .... )

> +MFC). The Exynos PPMU driver use the devfreq-event class to provide event data

use -> uses

> +to various devfreq device. The devfreq device would use the event data when

device -> devices

> +derterming the current state of each IP.
> +
> +Required properties:
> +- compatible: Should be "samsung,exynos-ppmu".
> +- reg: physical base address of each PPMU and length of memory mapped region.
> +
> +Optional properties:
> +- clock-names : the name of clock used by the PPMU, "ppmu"
> +- clocks : phandles for clock specified in "clock-names" property
> +- #clock-cells: should be 1.
> +

[]
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
