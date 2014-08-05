Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933381AbaHEK6P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 06:58:15 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:44938 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932067AbaHEK6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 06:58:10 -0400
X-AuditID: cbfee690-b7f526d000003627-f5-53e0b8bf2c86
From: Jingoo Han <jg1.han@samsung.com>
To: "'Vivek Gautam'" <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org
Cc: gregkh@linuxfoundation.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kgene.kim@samsung.com, sachin.kamat@samsung.com,
        "'Alan Stern'" <stern@rowland.harvard.edu>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1407235148-31790-1-git-send-email-gautam.vivek@samsung.com>
In-reply-to: <1407235148-31790-1-git-send-email-gautam.vivek@samsung.com>
Subject: Re: [PATCH RESEND] usb: ehci/ohci-exynos: Fix PHY getting sequence
Date: Tue, 05 Aug 2014 19:58:07 +0900
Message-id: <000d01cfb09c$239a8670$6acf9350$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+wmYOEdoQUqI49Rv+ogF3j2sCP1QAAi8uQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHIsWRmVeSWpSXmKPExsVy+t8zQ939Ox4EG/ydam7RduUgu0Xz4vVs
	FpcXXmK16F1wlc1i0+NrrBaXd81hs5hxfh+TxaJlrcwWVy6dYrOY8PsCmwOXx/65a9g9Ni+p
	95h99wejR9+WVYwenzfJBbBGcdmkpOZklqUW6dslcGXsfLWTseCUdsXh6aUNjL1KXYycHBIC
	JhIzjr5ihLDFJC7cW8/WxcjFISSwjFFi7cNtzDBFNxbOZgexhQSmM0rc+xsCUfSbUeL4+0tg
	CTYBNYkvXw6D2SICHhJ3jy1nByliFuhikmi+fIIZottD4vS5DWBFnAKeEke69oOtFhbwlmj9
	eRqshkVAVWL5xvUsXYwcHLwCthL/2sxAwrwCghI/Jt9jAbGZBbQk1u88zgRhy0tsXvOWGaRc
	QkBd4tFfXYgTjCQaj05jgygRkdj34h0jyDkSAo0cEn9n7GWCWCUg8W3yIRaIXlmJTQeg/pWU
	OLjiBssERolZSDbPQrJ5FpLNs5CsWMDIsopRNLUguaA4Kb3IRK84Mbe4NC9dLzk/dxMjJK4n
	7GC8d8D6EGMy0PqJzFKiyfnAtJBXEm9obGZkYWpiamxkbmlGmrCSOK/ao6QgIYH0xJLU7NTU
	gtSi+KLSnNTiQ4xMHJxSDYyKq15WnOI5+aFRKeTzrO8m4t/0Nn/7tXTBwvf7DiU3ZqrdqLzu
	b7Qkqn89g4D3cm/Osg7f44VJZs/eccQx9lelTFv9Japp1qEZ3IV9F7hvOmauKjMW1eq9JJPQ
	GJ6R8uTNSf+9K+e8UTj2Tql248dJU0/GpCT8V2YtzljubDnp546ld5VDjwQqsRRnJBpqMRcV
	JwIAVw+ucAEDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t9jQd39Ox4EGxz8ZWjRduUgu0Xz4vVs
	FpcXXmK16F1wlc1i0+NrrBaXd81hs5hxfh+TxaJlrcwWVy6dYrOY8PsCmwOXx/65a9g9Ni+p
	95h99wejR9+WVYwenzfJBbBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp
	5CXmptoqufgE6Lpl5gBdpaRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPM
	2PlqJ2PBKe2Kw9NLGxh7lboYOTkkBEwkbiyczQ5hi0lcuLeeDcQWEpjOKHHvb0gXIxeQ/ZtR
	4vj7S2BFbAJqEl++HAazRQQ8JO4eW84OUsQs0MUk0Xz5BDNEt4fE6XMbwIo4BTwljnTtZwSx
	hQW8JVp/ngarYRFQlVi+cT1LFyMHB6+ArcS/NjOQMK+AoMSPyfdYQGxmAS2J9TuPM0HY8hKb
	17xlBimXEFCXePRXF+IEI4nGo9PYIEpEJPa9eMc4gVFoFpJJs5BMmoVk0iwkLQsYWVYxiqYW
	JBcUJ6XnGuoVJ+YWl+al6yXn525iBCeNZ1I7GFc2WBxiFOBgVOLhFVC7HyzEmlhWXJl7iFGC
	g1lJhFdizYNgId6UxMqq1KL8+KLSnNTiQ4ymQH9OZJYSTc4HJrS8knhDYxMzI0sjMwsjE3Nz
	JXHeA63WgUIC6YklqdmpqQWpRTB9TBycUg2MCbvvrla1WW6RpDB5r6pt4Izu06t+T061+F69
	xnyneoWfuMPRfldlJv+aa/Z+13fPXsvs+/L21+2e1x8mn+jyvBwWUThnvvH921IybQaKH8tU
	lvgqs+fUr5effNSyaALfxhh/tmDr08/qo2oecYrP3ScbWPTmx+20mVW2le+/ds0MWRyctvmw
	EktxRqKhFnNRcSIAAnVKVjADAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 05, 2014 7:39 PM, Vivek Gautam wrote:
> 
> Since we want to keep support for both older usb-phys as well as the
> newer generic phys, lets first get the generic PHYs and fallback to
> older USB-PHYs only when we fail to get the former.
> This should fix the issue with ehci-exynos and ohci-exynos, wherein
> in the absence of SAMSUNG_USB2PHY config symbol, we end up getting
> the NOP_USB_XCEIV phy when the same is enabled. And thus the PHYs
> are not configured properly.
> 
> Reported-by: Sachin Kamat <sachin.kamat@samsung.com>
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Jingoo Han <jg1.han@samsung.com>

Acked-by: Jingoo Han <jg1.han@samsung.com>

Right, we would get the generic PHYs first, then get the older
usb-phys. Then, the older one will be removed from the kernel.
Thank you.

Best regards,
Jingoo Han

> ---
> 
> Based on 'usb-next' branch.
> Resending it after adding 'Reported-by' tag.
> 
>  drivers/usb/host/ehci-exynos.c |   40 +++++++++++++++++-----------------
>  drivers/usb/host/ohci-exynos.c |   47 +++++++++++++++++++---------------------
>  2 files changed, 42 insertions(+), 45 deletions(-)
> 
> diff --git a/drivers/usb/host/ehci-exynos.c b/drivers/usb/host/ehci-exynos.c
> index cda0a2f..2eed9a4 100644
> --- a/drivers/usb/host/ehci-exynos.c
> +++ b/drivers/usb/host/ehci-exynos.c
> @@ -62,18 +62,6 @@ static int exynos_ehci_get_phy(struct device *dev,
>  	int phy_number;
>  	int ret = 0;
> 
> -	exynos_ehci->phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
> -	if (IS_ERR(exynos_ehci->phy)) {
> -		ret = PTR_ERR(exynos_ehci->phy);
> -		if (ret != -ENXIO && ret != -ENODEV) {
> -			dev_err(dev, "no usb2 phy configured\n");
> -			return ret;
> -		}
> -		dev_dbg(dev, "Failed to get usb2 phy\n");
> -	} else {
> -		exynos_ehci->otg = exynos_ehci->phy->otg;
> -	}
> -
>  	for_each_available_child_of_node(dev->of_node, child) {
>  		ret = of_property_read_u32(child, "reg", &phy_number);
>  		if (ret) {
> @@ -90,15 +78,27 @@ static int exynos_ehci_get_phy(struct device *dev,
> 
>  		phy = devm_of_phy_get(dev, child, NULL);
>  		of_node_put(child);
> -		if (IS_ERR(phy)) {
> -			ret = PTR_ERR(phy);
> -			if (ret != -ENOSYS && ret != -ENODEV) {
> -				dev_err(dev, "no usb2 phy configured\n");
> -				return ret;
> -			}
> -			dev_dbg(dev, "Failed to get usb2 phy\n");
> -		}
> +		if (IS_ERR(phy))
> +			/* Lets fallback to older USB-PHYs */
> +			goto usb_phy_old;
>  		exynos_ehci->phy_g[phy_number] = phy;
> +		/* Make the older PHYs unavailable */
> +		exynos_ehci->phy = ERR_PTR(-ENXIO);
> +	}
> +
> +	return 0;
> +
> +usb_phy_old:
> +	exynos_ehci->phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
> +	if (IS_ERR(exynos_ehci->phy)) {
> +		ret = PTR_ERR(exynos_ehci->phy);
> +		if (ret != -ENXIO && ret != -ENODEV) {
> +			dev_err(dev, "no usb2 phy configured\n");
> +			return ret;
> +		}
> +		dev_dbg(dev, "Failed to get usb2 phy\n");
> +	} else {
> +		exynos_ehci->otg = exynos_ehci->phy->otg;
>  	}
> 
>  	return ret;
> diff --git a/drivers/usb/host/ohci-exynos.c b/drivers/usb/host/ohci-exynos.c
> index a72ab8f..7c48e3f 100644
> --- a/drivers/usb/host/ohci-exynos.c
> +++ b/drivers/usb/host/ohci-exynos.c
> @@ -51,27 +51,12 @@ static int exynos_ohci_get_phy(struct device *dev,
>  	int phy_number;
>  	int ret = 0;
> 
> -	exynos_ohci->phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
> -	if (IS_ERR(exynos_ohci->phy)) {
> -		ret = PTR_ERR(exynos_ohci->phy);
> -		if (ret != -ENXIO && ret != -ENODEV) {
> -			dev_err(dev, "no usb2 phy configured\n");
> -			return ret;
> -		}
> -		dev_dbg(dev, "Failed to get usb2 phy\n");
> -	} else {
> -		exynos_ohci->otg = exynos_ohci->phy->otg;
> -	}
> -
>  	/*
>  	 * Getting generic phy:
>  	 * We are keeping both types of phys as a part of transiting OHCI
>  	 * to generic phy framework, so as to maintain backward compatibilty
> -	 * with old DTB.
> -	 * If there are existing devices using DTB files built from them,
> -	 * to remove the support for old bindings in this driver,
> -	 * we need to make sure that such devices have their DTBs
> -	 * updated to ones built from new DTS.
> +	 * with old DTB too.
> +	 * We fallback to older USB-PHYs when we fail to get generic PHYs.
>  	 */
>  	for_each_available_child_of_node(dev->of_node, child) {
>  		ret = of_property_read_u32(child, "reg", &phy_number);
> @@ -89,15 +74,27 @@ static int exynos_ohci_get_phy(struct device *dev,
> 
>  		phy = devm_of_phy_get(dev, child, NULL);
>  		of_node_put(child);
> -		if (IS_ERR(phy)) {
> -			ret = PTR_ERR(phy);
> -			if (ret != -ENOSYS && ret != -ENODEV) {
> -				dev_err(dev, "no usb2 phy configured\n");
> -				return ret;
> -			}
> -			dev_dbg(dev, "Failed to get usb2 phy\n");
> -		}
> +		if (IS_ERR(phy))
> +			/* Lets fallback to older USB-PHYs */
> +			goto usb_phy_old;
>  		exynos_ohci->phy_g[phy_number] = phy;
> +		/* Make the older PHYs unavailable */
> +		exynos_ohci->phy = ERR_PTR(-ENXIO);
> +	}
> +
> +	return 0;
> +
> +usb_phy_old:
> +	exynos_ohci->phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
> +	if (IS_ERR(exynos_ohci->phy)) {
> +		ret = PTR_ERR(exynos_ohci->phy);
> +		if (ret != -ENXIO && ret != -ENODEV) {
> +			dev_err(dev, "no usb2 phy configured\n");
> +			return ret;
> +		}
> +		dev_dbg(dev, "Failed to get usb2 phy\n");
> +	} else {
> +		exynos_ohci->otg = exynos_ohci->phy->otg;
>  	}
> 
>  	return ret;
> --
> 1.7.10.4

