Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932323AbaJVC6A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 22:58:00 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:15118 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbaJVC56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 22:57:58 -0400
X-AuditID: cbfee68d-f79296d000004278-3b-54471d33da12
Message-id: <54471D33.8000906@samsung.com>
Date: Wed, 22 Oct 2014 11:57:55 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: Re: [PATCH v3 4/4] ARM: dts: exynos4412-trats: Add suspend
 configuration for max77686 regulators
References: <1413897595-28752-1-git-send-email-k.kozlowski@samsung.com>
 <1413897595-28752-5-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1413897595-28752-5-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsWyRsSkQNdY1j3EYNZbbYuNM9azWkxad4DJ
	YurDJ2wW84+cY7U4+rvA4vULQ4veBVfZLM42vWG3uP/1KKPFtysdTBabHl9jtbi8aw6bxYzz
	+5gsbl/mtVh75C67xeluVgcBj5bmHjaPv8+vs3j8XfWC2WPnrLvsHptWdbJ53Lm2h81j3slA
	j81L6j36tqxi9Pi8SS6AK4rLJiU1J7MstUjfLoEr49L1s4wFH1wqXuxZzNTAeN+gi5GTQ0LA
	ROLy7f9MELaYxIV769m6GLk4hASWMkqs3feRBaZo9tEdzBCJ6YwSz89cZ4RwXjNKbNy3Gayd
	V0BL4sDl6+wgNouAqkRHx3Iwmw0ovv/FDTYQW1QgTGLl9CssEPWCEj8m3wOzRQQMJQ7u3s4E
	MpRZ4CaLxPyZF8CGCgtkS2w994EdYlsro8TJ9gdgUzkFPCT2PellBrGZBXQk9rdOY4Ow5SU2
	r3kLdquEwEoOiRUd15kgThKQ+Db5ENA6DqCErMSmA8wQv0lKHFxxg2UCo9gsJEfNQjJ2FpKx
	CxiZVzGKphYkFxQnpRcZ6hUn5haX5qXrJefnbmIERv/pf896dzDePmB9iFGAg1GJh9eBzT1E
	iDWxrLgy9xCjKdAVE5mlRJPzgSkmryTe0NjMyMLUxNTYyNzSTEmcV1HqZ7CQQHpiSWp2ampB
	alF8UWlOavEhRiYOTqkGxu0JtacNcj/nvdOcuJpZatKmU4Iz717b4z/32JduKZ53R+StVk5z
	rrpz5eHhI37TGdbsc76w8PshvrJth5x7ax1uOL5Zxnv4VkLQz01dtQpvGUJcWud6MuvOex+X
	vfqb0fX1Hc7fRGJnPa0v0NklZ5985I7L6tvHsx4bPGh3ljLY/u2vi6HIl0wlluKMREMt5qLi
	RAAqntj9+QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAKsWRmVeSWpSXmKPExsVy+t9jQV1jWfcQg9PTFC02zljPajFp3QEm
	i6kPn7BZzD9yjtXi6O8Ci9cvDC16F1xlszjb9Ibd4v7Xo4wW3650MFlsenyN1eLyrjlsFjPO
	72OyuH2Z12LtkbvsFqe7WR0EPFqae9g8/j6/zuLxd9ULZo+ds+6ye2xa1cnmcefaHjaPeScD
	PTYvqffo27KK0ePzJrkArqgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8
	xNxUWyUXnwBdt8wcoD+UFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYQ1jBmX
	rp9lLPjgUvFiz2KmBsb7Bl2MnBwSAiYSs4/uYIawxSQu3FvP1sXIxSEkMJ1R4vmZ64wQzmtG
	iY37NjOBVPEKaEkcuHydHcRmEVCV6OhYDmazAcX3v7jBBmKLCoRJrJx+hQWiXlDix+R7YLaI
	gKHEwd3bmUCGMgvcZJGYP/MC2FBhgWyJrec+sENsa2WUONn+AGwqp4CHxL4nvWD3MQvoSOxv
	ncYGYctLbF7zlnkCo8AsJEtmISmbhaRsASPzKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzg
	1PJMegfjqgaLQ4wCHIxKPLwObO4hQqyJZcWVuYcYJTiYlUR4KziBQrwpiZVVqUX58UWlOanF
	hxhNgWEwkVlKNDkfmPbySuINjU3MjCyNzA0tjIzNlcR5D7ZaBwoJpCeWpGanphakFsH0MXFw
	SjUwuicebV+SJ7Oi2flhfyRzF4tyaujl9Zn/CmrNVko/32PuI/TyWWyq5LLONy7l5UHlPV46
	AtzzWydNXRd9kz0+UbRoX1bTQo62vfne17e/V4++PGGD3x8jdx+hXo0vx/03Rch/f3TXsP1H
	zezkw68XtlzXb953fv8H2Wane22FZiz7Lym+CtVTYinOSDTUYi4qTgQA/FVBSkMDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Krzysztof,

On 10/21/2014 10:19 PM, Krzysztof Kozlowski wrote:
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
> Reviewed-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> ---
>  arch/arm/boot/dts/exynos4412-trats2.dts | 72 +++++++++++++++++++--------------
>  1 file changed, 42 insertions(+), 30 deletions(-)

Looks good to me.

Reviewed-by: Chanwoo Choi <cw00.choi@samsung.com>

Thanks,
Chanwoo Choi

> 
> diff --git a/arch/arm/boot/dts/exynos4412-trats2.dts b/arch/arm/boot/dts/exynos4412-trats2.dts
> index dd9ac66770f7..8067eb447829 100644
> --- a/arch/arm/boot/dts/exynos4412-trats2.dts
> +++ b/arch/arm/boot/dts/exynos4412-trats2.dts
> @@ -225,7 +225,6 @@
>  					regulator-min-microvolt = <1000000>;
>  					regulator-max-microvolt = <1000000>;
>  					regulator-always-on;
> -					regulator-mem-on;
>  				};
>  
>  				ldo2_reg: ldo2 {
> @@ -234,7 +233,9 @@
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
> @@ -243,7 +244,6 @@
>  					regulator-min-microvolt = <1800000>;
>  					regulator-max-microvolt = <1800000>;
>  					regulator-always-on;
> -					regulator-mem-on;
>  				};
>  
>  				ldo4_reg: ldo4 {
> @@ -252,7 +252,6 @@
>  					regulator-min-microvolt = <2800000>;
>  					regulator-max-microvolt = <2800000>;
>  					regulator-always-on;
> -					regulator-mem-on;
>  				};
>  
>  				ldo5_reg: ldo5 {
> @@ -261,7 +260,6 @@
>  					regulator-min-microvolt = <1800000>;
>  					regulator-max-microvolt = <1800000>;
>  					regulator-always-on;
> -					regulator-mem-on;
>  				};
>  
>  				ldo6_reg: ldo6 {
> @@ -270,7 +268,9 @@
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
> @@ -279,7 +279,9 @@
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
> @@ -287,7 +289,9 @@
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
> @@ -295,7 +299,6 @@
>  					regulator-name = "CAM_ISP_MIPI_1.2V";
>  					regulator-min-microvolt = <1200000>;
>  					regulator-max-microvolt = <1200000>;
> -					regulator-mem-idle;
>  				};
>  
>  				ldo10_reg: ldo10 {
> @@ -303,7 +306,9 @@
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
> @@ -312,7 +317,9 @@
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
> @@ -320,7 +327,9 @@
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
> @@ -328,7 +337,6 @@
>  					regulator-name = "NFC_AVDD_1.8V";
>  					regulator-min-microvolt = <1800000>;
>  					regulator-max-microvolt = <1800000>;
> -					regulator-mem-idle;
>  				};
>  
>  				ldo14_reg: ldo14 {
> @@ -337,7 +345,9 @@
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
> @@ -345,7 +355,9 @@
>  					regulator-name = "VHSIC_1.0V";
>  					regulator-min-microvolt = <1000000>;
>  					regulator-max-microvolt = <1000000>;
> -					regulator-mem-off;
> +					regulator-state-mem {
> +						regulator-on-in-suspend;
> +					};
>  				};
>  
>  				ldo16_reg: ldo16 {
> @@ -353,7 +365,9 @@
>  					regulator-name = "VHSIC_1.8V";
>  					regulator-min-microvolt = <1800000>;
>  					regulator-max-microvolt = <1800000>;
> -					regulator-mem-off;
> +					regulator-state-mem {
> +						regulator-on-in-suspend;
> +					};
>  				};
>  
>  				ldo17_reg: ldo17 {
> @@ -361,7 +375,6 @@
>  					regulator-name = "CAM_SENSOR_CORE_1.2V";
>  					regulator-min-microvolt = <1200000>;
>  					regulator-max-microvolt = <1200000>;
> -					regulator-mem-idle;
>  				};
>  
>  				ldo18_reg: ldo18 {
> @@ -369,7 +382,6 @@
>  					regulator-name = "CAM_ISP_SEN_IO_1.8V";
>  					regulator-min-microvolt = <1800000>;
>  					regulator-max-microvolt = <1800000>;
> -					regulator-mem-idle;
>  				};
>  
>  				ldo19_reg: ldo19 {
> @@ -377,7 +389,6 @@
>  					regulator-name = "VT_CAM_1.8V";
>  					regulator-min-microvolt = <1800000>;
>  					regulator-max-microvolt = <1800000>;
> -					regulator-mem-idle;
>  				};
>  
>  				ldo20_reg: ldo20 {
> @@ -385,7 +396,6 @@
>  					regulator-name = "VDDQ_PRE_1.8V";
>  					regulator-min-microvolt = <1800000>;
>  					regulator-max-microvolt = <1800000>;
> -					regulator-mem-idle;
>  				};
>  
>  				ldo21_reg: ldo21 {
> @@ -393,7 +403,6 @@
>  					regulator-name = "VTF_2.8V";
>  					regulator-min-microvolt = <2800000>;
>  					regulator-max-microvolt = <2800000>;
> -					regulator-mem-idle;
>  				};
>  
>  				ldo22_reg: ldo22 {
> @@ -408,7 +417,6 @@
>  					regulator-name = "TSP_AVDD_3.3V";
>  					regulator-min-microvolt = <3300000>;
>  					regulator-max-microvolt = <3300000>;
> -					regulator-mem-idle;
>  				};
>  
>  				ldo24_reg: ldo24 {
> @@ -416,7 +424,6 @@
>  					regulator-name = "TSP_VDD_1.8V";
>  					regulator-min-microvolt = <1800000>;
>  					regulator-max-microvolt = <1800000>;
> -					regulator-mem-idle;
>  				};
>  
>  				ldo25_reg: ldo25 {
> @@ -424,7 +431,6 @@
>  					regulator-name = "LCD_VCC_3.3V";
>  					regulator-min-microvolt = <2800000>;
>  					regulator-max-microvolt = <2800000>;
> -					regulator-mem-idle;
>  				};
>  
>  				ldo26_reg: ldo26 {
> @@ -432,7 +438,6 @@
>  					regulator-name = "MOTOR_VCC_3.0V";
>  					regulator-min-microvolt = <3000000>;
>  					regulator-max-microvolt = <3000000>;
> -					regulator-mem-idle;
>  				};
>  
>  				buck1_reg: buck1 {
> @@ -442,7 +447,9 @@
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
> @@ -452,7 +459,9 @@
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
> @@ -462,7 +471,9 @@
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
> @@ -471,7 +482,9 @@
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
> @@ -510,7 +523,6 @@
>  					regulator-name = "CAM_ISP_CORE_1.2V";
>  					regulator-min-microvolt = <1000000>;
>  					regulator-max-microvolt = <1200000>;
> -					regulator-mem-off;
>  				};
>  			};
>  		};
> 

