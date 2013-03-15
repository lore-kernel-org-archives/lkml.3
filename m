Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851Ab3COD27 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 23:28:59 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:34919 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab3COD24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 23:28:56 -0400
X-AuditID: cbfee68e-b7f946d000001e37-f6-51429576c5f7
Date: Fri, 15 Mar 2013 03:28:54 +0000 (GMT)
From: Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH v2] usb: ehci-s5p: Use devm for requesting ehci_vbus_gpio
To: Doug Anderson <dianders@chromium.org>, Felipe Balbi <balbi@ti.com>
Cc: Alexander Graf <agraf@suse.de>, Vivek Gautam <gautam.vivek@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: jg1.han@samsung.com
MIME-version: 1.0
X-MTR: 20130315032806700@jg1.han
Msgkey: 20130315032806700@jg1.han
X-EPLocale: en_US.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130315032806700@jg1.han
X-ParentMTR: 
X-ArchiveUser: EV
X-CPGSPASS: Y
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <30907273.148421363318130664.JavaMail.weblogic@epv6ml07>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMJsWRmVeSWpSXmKPExsVy+t8zQ92yqU6BBqdviFpc3jWHzYHR4/Mm
	uQDGqAZGm8Si5IzMslSF1Lzk/JTMvHRbpdAQN10LJYWM/OISW6VoIwNjPSNTEz0jE3M9S4NY
	KyNTJYW8xNxUW6UKXaheJYWi5AKg2tzKYqABOal6UHG94tS8FIes/FKQS/SKE3OLS/PS9ZLz
	c5UUyhJzSoFGKOknTGXMOHtzGmvBE8GKpRt6WBoYlwh2MXJyCAkoSUw6uZcRxJYQMJG4+/MG
	O4QtJnHh3nq2LkYuoJpljBI3t51igSl6+3E3G0TzfEaJvbsKQWwWAVWJiVMmgzWzCahLTPjd
	DFYvLOAr8fTaDyYQW0TAR+Lk8tPMIEOZBdYwS0y7MJMRYpCsxL3Js5lBbF4BQYmTM59ALVOQ
	6Fw2G6iZAyiuKHHmRz1EWELizv39rBA2r8SM9qdQ5XIS076uYYawpSXOz9rACPPM4u+PoeL8
	Esdu7wAbCdL75H4wzJjdm7+wQdgCElPPHIRqVZVo2bgQahWfxJqFb6FWCUqcvtbNDNPbsPE3
	2OvMQFdO6X4IZWtJfPmxjw3dV7wCLhINi2czTmBUnoUkNQtJ+ywk7chqFjCyrGIUTS1ILihO
	Si8yQo7sTYyQNNi3g/HmAetDjPsZgXEykVlKNDkfmEjzSuINjc2MLExNTI2NzC3NKBQ2MbWw
	MDGiirCSOK9ai3WgkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBkb37f/vRfw3Pdzsl29+kc8v
	rro7TKfIzOdn7im3b/vWeL1l4NJYGC8tx3n7Y0nlb78ik5eXVd/IaF+wWdR1ilvg1NrFuQtk
	18jeDHKbI9X3x2F30haVa/Ub6iwtZp7fIaEyIbde465Ea/Xtx6tyX+sanv/7x3+rYcbewLsK
	An8Y+Le0uMqvWaXEUpyRaKjFXFScCAAlGf6x9gMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42I5/e/2DN2yqU6BBotuClpc3jWHzYHR4/Mm
	uQDGqAybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWgjA2M9I1MTPSNjAz1jy1grQwMDI1OgqoSM
	jLM3p7EWPBGsWLqhh6WBcYlgFyMnh5CAksSkk3sZQWwJAROJtx93s0HYYhIX7q1ng6iZzyix
	d1chiM0ioCoxccpkdhCbTUBdYsLvZhYQW1jAV+LptR9MILaIgI/EyeWnmbsYuTiYBdYwS0y7
	MJMRYpCsxL3Js5lBbF4BQYmTM5+wQCxTkOhcNhuomQMorihx5kc9RFhC4s79/awQNq/EjPan
	UOVyEtO+rmGGsKUlzs/awAhz8+Lvj6Hi/BLHbu8AGwnS++R+MMyY3Zu/QL0oIDH1zEGoVlWJ
	lo0LoVbxSaxZ+BZqlaDE6WvdzDC9DRt/g73ODHTllO6HULaWxJcf+9jQfcUr4CLRsHg24wRG
	uVlIUrOQtM9C0o6sZgEjyypG0dSC5ILipPQKY73ixNzi0rx0veT83E2M4AT1bPEOxv/nrQ8x
	CnAwKvHwOjx0DBRiTSwrrsw9xCjBwawkwrvrL1CINyWxsiq1KD++qDQntfgQYzIwAicyS4km
	5wOTZ15JvKGxsYmZiam5gYWBpTlpwkrivM9arQOFBNITS1KzU1MLUotgtjBxcEo1MDpyb3be
	7z2T66NR8b3Yzbqv+mxuhoVvUqxKX6w1K6X0HcurBvUTkY4JyTKvWXyPrXh4Y8XsdTNXXQ3/
	eOy7ZLjbbrG7Oyff/Jq8xO3M09BwXfZ+q41i2t5+h3qPTvpr9+997gRWWZV3K/O2ezLdmx+W
	I3t2Y/Be5zPmQhVWhk9slAM5/qftsFdiKc5INNRiLipOBADQiuuFlAMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r2F3T3xQ001985

On Friday, March 15, 2013 12:16 PM, Doug Anderson wrote:
> 
> The ehci_vbus_gpio is requested but never freed.  This can cause
> problems with deferred probes and would cause problems if
> s5p_ehci_remove was ever called.  Use devm to fix this.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>

Acked-by: Jingoo Han <jg1.han@samsung.com>


Best regards,
Jingoo Han

> ---
> Changes in v2:
> - &pdev->dev => dev elsewhere in s5p_setup_vbus_gpio()
> 
>  drivers/usb/host/ehci-s5p.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/usb/host/ehci-s5p.c b/drivers/usb/host/ehci-s5p.c
> index 20ebf6a..738490e 100644
> --- a/drivers/usb/host/ehci-s5p.c
> +++ b/drivers/usb/host/ehci-s5p.c
> @@ -92,20 +92,21 @@ static void s5p_ehci_phy_disable(struct s5p_ehci_hcd *s5p_ehci)
> 
>  static void s5p_setup_vbus_gpio(struct platform_device *pdev)
>  {
> +	struct device *dev = &pdev->dev;
>  	int err;
>  	int gpio;
> 
> -	if (!pdev->dev.of_node)
> +	if (!dev->of_node)
>  		return;
> 
> -	gpio = of_get_named_gpio(pdev->dev.of_node,
> -			"samsung,vbus-gpio", 0);
> +	gpio = of_get_named_gpio(dev->of_node, "samsung,vbus-gpio", 0);
>  	if (!gpio_is_valid(gpio))
>  		return;
> 
> -	err = gpio_request_one(gpio, GPIOF_OUT_INIT_HIGH, "ehci_vbus_gpio");
> +	err = devm_gpio_request_one(dev, gpio, GPIOF_OUT_INIT_HIGH,
> +				    "ehci_vbus_gpio");
>  	if (err)
> -		dev_err(&pdev->dev, "can't request ehci vbus gpio %d", gpio);
> +		dev_err(dev, "can't request ehci vbus gpio %d", gpio);
>  }
> 
>  static u64 ehci_s5p_dma_mask = DMA_BIT_MASK(32);
> --
> 1.8.1.3
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
