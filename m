Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840Ab3GKL4J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 07:56:09 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:35869 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754447Ab3GKL4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 07:56:05 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-c4-51de9d53a553
From: Cho KyongHo <pullip.cho@samsung.com>
To: "'Prathyush K'" <prathyush@chromium.org>
Cc: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>,
        "'Hyunwoong Kim'" <khw0178.kim@samsung.com>,
        "'Joerg Roedel'" <joro@8bytes.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>,
        "'Keyyoung Park'" <keyyoung.park@samsung.com>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>
References: <002e01ce797b$4dc46d20$e94d4760$@samsung.com>
 <CAH=HWYPUJP9NxOgs6Ei+azB5UqiKocMe00+z5i+sD7io8D0g=w@mail.gmail.com>
In-reply-to: <CAH=HWYPUJP9NxOgs6Ei+azB5UqiKocMe00+z5i+sD7io8D0g=w@mail.gmail.com>
Subject: RE: [PATCH v7 6/9] clk: exynos5250: add gate clock descriptions of
 System MMU
Date: Thu, 11 Jul 2013 20:56:02 +0900
Message-id: <000a01ce7e2d$9de742d0$d9b5c870$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQNHztAuwKtlwkVZxgdufhz3pab/yQIdMHrCllvP0wA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAKsWRmVeSWpSXmKPExsVy+t8zI93gufcCDRaeE7B4deQHk8WC/dYW
	nbM3sFtsPriOxaJ3wVU2i8Z7E9gsNj2+xmpxedccNosZ5/cxWVxYsZHdYsL8j6wWUxYdZrVo
	ud7LZHFsxhJGBz6PJwfnMXnMbrjI4nHn2h42j81L6j0m31jO6NG3ZRWjx+dNcgHsUVw2Kak5
	mWWpRfp2CVwZ149+Zyy4ZlZxs/U5WwPjP7UuRk4OCQETiclnDjFB2GISF+6tZ+ti5OIQEljG
	KPFv0SkmmKKzc88yQSSmM0p8n3ubFcL5yyixde5qZpAqNgEtidVzjzOC2CJAdv+dTWCjmAUe
	s0gsX7MNqr0BqH3zMbAOToFgieu7u8A6hAUiJBpW7WUDsVkEVCWmP+oCq+EVsJSYsPMpC4Qt
	KPFj8j0wmxlow/qdx5kgbHmJzWveMkPcqiCx4+xrqCusJOZufAdVLyKx78U7RpAjJASWckh8
	7n/KDrFMQOLb5ENARRxACVmJTQeg5khKHFxxg2UCo8QsJKtnIVk9C8nqWUhWLGBkWcUomlqQ
	XFCclF5kqFecmFtcmpeul5yfu4kRkhp6dzDePmB9iDEZaP1EZinR5HxgaskriTc0NjOyMDUx
	NTYytzQjTVhJnFetxTpQSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUAyPbAhHdx6V/u0vlNlzv
	Mf0ZxXz32+nP/fvnv8wOVm2w2hey8FEEi8uN9NmCjTkLr83bLSu9++Wxf0JGb7mD/gvsyY2P
	PrYwPXn6jAOX5zyI2JQ29axgYKah1dzL8/o385Ydftt055aawhkb0ZjVay0O9P30//im//up
	umexuwK+Tr1aUfz0Zg2nEktxRqKhFnNRcSIARZO7+SMDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLKsWRmVeSWpSXmKPExsVy+t9jQd3gufcCDXonclm8OvKDyWLBfmuL
	ztkb2C02H1zHYtG74CqbReO9CWwWmx5fY7W4vGsOm8WM8/uYLC6s2MhuMWH+R1aLKYsOs1q0
	XO9lsjg2YwmjA5/Hk4PzmDxmN1xk8bhzbQ+bx+Yl9R6Tbyxn9OjbsorR4/MmuQD2qAZGm4zU
	xJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygk5UUyhJzSoFC
	AYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGdePfmcsuGZWcbP1OVsD4z+1LkZODgkB
	E4mzc88yQdhiEhfurWfrYuTiEBKYzijxfe5tVgjnL6PE1rmrmUGq2AS0JFbPPc4IYosA2f13
	NoF1MAs8ZpFYvmYbE0RHA1D75mNgHZwCwRLXd3eBdQgLREg0rNrLBmKzCKhKTH/UBVbDK2Ap
	MWHnUxYIW1Dix+R7YDYz0Ib1O48zQdjyEpvXvGWGuFVBYsfZ11BXWEnM3fgOql5EYt+Ld4wT
	GIVmIRk1C8moWUhGzULSsoCRZRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcOJ5Jr2DcVWD
	xSFGAQ5GJR7ehvi7gUKsiWXFlbmHGCU4mJVEeAUn3wsU4k1JrKxKLcqPLyrNSS0+xJgM9OlE
	ZinR5HxgUswriTc0NjEzsjQyszAyMTcnTVhJnPdgq3WgkEB6YklqdmpqQWoRzBYmDk6pBkbT
	a0u4w/T+/ND1Cpn76+DEOX7LxBKs8zMamhTnWjzo4fky1WLR1Iuzpq8W+e11al7fRJuVbJen
	WVR2sLf/62c79F/risqmaoU9sU7Bl4WfSx/m229yz1ov7Ouh70X8irlfZ/0Le1Ci/OF9cd5t
	Zr+avU9X+SVv3RirN1tqwZnJfbnCurp71xQqsRRnJBpqMRcVJwIAOpskx4ADAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Prathyush K [mailto:prathyush@chromium.org] 
> Sent: Wednesday, July 10, 2013 11:49 PM
> 
> On Fri, Jul 5, 2013 at 5:59 PM, Cho KyongHo <pullip.cho@samsung.com> wrote:
> This adds gate clocks of all System MMUs and their master IPs
> that are not apeared in clk-exynos5250.c
> 
> Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> CC: Thomas Abraham <thomas.abraham@linaro.org>
> ---
>  .../devicetree/bindings/clock/exynos5250-clock.txt |   28 +++++++++-
>  drivers/clk/samsung/clk-exynos5250.c               |   57 ++++++++++++++++---
>  2 files changed, 75 insertions(+), 10 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/clock/exynos5250-clock.txt
> b/Documentation/devicetree/bindings/clock/exynos5250-clock.txt
> index 781a627..df49694 100644
> --- a/Documentation/devicetree/bindings/clock/exynos5250-clock.txt
> +++ b/Documentation/devicetree/bindings/clock/exynos5250-clock.txt
> @@ -154,7 +154,33 @@ clock which they consume.
>    dsim0                        341
>    dp                   342
>    mixer                        343
> -  hdmi                 345
> +  hdmi                 344
> +  camif_top            345
> +  smmu_fimc_lite0      346
> +  smmu_fimc_lite1      347
> +  smmu_fimc_lite2      348
> +  smmu_tv              349
> +  smmu_fimd1           350
> +  smmu_2d              351
> +  fimc_isp             352
> +  fimc_drc             353
> +  fimc_fd              354
> +  fimc_scc             355
> +  fimc_scp             356
> +  fimc_mcuctl          357
> +  fimc_odc             358
> +  fimc_dis             359
> +  fimc_3dnr            360
> +  smmu_fimc_isp                361
> +  smmu_fimc_drc                362
> +  smmu_fimc_fd         363
> +  smmu_fimc_scc                364
> +  smmu_fimc_scp                365
> +  smmu_fimc_mcuctl     366
> +  smmu_fimc_odc                367
> +  smmu_fimc_dis0       368
> +  smmu_fimc_dis1       369
> +  smmu_fimc_3dnr       370
> 
>  Example 1: An example of a clock controller node is listed below.
> 
> diff --git a/drivers/clk/samsung/clk-exynos5250.c b/drivers/clk/samsung/clk-exynos5250.c
> index 22d7699..1921d6c 100644
> --- a/drivers/clk/samsung/clk-exynos5250.c
> +++ b/drivers/clk/samsung/clk-exynos5250.c
> @@ -53,12 +53,15 @@
>  #define DIV_PERIC3             0x10564
>  #define DIV_PERIC4             0x10568
>  #define DIV_PERIC5             0x1056c
> +#define GATE_IP_ISP0           0x0C800
> +#define GATE_IP_ISP1           0x0C800
>  #define GATE_IP_GSCL           0x10920
>  #define GATE_IP_MFC            0x1092c
>  #define GATE_IP_GEN            0x10934
>  #define GATE_IP_FSYS           0x10944
>  #define GATE_IP_PERIC          0x10950
>  #define GATE_IP_PERIS          0x10960
> +#define GATE_IP_ACP            0x18800
>  #define SRC_CDREX              0x20200
>  #define PLL_DIV2_SEL           0x20a24
>  #define GATE_IP_DISP1          0x10928
> @@ -100,6 +103,14 @@ enum exynos5250_clks {
>         tzpc2, tzpc3, tzpc4, tzpc5, tzpc6, tzpc7, tzpc8, tzpc9, hdmi_cec, mct,
>         wdt, rtc, tmu, fimd1, mie1, dsim0, dp, mixer, hdmi,
> 
> +       camif_top, smmu_fimc_lite0, smmu_fimc_lite1, smmu_fimc_lite2,
> +       smmu_tv, smmu_fimd1, smmu_2d,
> +       fimc_isp, fimc_drc, fimc_fd, fimc_scc, fimc_scp, fimc_mcuctl, fimc_odc,
> +       fimc_dis, fimc_3dnr,
> +       smmu_fimc_isp, smmu_fimc_drc, smmu_fimc_fd, smmu_fimc_scc,
> +       smmu_fimc_scp, smmu_fimc_mcuctl, smmu_fimc_odc, smmu_fimc_dis0,
> +       smmu_fimc_dis1, smmu_fimc_3dnr,
> +
>         nr_clks,
>  };
> 
> @@ -320,19 +331,26 @@ struct samsung_gate_clock exynos5250_gate_clks[] __initdata = {
>         GATE(gscl3, "gscl3", "aclk266", GATE_IP_GSCL, 3, 0, 0),
>         GATE(gscl_wa, "gscl_wa", "div_gscl_wa", GATE_IP_GSCL, 5, 0, 0),
>         GATE(gscl_wb, "gscl_wb", "div_gscl_wb", GATE_IP_GSCL, 6, 0, 0),
> -       GATE(smmu_gscl0, "smmu_gscl0", "aclk266", GATE_IP_GSCL, 7, 0, 0),
> -       GATE(smmu_gscl1, "smmu_gscl1", "aclk266", GATE_IP_GSCL, 8, 0, 0),
> -       GATE(smmu_gscl2, "smmu_gscl2", "aclk266", GATE_IP_GSCL, 9, 0, 0),
> -       GATE(smmu_gscl3, "smmu_gscl3", "aclk266", GATE_IP_GSCL, 10, 0, 0),
> +       GATE(smmu_gscl0, "smmu_gscl0", "gscl0", GATE_IP_GSCL, 7, 0, 0),
> +       GATE(smmu_gscl1, "smmu_gscl1", "gscl1", GATE_IP_GSCL, 8, 0, 0),
> +       GATE(smmu_gscl2, "smmu_gscl2", "gscl2", GATE_IP_GSCL, 9, 0, 0),
> +       GATE(smmu_gscl3, "smmu_gscl3", "gscl3", GATE_IP_GSCL, 10, 0, 0),
> +       GATE(camif_top, "camif_top", "aclk266", GATE_IP_GSCL, 4, 0, 0),
> +       GATE(smmu_fimc_lite0, "smmu_fimc_lite0", "camif_top",
> +                                               GATE_IP_GSCL, 12, 0, 0),
> +       GATE(smmu_fimc_lite1, "smmu_fimc_lite1", "camif_top",
> +                                               GATE_IP_GSCL, 13, 0, 0),
> +       GATE(smmu_fimc_lite2, "smmu_fimc_lite2", "camif_top",
> +                                               GATE_IP_GSCL, 14, 0, 0),
>         GATE(mfc, "mfc", "aclk333", GATE_IP_MFC, 0, 0, 0),
> -       GATE(smmu_mfcl, "smmu_mfcl", "aclk333", GATE_IP_MFC, 1, 0, 0),
> -       GATE(smmu_mfcr, "smmu_mfcr", "aclk333", GATE_IP_MFC, 2, 0, 0),
> +       GATE(smmu_mfcl, "smmu_mfcl", "mfc", GATE_IP_MFC, 1, 0, 0),
> +       GATE(smmu_mfcr, "smmu_mfcr", "mfc", GATE_IP_MFC, 2, 0, 0),
> 
> This should be reversed as seen in 5250. The mfcl's control bit is 2 and mfcr's control bit is 1.
> 
Oh. Really it is.
I didn't check it.
I remember that you have pointed that several times already. :)

> Why is the parent of the smmu_mfc set as "mfc"? Is this a required hierarchy in the clocks?
> Even I noticed that we need to turn on MFC's clock to be able to access smmu_mfc's registers.
> But I don't think setting mfc as parent of smmu_mfc is the correct solution since this results in MFC not getting clock gated
during video playback.
> 
> Beginning of playback:
> Turn on SYSMMU:
> MFC Sysmmu clock: +1
> MFC clock: +1
> 
> During video playback, dynamic clock gating of MFC:
> Turn on MFC (before frame decode)
> MFC Sysmmu clock: +1
> MFC clock: +2
> 
> Turn off MFC (after frame decode)
> MFC Sysmmu clock: +1
> MFC clock: +1
> 
> End of playback:
> Turn off SYSMMU:
> MFC Sysmmu clock: 0 (gated)
> MFC clock: 0 (gated)
> 
> As can be seen, MFC's dynamic clock gating between frames never works since the sysmmu has already turned on the clock.
> 
> A better way is to pass the mmu-master's clock through the device node (optional parameter).
> If the parent device's clock is present in the sysmmu node, we turn ON/OFF this clock before/after we access any sysmmu registers
> E.g. before/after TLB invalidation.
> 
> What do you think?
> 

Hmm,, it is also a good idea to handle master's clock explicitly
Master's clock is already passed to the System MMU driver if it is required
via dts.
Please let me think about it again

Thank you.

Cho KyongHo.

