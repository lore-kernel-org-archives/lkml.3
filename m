Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260AbaJUI4l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 04:56:41 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:15025 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836AbaJUI4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 04:56:35 -0400
X-AuditID: cbfee68d-f79296d000004278-d9-54461fc02181
Message-id: <54461FC0.9020904@samsung.com>
Date: Tue, 21 Oct 2014 17:56:32 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: Re: [PATCH 2/2] ARM: dts: exynos4412-trats: Add suspend configuration
 for max77686 regulators
References: <1413879912-26606-1-git-send-email-k.kozlowski@samsung.com>
 <1413879912-26606-3-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1413879912-26606-3-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsWyRsSkWPeAvFuIwYkblhYbZ6xntZi07gCT
	xdSHT9gsjv4usHj9wtCid8FVNouzTW/YLb5d6WCy2PT4GqvF5V1z2CxmnN/HZHH7Mq/F2iN3
	2S1W7frD6MDn0dLcw+bx9/l1Fo+/q14we+ycdZfdY9OqTjaPzUvqPfq2rGL0+LxJLoAjissm
	JTUnsyy1SN8ugSvj5eM+xoIPiRVtS24wNTDOdO1i5OSQEDCRmH/iERuELSZx4d56IJuLQ0hg
	KaPE0skzmGCKmue8YoRILGKU+L3iACuE85pR4vOkDlaQKl4BLYn/57cwg9gsAqoSm+f9ZgGx
	2YDi+1/cAFshKhAmsXL6FRaIekGJH5PvgdkiAoYSB3dvZwIZyiwwi0Xi0o7nQOs4OIQFMiT6
	XmtBLGsF2vzkLitInFPAQ6L/RzlIL7OAjsT+1mlsELa8xOY1b5lB6iUEJnJIrPvQxgJxkIDE
	t8mHWEB6JQRkJTYdYIb4TFLi4IobLBMYxWYhOWkWkrGzkIxdwMi8ilE0tSC5oDgpvchQrzgx
	t7g0L10vOT93EyMwqk//e9a7g/H2AetDjAIcjEo8vJFLXEOEWBPLiitzDzGaAl0xkVlKNDkf
	mDrySuINjc2MLExNTI2NzC3NlMR5FaV+BgsJpCeWpGanphakFsUXleakFh9iZOLglGpgVJxg
	qxmVtf2SyCTxiUo9PzX9bz28/Mum6/6kP2UR5ZxLjrqcunLJon5bReMa5jsd/pdD9fwzFr0U
	Obizd3bGuf6wmfxTeyoOPX/00cFCUvQdU1gc8wLHmgdTY++nv806wDJn5Z6eA+nGXHM3/TXS
	8FbxyPnb8+H09NIa6XX9qsGJnVYuH+5pKrEUZyQaajEXFScCAGXBHT/lAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsVy+t9jAd0D8m4hBufu6FtsnLGe1WLSugNM
	FlMfPmGzOPq7wOL1C0OL3gVX2SzONr1ht/h2pYPJYtPja6wWl3fNYbOYcX4fk8Xty7wWa4/c
	ZbdYtesPowOfR0tzD5vH3+fXWTz+rnrB7LFz1l12j02rOtk8Ni+p9+jbsorR4/MmuQCOqAZG
	m4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygq5UUyhJz
	SoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGS8f9zEWfEisaFtyg6mBcaZrFyMn
	h4SAiUTznFeMELaYxIV769m6GLk4hAQWMUr8XnGAFcJ5zSjxeVIHK0gVr4CWxP/zW5hBbBYB
	VYnN836zgNhsQPH9L26wgdiiAmESK6dfYYGoF5T4MfkemC0iYChxcPd2JpChzAKzWCQu7XgO
	tJqDQ1ggQ6LvtRbEslagzU/usoLEOQU8JPp/lIP0MgvoSOxvncYGYctLbF7zlnkCo8AsJCtm
	ISmbhaRsASPzKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzglPFMagfjygaLQ4wCHIxKPLwR
	S1xDhFgTy4orcw8xSnAwK4nw5gq7hQjxpiRWVqUW5ccXleakFh9iNAWGwERmKdHkfGA6yyuJ
	NzQ2MTOyNDI3tDAyNlcS5z3Qah0oJJCeWJKanZpakFoE08fEwSnVwCi8av9jfelNKiE58aVq
	Uw84BnySmLR/yYPe7xYlPso7Oy9pP86/4NG/v0x+x8zXd6oTzCsthA4eOvsh6uXMAja/PLFV
	LU/0ZJX0XH05l6Z7pecv6TZ0k9NlO7VDZI/m9eZu7pM9OgpasTeOy99Z81xD8sAVp7hqXvc9
	ujliyx2+cCws2+IzS4mlOCPRUIu5qDgRAL2cW9wvAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Krzysztof,

I think that the state of some regulators should be changed in suspend state.

On 10/21/2014 05:25 PM, Krzysztof Kozlowski wrote:
> Add suspend to RAM configuration for max77686 regulators. Some LDOs and
> bucks are disabled. This reduces energy consumption during S2R,
> approximately from 17 mA to 9 mA.
> 
> Additionally remove old and not supported bindings:
>  - regulator-mem-off
>  - regulator-mem-idle
>  - regulator-mem-on
> The max77686 driver does not parse them and they are not documented
> anywere.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  arch/arm/boot/dts/exynos4412-trats2.dts | 135 +++++++++++++++++++++++++-------
>  1 file changed, 105 insertions(+), 30 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/exynos4412-trats2.dts b/arch/arm/boot/dts/exynos4412-trats2.dts
> index dd9ac66770f7..c2fbee36021a 100644
> --- a/arch/arm/boot/dts/exynos4412-trats2.dts
> +++ b/arch/arm/boot/dts/exynos4412-trats2.dts
> @@ -225,7 +225,9 @@
>  					regulator-min-microvolt = <1000000>;
>  					regulator-max-microvolt = <1000000>;
>  					regulator-always-on;
> -					regulator-mem-on;
> +					regulator-state-mem {
> +						regulator-on-in-suspend;
> +					};
>  				};
>  
>  				ldo2_reg: ldo2 {
> @@ -234,7 +236,9 @@
>  					regulator-min-microvolt = <1200000>;
>  					regulator-max-microvolt = <1200000>;
>  					regulator-always-on;
> -					regulator-mem-on;
> +					regulator-state-mem {
> +						regulator-on-in-suspend;
> +					};
>  				};
>  
>  				ldo3_reg: ldo3 {
> @@ -243,7 +247,9 @@
>  					regulator-min-microvolt = <1800000>;
>  					regulator-max-microvolt = <1800000>;
>  					regulator-always-on;
> -					regulator-mem-on;
> +					regulator-state-mem {
> +						regulator-on-in-suspend;
> +					};
>  				};
>  
>  				ldo4_reg: ldo4 {
> @@ -252,7 +258,9 @@
>  					regulator-min-microvolt = <2800000>;
>  					regulator-max-microvolt = <2800000>;
>  					regulator-always-on;
> -					regulator-mem-on;
> +					regulator-state-mem {
> +						regulator-on-in-suspend;
> +					};
>  				};
>  
>  				ldo5_reg: ldo5 {
> @@ -261,7 +269,9 @@
>  					regulator-min-microvolt = <1800000>;
>  					regulator-max-microvolt = <1800000>;
>  					regulator-always-on;
> -					regulator-mem-on;
> +					regulator-state-mem {
> +						regulator-on-in-suspend;
> +					};
>  				};
>  
>  				ldo6_reg: ldo6 {
> @@ -270,7 +280,9 @@
>  					regulator-min-microvolt = <1000000>;
>  					regulator-max-microvolt = <1000000>;
>  					regulator-always-on;
> -					regulator-mem-on;
> +					regulator-state-mem {
> +						regulator-on-in-suspend;
> +					};
>  				};
>  
>  				ldo7_reg: ldo7 {
> @@ -279,7 +291,9 @@
>  					regulator-min-microvolt = <1000000>;
>  					regulator-max-microvolt = <1000000>;
>  					regulator-always-on;
> -					regulator-mem-on;
> +					regulator-state-mem {
> +						regulator-on-in-suspend;
> +					};
>  				};
>  
>  				ldo8_reg: ldo8 {
> @@ -287,7 +301,9 @@
>  					regulator-name = "VMIPI_1.0V";
>  					regulator-min-microvolt = <1000000>;
>  					regulator-max-microvolt = <1000000>;
> -					regulator-mem-off;
> +					regulator-state-mem {
> +						regulator-off-in-suspend;
> +					};
>  				};
>  
>  				ldo9_reg: ldo9 {
> @@ -295,7 +311,9 @@
>  					regulator-name = "CAM_ISP_MIPI_1.2V";
>  					regulator-min-microvolt = <1200000>;
>  					regulator-max-microvolt = <1200000>;
> -					regulator-mem-idle;
> +					regulator-state-mem {
> +						regulator-on-in-suspend;

CAM_ISP_MIPI_1.2V is used for camera, I think this regulator should turn off in suspend state
because camear could not be used in suspend state.

> +					};
>  				};
>  
>  				ldo10_reg: ldo10 {
> @@ -303,7 +321,9 @@
>  					regulator-name = "VMIPI_1.8V";
>  					regulator-min-microvolt = <1800000>;
>  					regulator-max-microvolt = <1800000>;
> -					regulator-mem-off;
> +					regulator-state-mem {
> +						regulator-off-in-suspend;
> +					};
>  				};
>  
>  				ldo11_reg: ldo11 {
> @@ -312,7 +332,9 @@
>  					regulator-min-microvolt = <1950000>;
>  					regulator-max-microvolt = <1950000>;
>  					regulator-always-on;
> -					regulator-mem-off;
> +					regulator-state-mem {
> +						regulator-off-in-suspend;
> +					};
>  				};
>  
>  				ldo12_reg: ldo12 {
> @@ -320,7 +342,9 @@
>  					regulator-name = "VUOTG_3.0V";
>  					regulator-min-microvolt = <3000000>;
>  					regulator-max-microvolt = <3000000>;
> -					regulator-mem-off;
> +					regulator-state-mem {
> +						regulator-off-in-suspend;
> +					};
>  				};
>  
>  				ldo13_reg: ldo13 {
> @@ -328,7 +352,9 @@
>  					regulator-name = "NFC_AVDD_1.8V";
>  					regulator-min-microvolt = <1800000>;
>  					regulator-max-microvolt = <1800000>;
> -					regulator-mem-idle;
> +					regulator-state-mem {
> +						regulator-on-in-suspend;

NFC_AVDD_1.8V is used for NFC feature, If user of smartphone want to use NFC feature
and then enable NFC on the setting menu, NFC_AVDD_1.8V should turn on in suspend state.

But, If NFC is not used, NFC_AVDD_1.8V should turn off in suspend state.
So, I think this regulator should be controlled by NFC device driver without 'regulator-state-mem' property.

> +					};
>  				};
>  
>  				ldo14_reg: ldo14 {
> @@ -337,7 +363,9 @@
>  					regulator-min-microvolt = <1950000>;
>  					regulator-max-microvolt = <1950000>;
>  					regulator-always-on;
> -					regulator-mem-off;
> +					regulator-state-mem {
> +						regulator-off-in-suspend;
> +					};
>  				};
>  
>  				ldo15_reg: ldo15 {
> @@ -345,7 +373,9 @@
>  					regulator-name = "VHSIC_1.0V";
>  					regulator-min-microvolt = <1000000>;
>  					regulator-max-microvolt = <1000000>;
> -					regulator-mem-off;
> +					regulator-state-mem {
> +						regulator-off-in-suspend;

VHSIC_1.8V was used for CP (Modem), CP (Modem) have to maintain the power in suspend state.
- off -> on

> +					};
>  				};
>  
>  				ldo16_reg: ldo16 {
> @@ -353,7 +383,9 @@
>  					regulator-name = "VHSIC_1.8V";
>  					regulator-min-microvolt = <1800000>;
>  					regulator-max-microvolt = <1800000>;
> -					regulator-mem-off;
> +					regulator-state-mem {
> +						regulator-off-in-suspend;

ditto (off -> on) for CP (MODEM)

> +					};
>  				};
>  
>  				ldo17_reg: ldo17 {
> @@ -361,7 +393,9 @@
>  					regulator-name = "CAM_SENSOR_CORE_1.2V";
>  					regulator-min-microvolt = <1200000>;
>  					regulator-max-microvolt = <1200000>;
> -					regulator-mem-idle;
> +					regulator-state-mem {
> +						regulator-on-in-suspend;

ditto. (on -> off) because camera is not used in supend state.

> +					};
>  				};
>  
>  				ldo18_reg: ldo18 {
> @@ -369,7 +403,9 @@
>  					regulator-name = "CAM_ISP_SEN_IO_1.8V";
>  					regulator-min-microvolt = <1800000>;
>  					regulator-max-microvolt = <1800000>;
> -					regulator-mem-idle;
> +					regulator-state-mem {
> +						regulator-on-in-suspend;

ditto. (on -> off) because camera is not used in supend state.

> +					};
>  				};
>  
>  				ldo19_reg: ldo19 {
> @@ -377,7 +413,9 @@
>  					regulator-name = "VT_CAM_1.8V";
>  					regulator-min-microvolt = <1800000>;
>  					regulator-max-microvolt = <1800000>;
> -					regulator-mem-idle;
> +					regulator-state-mem {
> +						regulator-on-in-suspend;

ditto. (on -> off) because camera is not used in supend state.

> +					};
>  				};
>  
>  				ldo20_reg: ldo20 {
> @@ -385,7 +423,9 @@
>  					regulator-name = "VDDQ_PRE_1.8V";
>  					regulator-min-microvolt = <1800000>;
>  					regulator-max-microvolt = <1800000>;
> -					regulator-mem-idle;
> +					regulator-state-mem {
> +						regulator-on-in-suspend;
> +					};
>  				};
>  
>  				ldo21_reg: ldo21 {
> @@ -393,7 +433,9 @@
>  					regulator-name = "VTF_2.8V";
>  					regulator-min-microvolt = <2800000>;
>  					regulator-max-microvolt = <2800000>;
> -					regulator-mem-idle;
> +					regulator-state-mem {
> +						regulator-on-in-suspend;
> +					};
>  				};
>  
>  				ldo22_reg: ldo22 {
> @@ -401,6 +443,9 @@
>  					regulator-name = "VMEM_VDD_2.8V";
>  					regulator-min-microvolt = <2800000>;
>  					regulator-max-microvolt = <2800000>;
> +					regulator-state-mem {
> +						regulator-on-in-suspend;
> +					};
>  				};
>  
>  				ldo23_reg: ldo23 {
> @@ -408,7 +453,9 @@
>  					regulator-name = "TSP_AVDD_3.3V";
>  					regulator-min-microvolt = <3300000>;
>  					regulator-max-microvolt = <3300000>;
> -					regulator-mem-idle;
> +					regulator-state-mem {
> +						regulator-on-in-suspend;

ditto. (on -> off) because touchscreen is not used in suspend state.

> +					};
>  				};
>  
>  				ldo24_reg: ldo24 {
> @@ -416,7 +463,9 @@
>  					regulator-name = "TSP_VDD_1.8V";
>  					regulator-min-microvolt = <1800000>;
>  					regulator-max-microvolt = <1800000>;
> -					regulator-mem-idle;
> +					regulator-state-mem {
> +						regulator-on-in-suspend;

ditto. (on -> off)

> +					};
>  				};
>  
>  				ldo25_reg: ldo25 {
> @@ -424,7 +473,9 @@
>  					regulator-name = "LCD_VCC_3.3V";
>  					regulator-min-microvolt = <2800000>;
>  					regulator-max-microvolt = <2800000>;
> -					regulator-mem-idle;
> +					regulator-state-mem {
> +						regulator-on-in-suspend;
> +					};

LDC_VCC_3.3V may not be used in susepnd state. I think this regulator should turn off in suspend state.

>  				};
>  
>  				ldo26_reg: ldo26 {
> @@ -432,7 +483,9 @@
>  					regulator-name = "MOTOR_VCC_3.0V";
>  					regulator-min-microvolt = <3000000>;
>  					regulator-max-microvolt = <3000000>;
> -					regulator-mem-idle;
> +					regulator-state-mem {
> +						regulator-on-in-suspend;
> +					};

If MOTOR_VCC_3.0V is used for haptic, I think this regulator should turn off in suspend state.

>  				};
>  
>  				buck1_reg: buck1 {
> @@ -442,7 +495,9 @@
>  					regulator-max-microvolt = <1100000>;
>  					regulator-always-on;
>  					regulator-boot-on;
> -					regulator-mem-off;
> +					regulator-state-mem {
> +						regulator-off-in-suspend;
> +					};
>  				};
>  
>  				buck2_reg: buck2 {
> @@ -452,7 +507,9 @@
>  					regulator-max-microvolt = <1500000>;
>  					regulator-always-on;
>  					regulator-boot-on;
> -					regulator-mem-off;
> +					regulator-state-mem {
> +						regulator-on-in-suspend;
> +					};
>  				};
>  
>  				buck3_reg: buck3 {
> @@ -462,7 +519,9 @@
>  					regulator-max-microvolt = <1150000>;
>  					regulator-always-on;
>  					regulator-boot-on;
> -					regulator-mem-off;
> +					regulator-state-mem {
> +						regulator-off-in-suspend;
> +					};
>  				};
>  
>  				buck4_reg: buck4 {
> @@ -471,7 +530,9 @@
>  					regulator-min-microvolt = <850000>;
>  					regulator-max-microvolt = <1150000>;
>  					regulator-boot-on;
> -					regulator-mem-off;
> +					regulator-state-mem {
> +						regulator-off-in-suspend;
> +					};
>  				};
>  
>  				buck5_reg: buck5 {
> @@ -480,6 +541,9 @@
>  					regulator-min-microvolt = <1200000>;
>  					regulator-max-microvolt = <1200000>;
>  					regulator-always-on;
> +					regulator-state-mem {
> +						regulator-on-in-suspend;
> +					};
>  				};
>  
>  				buck6_reg: buck6 {
> @@ -488,6 +552,9 @@
>  					regulator-min-microvolt = <1350000>;
>  					regulator-max-microvolt = <1350000>;
>  					regulator-always-on;
> +					regulator-state-mem {
> +						regulator-on-in-suspend;
> +					};
>  				};
>  
>  				buck7_reg: buck7 {
> @@ -496,6 +563,9 @@
>  					regulator-min-microvolt = <2000000>;
>  					regulator-max-microvolt = <2000000>;
>  					regulator-always-on;
> +					regulator-state-mem {
> +						regulator-on-in-suspend;
> +					};
>  				};
>  
>  				buck8_reg: buck8 {
> @@ -503,6 +573,9 @@
>  					regulator-name = "VMEM_VDDF_3.0V";
>  					regulator-min-microvolt = <2850000>;
>  					regulator-max-microvolt = <2850000>;
> +					regulator-state-mem {
> +						regulator-on-in-suspend;
> +					};
>  				};
>  
>  				buck9_reg: buck9 {
> @@ -510,7 +583,9 @@
>  					regulator-name = "CAM_ISP_CORE_1.2V";
>  					regulator-min-microvolt = <1000000>;
>  					regulator-max-microvolt = <1200000>;
> -					regulator-mem-off;
> +					regulator-state-mem {
> +						regulator-off-in-suspend;
> +					};
>  				};
>  			};
>  		};
> 

Thanks,
Chanwoo Choi
