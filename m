Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462AbaGYF2J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 01:28:09 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:57707 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbaGYF2F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 01:28:05 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-ff-53d1eae2d028
From: Kukjin Kim <kgene.kim@samsung.com>
To: "=?UTF-8?Q?'Andreas_F=C3=A4rber'?=" <afaerber@suse.de>,
        linux-samsung-soc@vger.kernel.org
Cc: "'Stephan van Schaik'" <stephan@synkhronix.com>,
        "'Vincent Palatin'" <vpalatin@chromium.org>,
        "'Doug Anderson'" <dianders@chromium.org>,
        "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Rob Herring'" <robh+dt@kernel.org>,
        "'Pawel Moll'" <pawel.moll@arm.com>,
        "'Mark Rutland'" <mark.rutland@arm.com>,
        "'Ian Campbell'" <ijc+devicetree@hellion.org.uk>,
        "'Kumar Gala'" <galak@codeaurora.org>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'moderated list:ARM/SAMSUNG ARM A...'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'open list:OPEN FIRMWARE AND...'" <devicetree@vger.kernel.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
References: <1405704009-8430-1-git-send-email-afaerber@suse.de>
 <1405704009-8430-2-git-send-email-afaerber@suse.de>
In-reply-to: <1405704009-8430-2-git-send-email-afaerber@suse.de>
Subject: RE: [PATCH v2 1/4] ARM: dts: exynos5250: max77686 is Snow only
Date: Fri, 25 Jul 2014 14:28:02 +0900
Message-id: <08fe01cfa7c9$341cc700$9c565500$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQFTHlsTi3tuynczAE60l34YYt3VrgG40nrgnJuN3pA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMKsWRmVeSWpSXmKPExsVy+t8zI91Hry4GG7yYyWfRvKnYYtK6A0wW
	84+cY7U4u+wgm0X/m4WsFuderWS02PT4GqvF5V1z2CxmnN/HZHH7Mq/F0usXmSwmTF/LYtG6
	9wi7xf5jPxkttn27w+LA77Fm3hpGj5bmHjaP2Q0XWTwu9/Uyefxd9YLZY+XyL2wem1Z1snls
	XlLvsfl0tcfTdYfZPT5vkgvgjuKySUnNySxLLdK3S+DK+HB8KnPB88CKvyfyGxiv2nYxcnJI
	CJhI7D79lR3CFpO4cG89WxcjF4eQwDJGifZvp9hgio41bWSHSCxilPg+8yKU85dRYvbKF4wg
	VWwCGhKH3z8DGyUiECtxePstZhCbWeApi8S0x5kgtpBAqcSeZwdYQWxOAQeJp3+3gdULC7hL
	zJ+3DsxmEVCV+LH4J1gNr4ClxKN735ggbEGJH5PvsUDMVJeYNG8R1HxtiSfvLrBCXKogsePs
	a6B7OIBusJLovhsBUSIise/FO0aQmyUETnBIfHu5gQ1il4DEt8mHWEDqJQRkJTYdYIYYIylx
	cMUNlgmMErOQbJ6FZPMsJJtnIVmxgJFlFaNoakFyQXFSepGhXnFibnFpXrpecn7uJkZIAund
	wXj7gPUhxmSg9ROZpUST84EJKK8k3tDYzMjC1MTU2Mjc0ow0YSVx3qSHSUFCAumJJanZqakF
	qUXxRaU5qcWHGJk4OKUaGIXC2r1M6hnKZWMvHJwjuM5m63HuzEP32XRWSAZX+kVat72oNXdQ
	Yt69rkg4Pfbt3q1vrnz8UDk3VFTWMPUU/8LjP8Uqlwk+29pRmf5dcLO93MwrfJM8j3hv8TNJ
	51rh//Tiu1zXQJ85ivfTH7v6PbDZ6c76aToHU9QcxQeyk5gzTnvv+f53uRJLcUaioRZzUXEi
	AKvnji82AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEKsWRmVeSWpSXmKPExsVy+t9jAd1Hry4GG/Sv5LBo3lRsMWndASaL
	+UfOsVqcXXaQzaL/zUJWi3OvVjJabHp8jdXi8q45bBYzzu9jsrh9mddi6fWLTBYTpq9lsWjd
	e4TdYv+xn4wW277dYXHg91gzbw2jR0tzD5vH7IaLLB6X+3qZPP6uesHssXL5FzaPTas62Tw2
	L6n32Hy62uPpusPsHp83yQVwRzUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgr
	KeQl5qbaKrn4BOi6ZeYAfaKkUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxj
	zPhwfCpzwfPAir8n8hsYr9p2MXJySAiYSBxr2sgOYYtJXLi3nq2LkYtDSGARo8T3mRfZIZy/
	jBKzV75gBKliE9CQOPz+GViHiECsxOHtt5hBbGaBpywS0x5ngthCAqUSe54dYAWxOQUcJJ7+
	3QZWLyzgLjF/3jowm0VAVeLH4p9gNbwClhKP7n1jgrAFJX5MvscCMVNdYtK8RVDztSWevLvA
	CnGpgsSOs6+B7uEAusFKovtuBESJiMS+F+8YJzAKzUIyaRaSSbOQTJqFpGUBI8sqRtHUguSC
	4qT0XCO94sTc4tK8dL3k/NxNjOD09Ex6B+OqBotDjAIcjEo8vB31F4OFWBPLiitzDzFKcDAr
	ifDKPAAK8aYkVlalFuXHF5XmpBYfYjQFenQis5Rocj4wdeaVxBsam5gZWRqZWRiZmJsrifMe
	bLUOFBJITyxJzU5NLUgtgulj4uCUamDkMZyp5pC64uHlf5FX3rssbbzfFcMRM8dPR9N+FTPD
	7AyX2VvVLRetEDj7bmr3Tz7/Hwq6p3yYddsWBJl2zYs4Nt1+2g9eq5rMpu+RzvudG5yF31be
	O/X52STn6ZtLTjzYdvFK5P3ZNVt0VxWtbrSeF8vXf0/N5HHPojVbOupTk5YEXK19u3eTEktx
	RqKhFnNRcSIAVlpoymUDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Färber wrote:
> 
> Move it from exynos5250-cros-common.dtsi to exynos5250-snow.dts.
> Spring does not need it, it uses an s5m8767 instead.
> 
> Signed-off-by: Andreas Färber <afaerber@suse.de>
> ---

Hi Andreas,

I think this should be reviewed by chrome guys.


Doug, can you have a look this series for exynos5250-chromebook?
I'm not sure exynos5250-cros-common is still useful for exynos5250-spring...

- Kukjin

>  v2: New (Doug Anderson)
> 
>  arch/arm/boot/dts/exynos5250-cros-common.dtsi | 151 -------------------------
>  arch/arm/boot/dts/exynos5250-snow.dts         | 155 ++++++++++++++++++++++++++
>  2 files changed, 155 insertions(+), 151 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/exynos5250-cros-common.dtsi b/arch/arm/boot/dts/exynos5250-cros-
> common.dtsi
> index 89ac90f..61128d1 100644
> --- a/arch/arm/boot/dts/exynos5250-cros-common.dtsi
> +++ b/arch/arm/boot/dts/exynos5250-cros-common.dtsi
> @@ -27,163 +27,12 @@
>  		i2c2_bus: i2c2-bus {
>  			samsung,pin-pud = <0>;
>  		};
> -
> -		max77686_irq: max77686-irq {
> -			samsung,pins = "gpx3-2";
> -			samsung,pin-function = <0>;
> -			samsung,pin-pud = <0>;
> -			samsung,pin-drv = <0>;
> -		};
>  	};
> 
>  	i2c@12C60000 {
>  		status = "okay";
>  		samsung,i2c-sda-delay = <100>;
>  		samsung,i2c-max-bus-freq = <378000>;
> -
> -		max77686@09 {
> -			compatible = "maxim,max77686";
> -			interrupt-parent = <&gpx3>;
> -			interrupts = <2 0>;
> -			pinctrl-names = "default";
> -			pinctrl-0 = <&max77686_irq>;
> -			wakeup-source;
> -			reg = <0x09>;
> -			#clock-cells = <1>;
> -
> -			voltage-regulators {
> -				ldo1_reg: LDO1 {
> -					regulator-name = "P1.0V_LDO_OUT1";
> -					regulator-min-microvolt = <1000000>;
> -					regulator-max-microvolt = <1000000>;
> -					regulator-always-on;
> -				};
> -
> -				ldo2_reg: LDO2 {
> -					regulator-name = "P1.8V_LDO_OUT2";
> -					regulator-min-microvolt = <1800000>;
> -					regulator-max-microvolt = <1800000>;
> -					regulator-always-on;
> -				};
> -
> -				ldo3_reg: LDO3 {
> -					regulator-name = "P1.8V_LDO_OUT3";
> -					regulator-min-microvolt = <1800000>;
> -					regulator-max-microvolt = <1800000>;
> -					regulator-always-on;
> -				};
> -
> -				ldo7_reg: LDO7 {
> -					regulator-name = "P1.1V_LDO_OUT7";
> -					regulator-min-microvolt = <1100000>;
> -					regulator-max-microvolt = <1100000>;
> -					regulator-always-on;
> -				};
> -
> -				ldo8_reg: LDO8 {
> -					regulator-name = "P1.0V_LDO_OUT8";
> -					regulator-min-microvolt = <1000000>;
> -					regulator-max-microvolt = <1000000>;
> -					regulator-always-on;
> -				};
> -
> -				ldo10_reg: LDO10 {
> -					regulator-name = "P1.8V_LDO_OUT10";
> -					regulator-min-microvolt = <1800000>;
> -					regulator-max-microvolt = <1800000>;
> -					regulator-always-on;
> -				};
> -
> -				ldo12_reg: LDO12 {
> -					regulator-name = "P3.0V_LDO_OUT12";
> -					regulator-min-microvolt = <3000000>;
> -					regulator-max-microvolt = <3000000>;
> -					regulator-always-on;
> -				};
> -
> -				ldo14_reg: LDO14 {
> -					regulator-name = "P1.8V_LDO_OUT14";
> -					regulator-min-microvolt = <1800000>;
> -					regulator-max-microvolt = <1800000>;
> -					regulator-always-on;
> -				};
> -
> -				ldo15_reg: LDO15 {
> -					regulator-name = "P1.0V_LDO_OUT15";
> -					regulator-min-microvolt = <1000000>;
> -					regulator-max-microvolt = <1000000>;
> -					regulator-always-on;
> -				};
> -
> -				ldo16_reg: LDO16 {
> -					regulator-name = "P1.8V_LDO_OUT16";
> -					regulator-min-microvolt = <1800000>;
> -					regulator-max-microvolt = <1800000>;
> -					regulator-always-on;
> -				};
> -
> -				buck1_reg: BUCK1 {
> -					regulator-name = "vdd_mif";
> -					regulator-min-microvolt = <950000>;
> -					regulator-max-microvolt = <1300000>;
> -					regulator-always-on;
> -					regulator-boot-on;
> -				};
> -
> -				buck2_reg: BUCK2 {
> -					regulator-name = "vdd_arm";
> -					regulator-min-microvolt = <850000>;
> -					regulator-max-microvolt = <1350000>;
> -					regulator-always-on;
> -					regulator-boot-on;
> -				};
> -
> -				buck3_reg: BUCK3 {
> -					regulator-name = "vdd_int";
> -					regulator-min-microvolt = <900000>;
> -					regulator-max-microvolt = <1200000>;
> -					regulator-always-on;
> -					regulator-boot-on;
> -				};
> -
> -				buck4_reg: BUCK4 {
> -					regulator-name = "vdd_g3d";
> -					regulator-min-microvolt = <850000>;
> -					regulator-max-microvolt = <1300000>;
> -					regulator-always-on;
> -					regulator-boot-on;
> -				};
> -
> -				buck5_reg: BUCK5 {
> -					regulator-name = "P1.8V_BUCK_OUT5";
> -					regulator-min-microvolt = <1800000>;
> -					regulator-max-microvolt = <1800000>;
> -					regulator-always-on;
> -					regulator-boot-on;
> -				};
> -
> -				buck6_reg: BUCK6 {
> -					regulator-name = "P1.35V_BUCK_OUT6";
> -					regulator-min-microvolt = <1350000>;
> -					regulator-max-microvolt = <1350000>;
> -					regulator-always-on;
> -				};
> -
> -				buck7_reg: BUCK7 {
> -					regulator-name = "P2.0V_BUCK_OUT7";
> -					regulator-min-microvolt = <2000000>;
> -					regulator-max-microvolt = <2000000>;
> -					regulator-always-on;
> -				};
> -
> -				buck8_reg: BUCK8 {
> -					regulator-name = "P2.85V_BUCK_OUT8";
> -					regulator-min-microvolt = <2850000>;
> -					regulator-max-microvolt = <2850000>;
> -					regulator-always-on;
> -				};
> -			};
> -		};
>  	};
> 
>  	i2c@12C70000 {
> diff --git a/arch/arm/boot/dts/exynos5250-snow.dts b/arch/arm/boot/dts/exynos5250-snow.dts
> index c682c88..0f867a3 100644
> --- a/arch/arm/boot/dts/exynos5250-snow.dts
> +++ b/arch/arm/boot/dts/exynos5250-snow.dts
> @@ -344,4 +344,159 @@
>  	};
>  };
> 
> +&i2c_0 {
> +	max77686@09 {
> +		compatible = "maxim,max77686";
> +		interrupt-parent = <&gpx3>;
> +		interrupts = <2 0>;
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&max77686_irq>;
> +		wakeup-source;
> +		reg = <0x09>;
> +		#clock-cells = <1>;
> +
> +		voltage-regulators {
> +			ldo1_reg: LDO1 {
> +				regulator-name = "P1.0V_LDO_OUT1";
> +				regulator-min-microvolt = <1000000>;
> +				regulator-max-microvolt = <1000000>;
> +				regulator-always-on;
> +			};
> +
> +			ldo2_reg: LDO2 {
> +				regulator-name = "P1.8V_LDO_OUT2";
> +				regulator-min-microvolt = <1800000>;
> +				regulator-max-microvolt = <1800000>;
> +				regulator-always-on;
> +			};
> +
> +			ldo3_reg: LDO3 {
> +				regulator-name = "P1.8V_LDO_OUT3";
> +				regulator-min-microvolt = <1800000>;
> +				regulator-max-microvolt = <1800000>;
> +				regulator-always-on;
> +			};
> +
> +			ldo7_reg: LDO7 {
> +				regulator-name = "P1.1V_LDO_OUT7";
> +				regulator-min-microvolt = <1100000>;
> +				regulator-max-microvolt = <1100000>;
> +				regulator-always-on;
> +			};
> +
> +			ldo8_reg: LDO8 {
> +				regulator-name = "P1.0V_LDO_OUT8";
> +				regulator-min-microvolt = <1000000>;
> +				regulator-max-microvolt = <1000000>;
> +				regulator-always-on;
> +			};
> +
> +			ldo10_reg: LDO10 {
> +				regulator-name = "P1.8V_LDO_OUT10";
> +				regulator-min-microvolt = <1800000>;
> +				regulator-max-microvolt = <1800000>;
> +				regulator-always-on;
> +			};
> +
> +			ldo12_reg: LDO12 {
> +				regulator-name = "P3.0V_LDO_OUT12";
> +				regulator-min-microvolt = <3000000>;
> +				regulator-max-microvolt = <3000000>;
> +				regulator-always-on;
> +			};
> +
> +			ldo14_reg: LDO14 {
> +				regulator-name = "P1.8V_LDO_OUT14";
> +				regulator-min-microvolt = <1800000>;
> +				regulator-max-microvolt = <1800000>;
> +				regulator-always-on;
> +			};
> +
> +			ldo15_reg: LDO15 {
> +				regulator-name = "P1.0V_LDO_OUT15";
> +				regulator-min-microvolt = <1000000>;
> +				regulator-max-microvolt = <1000000>;
> +				regulator-always-on;
> +			};
> +
> +			ldo16_reg: LDO16 {
> +				regulator-name = "P1.8V_LDO_OUT16";
> +				regulator-min-microvolt = <1800000>;
> +				regulator-max-microvolt = <1800000>;
> +				regulator-always-on;
> +			};
> +
> +			buck1_reg: BUCK1 {
> +				regulator-name = "vdd_mif";
> +				regulator-min-microvolt = <950000>;
> +				regulator-max-microvolt = <1300000>;
> +				regulator-always-on;
> +				regulator-boot-on;
> +			};
> +
> +			buck2_reg: BUCK2 {
> +				regulator-name = "vdd_arm";
> +				regulator-min-microvolt = <850000>;
> +				regulator-max-microvolt = <1350000>;
> +				regulator-always-on;
> +				regulator-boot-on;
> +			};
> +
> +			buck3_reg: BUCK3 {
> +				regulator-name = "vdd_int";
> +				regulator-min-microvolt = <900000>;
> +				regulator-max-microvolt = <1200000>;
> +				regulator-always-on;
> +				regulator-boot-on;
> +			};
> +
> +			buck4_reg: BUCK4 {
> +				regulator-name = "vdd_g3d";
> +				regulator-min-microvolt = <850000>;
> +				regulator-max-microvolt = <1300000>;
> +				regulator-always-on;
> +				regulator-boot-on;
> +			};
> +
> +			buck5_reg: BUCK5 {
> +				regulator-name = "P1.8V_BUCK_OUT5";
> +				regulator-min-microvolt = <1800000>;
> +				regulator-max-microvolt = <1800000>;
> +				regulator-always-on;
> +				regulator-boot-on;
> +			};
> +
> +			buck6_reg: BUCK6 {
> +				regulator-name = "P1.35V_BUCK_OUT6";
> +				regulator-min-microvolt = <1350000>;
> +				regulator-max-microvolt = <1350000>;
> +				regulator-always-on;
> +			};
> +
> +			buck7_reg: BUCK7 {
> +				regulator-name = "P2.0V_BUCK_OUT7";
> +				regulator-min-microvolt = <2000000>;
> +				regulator-max-microvolt = <2000000>;
> +				regulator-always-on;
> +			};
> +
> +			buck8_reg: BUCK8 {
> +				regulator-name = "P2.85V_BUCK_OUT8";
> +				regulator-min-microvolt = <2850000>;
> +				regulator-max-microvolt = <2850000>;
> +				regulator-always-on;
> +			};
> +		};
> +	};
> +};
> +
> +&pinctrl_0 {
> +	max77686_irq: max77686-irq {
> +		samsung,pins = "gpx3-2";
> +		samsung,pin-function = <0>;
> +		samsung,pin-pud = <0>;
> +		samsung,pin-drv = <0>;
> +	};
> +};
> +
>  #include "cros-ec-keyboard.dtsi"
> --
> 1.9.3

