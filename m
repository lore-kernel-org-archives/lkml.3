Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277AbaDWJ1C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 05:27:02 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:41786 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbaDWJ0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 05:26:53 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-52-5357875c0d3d
From: Anton Tikhomirov <av.tikhomirov@samsung.com>
To: "'Vivek Gautam'" <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, gregkh@linuxfoundation.org,
        stern@rowland.harvard.edu, balbi@ti.com, kgene.kim@samsung.com
References: <1398082604-3013-1-git-send-email-gautam.vivek@samsung.com>
 <1398082604-3013-3-git-send-email-gautam.vivek@samsung.com>
In-reply-to: <1398082604-3013-3-git-send-email-gautam.vivek@samsung.com>
Subject: RE: [PATCH 3/3] usb: dwc3-exynos: Make provision for vdd regulators
Date: Wed, 23 Apr 2014 18:26:51 +0900
Message-id: <00bf01cf5ed6$28de18d0$7a9a4a70$%tikhomirov@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9dW6KxOS23wqDTQlqsselwwfmWuABeT/YQ
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsVy+t8zI92Y9vBggwObWC0O3q+3aLtykN2i
	efF6NoveBVfZLDY9vsZqcXnXHDaL2Uv6WSxmnN/HZLFoWSuzxYTfF9gcuDz2z13D7rF5Sb3H
	7Ls/GD36tqxi9Dh+YzuTx+dNcgFsUVw2Kak5mWWpRfp2CVwZX65oFGwSqbjy+R1rA+NdgS5G
	Tg4JAROJo03HWSBsMYkL99azdTFycQgJLGOU+Nb2gxWm6O7LQ+wQiUWMEh2P94MlhAT+MUo0
	bKwDsdkEjCReHtzIDGKLCORKzHq7khmkgVngEKPE790tUN2tjBITtzxgAqniFPCQeNq8FswW
	FvCRWPZrNpjNIqAqsfreW7CbeAVcJH5Mnc0IYQtK/Jh8DyzOLGAg8X5WHyuELS+xec1boG0c
	QKeqSzz6qwtxhJHE09032CBKxCUmPXgIdoOEQCeHxMRLp1ggdglIfJt8iAWiV1Zi0wFmiI8l
	JQ6uuMEygVFiFpLNs5BsnoVk8ywkKxYwsqxiFE0tSC4oTkovMtYrTswtLs1L10vOz93ECInx
	/h2Mdw9YH2JMBlo/kVlKNDkfmCLySuINjc2MLExNTI2NzC3NSBNWEue9/zApSEggPbEkNTs1
	tSC1KL6oNCe1+BAjEwenVAPjhv/3239dYIjhn/J8zxcz+7JdPNLZ3pvNw9Y3JZyte2deYWO8
	4ePGuAXzeD+d1vh6OvuC+OuFt6bd2LKd90X2vfPWHw/7dD6L1O1ae9xh4lf3qcs+vH1g+G+2
	63rLaUe94tmjq7Il28PPZn87vbbXZCnv86/tsys4NvasnhVjq+Qh21D37abldyWW4oxEQy3m
	ouJEAMebWIkHAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAKsWRmVeSWpSXmKPExsVy+t9jAd2Y9vBgg4s8Fgfv11u0XTnIbtG8
	eD2bRe+Cq2wWmx5fY7W4vGsOm8XsJf0sFjPO72OyWLSsldliwu8LbA5cHvvnrmH32Lyk3mP2
	3R+MHn1bVjF6HL+xncnj8ya5ALaoBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sL
	cyWFvMTcVFslF58AXbfMHKDDlBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGE
	dYwZX65oFGwSqbjy+R1rA+NdgS5GTg4JAROJuy8PsUPYYhIX7q1n62Lk4hASWMQo0fF4PytI
	QkjgH6NEw8Y6EJtNwEji5cGNzCC2iECuxKy3K5lBGpgFDjFK/N7dwg7R3cooMXHLAyaQKk4B
	D4mnzWvBbGEBH4llv2aD2SwCqhKr771lAbF5BVwkfkydzQhhC0r8mHwPLM4sYCDxflYfK4Qt
	L7F5zVugbRxAp6pLPPqrC3GEkcTT3TfYIErEJSY9eMg+gVFoFpJJs5BMmoVk0iwkLQsYWVYx
	iqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBKePZ9I7GFc1WBxiFOBgVOLhlVgeFizEmlhWXJkL
	9DkHs5II77G68GAh3pTEyqrUovz4otKc1OJDjMlAj05klhJNzgemtrySeENjEzMjSyMzCyMT
	c3PShJXEeQ+2WgcKCaQnlqRmp6YWpBbBbGHi4JRqYPRrO6d8nPei8Um1WzuSn141iOD+krzW
	vLlqS8rbMM4/ifLuIpbT5Fc9K/6iIr2vdmOVoWoLe2PFxfp9gRMvTuCdNLtL+PfeXX3a2ose
	sW48feGXJA/TXAeua20/eDa2n7drDz+q/ZvtdejHHwX+cXOXO5+qNGY7dva5Y7m5Tpv8v8XT
	b33aVK7EUpyRaKjFXFScCACscRI4YwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> -----Original Message-----
> From: Vivek Gautam [mailto:gautamvivek1987@gmail.com] On Behalf Of
> Vivek Gautam
> Sent: Monday, April 21, 2014 9:17 PM
> To: linux-usb@vger.kernel.org; linux-samsung-soc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org; linux-omap@vger.kernel.org; linux-
> arm-kernel@lists.infradead.org; gregkh@linuxfoundation.org;
> stern@rowland.harvard.edu; balbi@ti.com; kgene.kim@samsung.com; Vivek
> Gautam; Anton Tikhomirov
> Subject: [PATCH 3/3] usb: dwc3-exynos: Make provision for vdd
> regulators
> 
> Facilitate getting required 3.3V and 1.0V VDD supply for
> DWC3 controller on Exynos.
> 
> With patches for regulators' nodes merged in 3.15:
> c8c253f ARM: dts: Add regulator entries to smdk5420
> 275dcd2 ARM: dts: add max77686 pmic node for smdk5250,
> 
> certain perripherals will now need to ensure that,
> they request VDD regulators in their drivers, and enable
> them so as to make them working.
> 
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> Cc: Anton Tikhomirov <av.tikhomirov@samsung.com>
> ---
> 
> Based on 'usb-next' branch of Greg's USB tree.
> Also cleanly applies on 'next' branch of Balbi's USB tree.
> 
>  drivers/usb/dwc3/dwc3-exynos.c |   51
> ++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 49 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/dwc3/dwc3-exynos.c b/drivers/usb/dwc3/dwc3-
> exynos.c
> index 28c8ad7..c9d9102 100644
> --- a/drivers/usb/dwc3/dwc3-exynos.c
> +++ b/drivers/usb/dwc3/dwc3-exynos.c
> @@ -27,6 +27,7 @@
>  #include <linux/usb/usb_phy_gen_xceiv.h>
>  #include <linux/of.h>
>  #include <linux/of_platform.h>
> +#include <linux/regulator/consumer.h>
> 
>  struct dwc3_exynos {
>  	struct platform_device	*usb2_phy;
> @@ -34,6 +35,8 @@ struct dwc3_exynos {
>  	struct device		*dev;
> 
>  	struct clk		*clk;
> +	struct regulator	*vdd33;
> +	struct regulator	*vdd10;
>  };
> 
>  static int dwc3_exynos_register_phys(struct dwc3_exynos *exynos)
> @@ -144,20 +147,46 @@ static int dwc3_exynos_probe(struct
> platform_device *pdev)
> 
>  	clk_prepare_enable(exynos->clk);
> 
> +	exynos->vdd33 = devm_regulator_get(dev, "vdd33");
> +	if (IS_ERR(exynos->vdd33)) {
> +		ret = PTR_ERR(exynos->vdd33);
> +		goto err2;

Is regulator property mandatory for dwc3-exynos? If it is not
and device tree doesn't provide it, dwc3-exynos driver probe shouldn't
fail here.

> +	}
> +	ret = regulator_enable(exynos->vdd33);
> +	if (ret) {
> +		dev_err(dev, "Failed to enable VDD33 supply\n");
> +		goto err2;
> +	}
> +

Thanks

