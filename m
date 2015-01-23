Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbbAWG5B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 01:57:01 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:39337 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbbAWG4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 01:56:53 -0500
X-AuditID: cbfee68e-f79b46d000002b74-4f-54c1f0b3223b
Date: Fri, 23 Jan 2015 15:56:49 +0900
From: Inha Song <ideal.song@samsung.com>
To: kgene@kernel.org
Cc: Inha Song <ideal.song@samsung.com>, alsa-devel@alsa-project.org,
        mark.rutland@arm.com, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux@arm.linux.org.uk,
        pawel.moll@arm.com, ijc+devicetree@hellion.org.uk, sbkim73@samsung.com,
        linux-kernel@vger.kernel.org, broonie@kernel.org, lgirdwood@gmail.com,
        tiwai@suse.de, robh+dt@kernel.org, kgene@kernel.org,
        s.nawrocki@samsung.com, galak@codeaurora.org, grant.likely@linaro.org,
        linux-arm-kernel@lists.infradead.org,
        =?UTF-8?B?7LWc7LCs7Jqw?= <cw00.choi@samsung.com>
Subject: Re: [alsa-devel] [PATCH v4 3/3] ARM: dts: Add sound nodes for
 exynos4412-trats2
Message-id: <20150123155649.14fe36a7@songinha-Samsung-DeskTop-System>
In-reply-to: <1421989410-12490-4-git-send-email-ideal.song@samsung.com>
References: <1421989410-12490-1-git-send-email-ideal.song@samsung.com>
 <1421989410-12490-4-git-send-email-ideal.song@samsung.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplleLIzCtJLcpLzFFi42JZI2JSoLv5w8EQg5fL5CyuXDzEZDH14RM2
	i+tfnrNazD9yjtWi/81CVosDf3YwWuz6e5/R4tyrlYwW/Y9fM1t8u9LBZLHp8TVWi8u75rBZ
	zDi/j8ni9mVei6XXLzJZTJi+lsWide8RdovDb9pZLS6u+MJk8XLzGyYHEY8Nn5vYPNbMW8Po
	0dLcw+Zxua+XyWPnrLvsHiuXf2Hz2LSqk83jzrU9bB6bl9R79G1Zxeix+XS1x+dNcgE8UVw2
	Kak5mWWpRfp2CVwZFxdeZyk4KVQx6e0BxgbGo3xdjJwcEgImEjv3r2GEsMUkLtxbz9bFyMUh
	JLCUUaLr4CdmmKL7X1qZIBLTGSWu71/KDOH0M0lM7rjEDlLFIqAqMWH+IzYQm01AQ+L7581A
	RRwcIgIiErMvcIHUMwssZpHo/t/PBFIjLBAl0XjmFytIDa+Aq8T7T2CtnALuEu+vLYFa1swo
	8avnF9R5NhKrd64Du4hXQFDix+R7LCA2s4CWxOZtTawQtrzE5jVvwY6TELjDIXHv1GkmiOME
	JL5NPsQCskxCQFZi0wGozyQlDq64wTKBUWwWkrGzkIydhWTsAkbmVYyiqQXJBcVJ6UVGesWJ
	ucWleel6yfm5mxiBqeP0v2d9OxhvHrA+xCjAwajEw9u45WCIEGtiWXFl7iFGU6ArJjJLiSbn
	AxNUXkm8obGZkYWpiamxkbmlmZI4b4LUz2AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjKF8
	N4yOnf2VGvMnZM+8vEU1/m58PxwrkhUepK8+v1X3xlwlzXzmMzXdosd0ktN3hy6erxEn9WjT
	aYvLznqmLxu/TvvZHvv+rvL9jyk+7HYbWV+XnuANDlzfqXBnjreXxea8V88Kn+p+qku+3flH
	q6f7fKrlQjdLeW2flo/HGgX5frV3KjlfVWIpzkg01GIuKk4EAKNDYd8YAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPKsWRmVeSWpSXmKPExsVy+t9jQd3NHw6GGJybJ2Jx5eIhJoupD5+w
	WVz/8pzVYv6Rc6wW/W8Wsloc+LOD0WLX3/uMFuderWS06H/8mtni25UOJotNj6+xWlzeNYfN
	Ysb5fUwWty/zWiy9fpHJYsL0tSwWrXuPsFscftPOanFxxRcmi5eb3zA5iHhs+NzE5rFm3hpG
	j5bmHjaPy329TB47Z91l91i5/Aubx6ZVnWwed67tYfPYvKTeo2/LKkaPzaerPT5vkgvgiWpg
	tMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBelRJoSwx
	pxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjDmHFx4XWWgpNCFZPeHmBsYDzK18XI
	ySEhYCJx/0srE4QtJnHh3nq2LkYuDiGB6YwS1/cvZYZw+pkkJndcYgepYhFQlZgw/xEbiM0m
	oCHx/fNmoCIODhEBEYnZF7hA6pkFFrNIdP/vB5sqLBAl0XjmFytIDa+Aq8T7T2CtnALuEu+v
	LWGCmN/MKPGr5xcjxBU2Eqt3rmMGsXkFBCV+TL7HAmIzC2hJbN7WxAphy0tsXvOWeQKjwCwk
	ZbOQlM1CUraAkXkVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnBieia9g3FVg8UhRgEORiUe
	3oYtB0OEWBPLiitzDzFKcDArifB2PwIK8aYkVlalFuXHF5XmpBYfYjQFhsZEZinR5Hxg0swr
	iTc0NjEzsjQyN7QwMjZXEudVsm8LERJITyxJzU5NLUgtgulj4uCUamDMCXm55YZ439T7Qi8b
	NhdEi+oePf/9E+vTfA0Np/MxXsLvHD3YhauTv4aIHGt7539daM22QJYzm2wswxITfv4p6tK1
	zsh/JGHBrlq0Za6sjOw8vrj8S2sEJhunv0uyCk9vDCvvYbaus/gbysmb8Ed/lbfIvh5PheiT
	UXcPRlsKftFNMubyV2Ipzkg01GIuKk4EAMOWYGNiAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kukjin,

Sorry, I missed to adding in Cc.

Best Regards,
Inha Song.

On Fri, 23 Jan 2015 14:03:30 +0900
Inha Song <ideal.song@samsung.com> wrote:

> This patch add WM1811 audio codec, I2S interface and the sound
> machine nodes to enable audio on exynos4412-trats2 board.
> 
> Signed-off-by: Inha Song <ideal.song@samsung.com>
> ---
>  arch/arm/boot/dts/exynos4412-trats2.dts | 42 +++++++++++++++++++++++++++++++++
>  1 file changed, 42 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/exynos4412-trats2.dts b/arch/arm/boot/dts/exynos4412-trats2.dts
> index 29231b4..6205b98 100644
> --- a/arch/arm/boot/dts/exynos4412-trats2.dts
> +++ b/arch/arm/boot/dts/exynos4412-trats2.dts
> @@ -203,6 +203,25 @@
>  		};
>  	};
>  
> +	i2c@138A0000 {
> +		samsung,i2c-sda-delay = <100>;
> +		samsung,i2c-slave-addr = <0x10>;
> +		samsung,i2c-max-bus-freq = <100000>;
> +		pinctrl-0 = <&i2c4_bus>;
> +		pinctrl-names = "default";
> +		status = "okay";
> +
> +		wm1811: wm1811@1a {
> +			compatible = "wlf,wm1811";
> +			reg = <0x1a>;
> +			clocks = <&pmu_system_controller 0>;
> +			clock-names = "MCLK1";
> +			DCVDD-supply = <&ldo3_reg>;
> +			DBVDD1-supply = <&ldo3_reg>;
> +			wlf,ldo1ena = <&gpj0 4 0>;
> +		};
> +	};
> +
>  	i2c@138D0000 {
>  		samsung,i2c-sda-delay = <100>;
>  		samsung,i2c-slave-addr = <0x10>;
> @@ -838,6 +857,24 @@
>  		};
>  	};
>  
> +	i2s0: i2s@03830000 {
> +		pinctrl-0 = <&i2s0_bus>;
> +		pinctrl-names = "default";
> +		status = "okay";
> +	};
> +
> +	sound {
> +		compatible = "samsung,trats2-audio";
> +		samsung,i2s-controller = <&i2s0>;
> +		samsung,model = "Trats2";
> +		samsung,audio-codec = <&wm1811>;
> +		samsung,audio-routing =
> +			"SPK", "SPKOUTLN",
> +			"SPK", "SPKOUTLP",
> +			"SPK", "SPKOUTRN",
> +			"SPK", "SPKOUTRP";
> +	};
> +
>  	exynos-usbphy@125B0000 {
>  		status = "okay";
>  	};
> @@ -865,6 +902,11 @@
>  	};
>  };
>  
> +&pmu_system_controller {
> +	assigned-clocks = <&pmu_system_controller 0>;
> +	assigned-clock-parents =  <&clock CLK_XUSBXTI>;
> +};
> +
>  &pinctrl_0 {
>  	pinctrl-names = "default";
>  	pinctrl-0 = <&sleep0>;
> -- 
> 2.0.0.390.gcb682f8
> 
> _______________________________________________
> Alsa-devel mailing list
> Alsa-devel@alsa-project.org
> http://mailman.alsa-project.org/mailman/listinfo/alsa-devel
