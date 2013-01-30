Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751401Ab3A3FGd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 00:06:33 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:48728 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab3A3FGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 00:06:31 -0500
X-AuditID: cbfee61b-b7fb06d000000f28-45-5108aa56f09a
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Vivek Gautam'" <gautam.vivek@samsung.com>,
        linux-samsung-soc@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, grant.likely@secretlab.ca,
        dianders@chromium.org, balbi@ti.com, thomas.abraham@linaro.org,
        sylvester.nawrocki@gmail.com, tomasz.figa@gmail.com,
        p.paneri@samsung.com
References: <1358868680-5757-1-git-send-email-gautam.vivek@samsung.com>
 <1358868680-5757-2-git-send-email-gautam.vivek@samsung.com>
In-reply-to: <1358868680-5757-2-git-send-email-gautam.vivek@samsung.com>
Subject: RE: [PATCH v2 1/2] ARM: Exynos5250: Enabling samsung-usbphy driver
Date: Tue, 29 Jan 2013 21:06:22 -0800
Message-id: <076f01cdfea7$8e752d90$ab5f88b0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQG7I7HiR5F9lZg6OQOiNsj3cWXGQgK7eW6amHEqqtA=
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsVy+t8zfd2wVRyBBj9/cFtc3jWHzWLG+X1M
	FouWtTI7MHt83iQXwBjFZZOSmpNZllqkb5fAlXHv5SnGgl7Oik+nGlkbGL+zdTFyckgImEjc
	nvoSyhaTuHBvPZDNxSEksIxR4uPb1+wwRXsmdTJDJBYxSqyfv40JwvnLKPG6fTILSBWbgIbE
	4ffPwDpEBAIkvt56wQhiMwv0MEmcnBwE0dDKKDG76wpYglPAQ+LonddgtrCAt8TNSY/BbBYB
	VYkrWyBqeAUsJU6tvM0KYQtK/Jh8jwViqJbE+p3HmSBseYnNa94yQ5yqILHjLMRMEQEriY+d
	X9ggasQlJj14yA5yhITAKnaJu61v2SGWCUh8m3wIaCgHUEJWYtMBqDmSEgdX3GCZwCgxC8nq
	WUhWz0KyehaSFQsYWVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525ihMSc9A7GVQ0WhxgFOBiV
	eHgXvGAPFGJNLCuuzD3EKMHBrCTCq6DGESjEm5JYWZValB9fVJqTWnyIMRno2InMUqLJ+cB0
	kFcSb2hsbGJmYmpibmlqbkqasJI4L+OpJwFCAumJJanZqakFqUUwW5g4OKUaGMU1t2c+uvS5
	93WDfe4/sVJ/lXyVBSJzOZ+EThea/+Wn5r7b6SZnMntvXZzUN73XOnbGt48/SuqM/DpPJa2x
	nx687qJozMFr87j335l3IeutSJmx2Oz7Vz9lLrxi3PSOsfvnVLPWE1fm/Jo0oWLPvs+r63Sz
	pl5/UH+0QJ+Tq/3eIfWvrSpr71xXYinOSDTUYi4qTgQAHQM0O/0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJKsWRmVeSWpSXmKPExsVy+t9jAd2wVRyBBu2f2S0u75rDZjHj/D4m
	i0XLWpkdmD0+b5ILYIxqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xN
	tVVy8QnQdcvMAZqvpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsY8y49/IU
	Y0EvZ8WnU42sDYzf2boYOTkkBEwk9kzqZIawxSQu3FsPFOfiEBJYxCixfv42JgjnL6PE6/bJ
	LCBVbAIaEoffP2MHsUUEAiS+3nrBCGIzC/QwSZycHATR0MooMbvrCliCU8BD4uid12C2sIC3
	xM1Jj8FsFgFViStbIGp4BSwlTq28zQphC0r8mHyPBWKolsT6nceZIGx5ic1r3kKdqiCx4yzE
	TBEBK4mPnV/YIGrEJSY9eMg+gVFoFpJRs5CMmoVk1CwkLQsYWVYxiqYWJBcUJ6XnGukVJ+YW
	l+al6yXn525iBEf0M+kdjKsaLA4xCnAwKvHwLnjBHijEmlhWXJl7iFGCg1lJhFdBjSNQiDcl
	sbIqtSg/vqg0J7X4EGMy0KcTmaVEk/OBySavJN7Q2MTMyNLIzMLIxNycNGElcV7GU08ChATS
	E0tSs1NTC1KLYLYwcXBKNTA6/9z84Y/d248l/55O+yJUtPloUc/KZvs3FXkSG30vFPc218p0
	fb1irHdtR77dVPcLlidLuE49yMhv8DTx4Lf9/va7cf/Ey51LnrE9ldvuej+fszzHoFqP21L8
	8t0NdnzafLvXWFzYfu6G7Mq6ZONV81+XO897svtHTuiFdZlTLqzT9PEPOBCjxFKckWioxVxU
	nAgAFVE06iwDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Gautam wrote:
> 
> Adding usbphy node for Exynos5250 along with the
> necessary device data to be parsed.
> 
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> ---
>  arch/arm/boot/dts/exynos5250.dtsi |   15 +++++++++++++++
>  1 files changed, 15 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/exynos5250.dtsi
> b/arch/arm/boot/dts/exynos5250.dtsi
> index 30485de..610e338 100644
> --- a/arch/arm/boot/dts/exynos5250.dtsi
> +++ b/arch/arm/boot/dts/exynos5250.dtsi
> @@ -275,6 +275,21 @@
>  		#size-cells = <0>;
>  	};
> 
> +	usbphy@12130000 {

Please put above node by order of address.

> +		compatible = "samsung,exynos5250-usbphy";
> +		reg = <0x12130000 0x100>;
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		ranges;
> +
> +		usbphy-sys {
> +			      /* USB device and host PHY_CONTROL registers
*/

Please add the binding documentation instead of comment here.

> +			reg = <0x10040704 0x8>,
> +			      /* USB2.0 PHY configuration register */
> +			      <0x10050230 0x4>;
> +		};
> +	};
> +
>  	amba {
>  		#address-cells = <1>;
>  		#size-cells = <1>;
> --
> 1.7.6.5

