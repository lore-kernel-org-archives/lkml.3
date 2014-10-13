Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315AbaJMFGr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 01:06:47 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:30772 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbaJMFGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 01:06:43 -0400
X-AuditID: cbfee68d-f79296d000004278-f6-543b5de09de2
From: Anton Tikhomirov <av.tikhomirov@samsung.com>
To: "'Vivek Gautam'" <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, balbi@ti.com, kgene.kim@samsung.com,
        mark.rutland@arm.com, pawel.moll@arm.com, robh+dt@kernel.org,
        kishon@ti.com
References: <1412677176-3850-1-git-send-email-gautam.vivek@samsung.com>
 <1412677176-3850-4-git-send-email-gautam.vivek@samsung.com>
In-reply-to: <1412677176-3850-4-git-send-email-gautam.vivek@samsung.com>
Subject: RE: [PATCH v2 3/4] phy: exynos5-usbdrd: Add facility for VBUS-BOOST-5V
 supply
Date: Mon, 13 Oct 2014 14:06:39 +0900
Message-id: <00f301cfe6a3$78e90ab0$6abb2010$%tikhomirov@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/iGHXFdMmrmRnFS0uLpeX7dDztSQEinfOA
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsVy+t8zA90HsdYhBqs38FkcvF9vMf/IOVaL
	tisH2S2aF69ns+hdcJXN4sLTHjaLy7vmsFnMXtLPYjHj/D4mi0XLWpktll6/yGQxYfpaFovW
	vUfYHXg91sxbw+ixaVUnm8f+uWvYPfq2rGL0OH5jO5PH501yAWxRXDYpqTmZZalF+nYJXBn3
	D51iK7gpWTH51QvGBsY9Il2MnBwSAiYSPSdPMkPYYhIX7q1nA7GFBJYxSjS/DIap2XF7C1Cc
	Cyi+iFHi/rkmRgjnH6NEb/M6FpAqNgEjiZcHN4JNEhHwkLh7bDk7SBGzQD+TxOXdS5ggOloZ
	Jfo6ZoDt4ASq6v+5lRXEFhaIkJi0bCJYN4uAqsS63duYQGxeAReJjmUzmCFsQYkfk++BbWMW
	MJB4P6uPFcKWl9i85i1QDQfQreoSj/7qQhxhJHFm3zp2iBJxiUkPHoIdJCEwl0Ni2ZxVjBC7
	BCS+TT7EAtErK7HpADQoJCUOrrjBMoFRYhaSzbOQbJ6FZPMsJCsWMLKsYhRNLUguKE5KLzLU
	K07MLS7NS9dLzs/dxAhJAr07GG8fsD7EKMDBqMTDa/HHKkSINbGsuDL3EKMp0EUTmaVEk/OB
	qSavJN7Q2MzIwtTE1NjI3NJMSZxXUepnsJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQbGbaWL
	NgqWfme0Os02146Bf6nrj9SHe6VeVDCEFt6QMpY1eaW/aP3mP7H631xlX1ocW5Z3lUWKO9r8
	m2rjjnvTLGQ5vj69yH1x05S9XFF7Vq/8fPbMd+XdeQsjFeYr+UjNORjCNV3S/+vc5fbJR6/t
	kgzvKXYS7T1XFL6+bL+07+XJfskvGeaJKLEUZyQaajEXFScCABtffTH9AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jAd0HsdYhBmdncVocvF9vMf/IOVaL
	tisH2S2aF69ns+hdcJXN4sLTHjaLy7vmsFnMXtLPYjHj/D4mi0XLWpktll6/yGQxYfpaFovW
	vUfYHXg91sxbw+ixaVUnm8f+uWvYPfq2rGL0OH5jO5PH501yAWxRDYw2GamJKalFCql5yfkp
	mXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUCXKimUJeaUAoUCEouLlfTtME0I
	DXHTtYBpjND1DQmC6zEyQAMJ6xgz7h86xVZwU7Ji8qsXjA2Me0S6GDk5JARMJHbc3sIGYYtJ
	XLi3Hsjm4hASWMQocf9cEyOE849Rord5HQtIFZuAkcTLgxuZQWwRAQ+Ju8eWs4MUMQv0M0lc
	3r2ECaKjlVGir2MG2FxOoKr+n1tZQWxhgQiJScsmgnWzCKhKrNu9jQnE5hVwkehYNoMZwhaU
	+DH5Htg2ZgEDifez+lghbHmJzWveAtVwAN2qLvHory7EEUYSZ/atY4coEZeY9OAh+wRGoVlI
	Js1CMmkWkkmzkLQsYGRZxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iRGcZJ5J72Bc1WBxiFGA
	g1GJh9fij1WIEGtiWXFl7iFGCQ5mJRHetzbWIUK8KYmVValF+fFFpTmpxYcYTYEencgsJZqc
	D0yAeSXxhsYmZkaWRmYWRibm5krivAdbrQOFBNITS1KzU1MLUotg+pg4OKUaGLk4N+347CU5
	qT6t9+gCVnMH/fS9/DFzfs3TZ2jPO/Pq7Nn7+nJrp8zlSq814NuzW2BRl4o0++Hdn/1ibz7j
	kllisfNI1deJJTWr0/V+zZxWxhXFwLL4dejNE5KdKe2SrEEHau6tuMJjXj210+7Luk/XV7vw
	PLExjH33+kmR2Lkz1v37OB4lGCuxFGckGmoxFxUnAgAVSPwNSAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

> Some Exynos SoCs have a separate regulator controlling a

I guess you meant the Exynos based *boards* instead of SoCs,
since Exynos SoCs don't have any boost regulators.

> Boost 5V supply which goes as input for VBUS regulator.
> So adding a control for the same in driver, to enable
> vbus supply on the port.
> 
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> ---
>  drivers/phy/phy-exynos5-usbdrd.c |   30 ++++++++++++++++++++++++++++--
>  1 file changed, 28 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/phy/phy-exynos5-usbdrd.c b/drivers/phy/phy-
> exynos5-usbdrd.c
> index 013ee84..57e8a0a 100644
> --- a/drivers/phy/phy-exynos5-usbdrd.c
> +++ b/drivers/phy/phy-exynos5-usbdrd.c
> @@ -176,6 +176,7 @@ struct exynos5_usbdrd_phy {
>  	u32 extrefclk;
>  	struct clk *ref_clk;
>  	struct regulator *vbus;
> +	struct regulator *vbus_boost;
>  };
> 
>  static inline
> @@ -455,11 +456,20 @@ static int exynos5_usbdrd_phy_power_on(struct phy
> *phy)
>  	clk_prepare_enable(phy_drd->ref_clk);
> 
>  	/* Enable VBUS supply */
> +	if (phy_drd->vbus_boost) {
> +		ret = regulator_enable(phy_drd->vbus_boost);
> +		if (ret) {
> +			dev_err(phy_drd->dev,
> +				"Failed to enable VBUS boost supply\n");
> +			goto fail_vbus;
> +		}
> +	}
> +
>  	if (phy_drd->vbus) {
>  		ret = regulator_enable(phy_drd->vbus);
>  		if (ret) {
>  			dev_err(phy_drd->dev, "Failed to enable VBUS
> supply\n");
> -			goto fail_vbus;
> +			goto fail_vbus_boost;
>  		}
>  	}
> 
> @@ -468,6 +478,10 @@ static int exynos5_usbdrd_phy_power_on(struct phy
> *phy)
> 
>  	return 0;
> 
> +fail_vbus_boost:
> +	if (phy_drd->vbus_boost)
> +		regulator_disable(phy_drd->vbus_boost);
> +
>  fail_vbus:
>  	clk_disable_unprepare(phy_drd->ref_clk);
>  	clk_disable_unprepare(phy_drd->pipeclk);
> @@ -489,6 +503,8 @@ static int exynos5_usbdrd_phy_power_off(struct phy
> *phy)
>  	/* Disable VBUS supply */
>  	if (phy_drd->vbus)
>  		regulator_disable(phy_drd->vbus);
> +	if (phy_drd->vbus_boost)
> +		regulator_disable(phy_drd->vbus_boost);
> 
>  	clk_disable_unprepare(phy_drd->ref_clk);
>  	clk_disable_unprepare(phy_drd->pipeclk);
> @@ -644,7 +660,7 @@ static int exynos5_usbdrd_phy_probe(struct
> platform_device *pdev)
>  		break;
>  	}
> 
> -	/* Get Vbus regulator */
> +	/* Get Vbus regulators */
>  	phy_drd->vbus = devm_regulator_get(dev, "vbus");
>  	if (IS_ERR(phy_drd->vbus)) {
>  		ret = PTR_ERR(phy_drd->vbus);
> @@ -655,6 +671,16 @@ static int exynos5_usbdrd_phy_probe(struct
> platform_device *pdev)
>  		phy_drd->vbus = NULL;
>  	}
> 
> +	phy_drd->vbus_boost = devm_regulator_get(dev, "vbus-boost");
> +	if (IS_ERR(phy_drd->vbus_boost)) {
> +		ret = PTR_ERR(phy_drd->vbus_boost);
> +		if (ret == -EPROBE_DEFER)
> +			return ret;
> +
> +		dev_warn(dev, "Failed to get VBUS boost supply
> regulator\n");
> +		phy_drd->vbus_boost = NULL;
> +	}
> +
>  	dev_vdbg(dev, "Creating usbdrd_phy phy\n");
> 
>  	for (i = 0; i < EXYNOS5_DRDPHYS_NUM; i++) {
> --
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

