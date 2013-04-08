Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935781Ab3DHMZH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 08:25:07 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:47587 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935337Ab3DHMZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 08:25:01 -0400
X-AuditID: cbfee68d-b7f786d000005188-4d-5162b71b1a75
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Amit Daniel Kachhap'" <amit.daniel@samsung.com>,
        linux-pm@vger.kernel.org
Cc: "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Zhang Rui'" <rui.zhang@intel.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, amit.kachhap@gmail.com
References: <1364297642-2746-1-git-send-email-amit.daniel@samsung.com>
 <1364297642-2746-10-git-send-email-amit.daniel@samsung.com>
In-reply-to: <1364297642-2746-10-git-send-email-amit.daniel@samsung.com>
Subject: RE: [PATCH 9/9] ARM: dts: Add device tree node for exynos5440 TMU
 controller
Date: Mon, 08 Apr 2013 21:24:59 +0900
Message-id: <2d0d01ce3454$166aac70$43400550$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4qFfaVVeVy1IeUTo6Q7AvaawH4VwKPfOLQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t8zfV3p7UmBBj/XWlk0XA2x+PVuJrvF
	5V1z2Cw+9x5htJhxfh+TxZOHfWwWx2YsYXRg99g56y67x+I9L5k87lzbw+bRt2UVo8fnTXIB
	rFFcNimpOZllqUX6dglcGX8u7mMpWCVQsePiPqYGxoM8XYycHBICJhJ9L/uZIGwxiQv31rN1
	MXJxCAksY5SYPuU9M0zR694TjCC2kMAiRonViwIgiv4ySsw+vgQswSagIXH4/TN2EFtEwFei
	f9sNdpAiZoENjBJX5hxjh+hoYZS4tmQ5C0gVp4CHxPuFe8G6hQXCJWa3bQNax8HBIqAqsWUp
	F0iYV8BW4sO/TnYIW1Dix+R7YK3MAloS63ceZ4Kw5SU2r3kL1iohoC7x6K8uxA1GEh3/n7BD
	lIhI7HvxjhHkBAmBt+wS7z+sA+tlERCQ+Db5EAtEr6zEpgNQD0tKHFxxg2UCo8QsJJtnIdk8
	C8nmWUhWLGBkWcUomlqQXFCclF5kqFecmFtcmpeul5yfu4kREr29OxhvH7A+xJgMtH4is5Ro
	cj4w+vNK4g2NzYwsTE1MjY3MLc1IE1YS51VrsQ4UEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnV
	wJh12b8+u2F7p+zNDV4bOQRPbpI5HhR97nuDecuDz4e+tadkLdtVOEtZLI7f8vmhxsvNsb+W
	nOLOOPtq59QdkzZ79iiceHyvt9zy62erX5+3XN44OcR5iiMXw/x/MQIHb1pxuDYvm7jvtGZu
	4lWN+VrP2Tc8DU09Ys/he7j9Z5jzy1+8oruVJ3sqsRRnJBpqMRcVJwIAOBfNbPQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHKsWRmVeSWpSXmKPExsVy+t9jAV3p7UmBBju/mVg0XA2x+PVuJrvF
	5V1z2Cw+9x5htJhxfh+TxZOHfWwWx2YsYXRg99g56y67x+I9L5k87lzbw+bRt2UVo8fnTXIB
	rFENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QGco
	KZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwnrGDP+XNzHUrBKoGLHxX1MDYwH
	eboYOTkkBEwkXveeYISwxSQu3FvPBmILCSxilFi9KKCLkQvI/ssoMfv4ErAiNgENicPvn7GD
	2CICvhL9226wgxQxC2xglLgy5xg7REcLo8S1JctZQKo4BTwk3i/cC9YtLBAuMbttG3MXIwcH
	i4CqxJalXCBhXgFbiQ//OtkhbEGJH5PvgbUyC2hJrN95nAnClpfYvOYtWKuEgLrEo7+6EDcY
	SXT8f8IOUSIise/FO8YJjEKzkEyahWTSLCSTZiFpWcDIsopRNLUguaA4KT3XSK84Mbe4NC9d
	Lzk/dxMjODU8k97BuKrB4hCjAAejEg/vga+JgUKsiWXFlbmHGCU4mJVEeA8vTgoU4k1JrKxK
	LcqPLyrNSS0+xJgM9OdEZinR5Hxg2soriTc0NjEzsjQyszAyMTcnTVhJnPdgq3WgkEB6Yklq
	dmpqQWoRzBYmDk6pBkY578TQ5Hx1hQWz9nDY88cyyLSez7q12H/fjBqd6b+Ck3oTiqUWh/mJ
	dIt2nb/C18o4O6ra9X7oDGdJBfu0Tmtrzkg2gZkX393h2P6ujcP8ju5En1dzS99ckOQ6Z2v2
	xt58SUkWk4b+kZtz3LZM+RXvPqOLf3PLth+POL1MPivM1Ncs/m33TImlOCPRUIu5qDgRANyz
	KLBRAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amit Daniel Kachhap wrote:
> 
> This patch adds device node for TMU controller. There are 3
> instances of the controllers so 3 nodes are created.
> 
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> ---
>  arch/arm/boot/dts/exynos5440.dtsi |   43
> +++++++++++++++++++++++++++++++++++++
>  1 files changed, 43 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/exynos5440.dtsi
> b/arch/arm/boot/dts/exynos5440.dtsi
> index 5f3562a..b74ce9f 100644
> --- a/arch/arm/boot/dts/exynos5440.dtsi
> +++ b/arch/arm/boot/dts/exynos5440.dtsi
> @@ -16,6 +16,12 @@
> 
>  	interrupt-parent = <&gic>;
> 
> +	aliases {
> +		tmuctrl0 = &tmuctrl_0;
> +		tmuctrl1 = &tmuctrl_1;
> +		tmuctrl2 = &tmuctrl_2;
> +	};
> +
>  	gic:interrupt-controller@2E0000 {
>  		compatible = "arm,cortex-a15-gic";
>  		#interrupt-cells = <3>;
> @@ -156,4 +162,41 @@
>  		reg = <0x130000 0x1000>;
>  		interrupts = <0 17 0>, <0 16 0>;
>  	};
> +
> +	tmu_ctrl_info: tmu-ctrl-info {
> +		gain = <5>;
> +		reference-voltage = <16>;
> +		noise-cancel-mode = <4>;
> +		cal-type = <2>;
> +		cal-mode = <0>;
> +		efuse-value = <0x5b2c>;
> +		threshold-falling = <5>;
> +	};
> +
> +	tmuctrl_0: tmuctrl@160118 {
> +		compatible = "samsung,exynos5440-tmu";
> +		reg = <0x160118 0x300>;
> +		interrupts = <0 58 0>;
> +		clocks = <&clock 8>;

Should be:
+		clocks = <&clock 21>;

> +		clock-names = "tmu_apbif";
> +		tmu-ctrl-data = <&tmu_ctrl_info>;
> +	};
> +
> +	tmuctrl_1: tmuctrl@16011C {
> +		compatible = "samsung,exynos5440-tmu";
> +		reg = <0x16011C 0x300>;
> +		interrupts = <0 58 0>;
> +		clocks = <&clock 8>;

+		clocks = <&clock 21>;

> +		clock-names = "tmu_apbif";
> +		tmu-ctrl-data = <&tmu_ctrl_info>;
> +	};
> +
> +	tmuctrl_2: tmuctrl@160120 {
> +		compatible = "samsung,exynos5440-tmu";
> +		reg = <0x160120 0x300>;
> +		interrupts = <0 58 0>;
> +		clocks = <&clock 8>;

+		clocks = <&clock 21>;

> +		clock-names = "tmu_apbif";
> +		tmu-ctrl-data = <&tmu_ctrl_info>;
> +	};
>  };
> --
> 1.7.1

- Kukjin

