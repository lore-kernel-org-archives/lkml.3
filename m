Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518Ab3GKCmk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 22:42:40 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:43753 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229Ab3GKCmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 22:42:38 -0400
X-AuditID: cbfee68f-b7f436d000000f81-ef-51de1b9950ad
Message-id: <51DE1B99.6090403@samsung.com>
Date: Thu, 11 Jul 2013 11:42:33 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: myungjoo.ham@samsung.com, devicetree-discuss@lists.ozlabs.org,
        rob@landley.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kishon@ti.com, gg@slimlogic.co.uk
Subject: Re: [PATCH V3] extcon: palmas: Option to disable ID/VBUS detection
 based on platform
References: <1373448546-7531-1-git-send-email-ldewangan@nvidia.com>
In-reply-to: <1373448546-7531-1-git-send-email-ldewangan@nvidia.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsWyRsSkUHem9L1Ag8/rLS0OzH7IatG/xcXi
	wtMeNoul+1azWCxsW8JicXnXHDaL240r2CzWvZzO4sDh8Wr1TFaP8zMWMnr0Nr9j8+jbsorR
	Y+qUv4wex29sZ/L4vEkugD2KyyYlNSezLLVI3y6BK2PfRZeCd0IVd+c+ZG1gvMfbxcjJISFg
	ItHy/h4rhC0mceHeerYuRi4OIYGljBIbH39nhyn6O+cNVGI6o8SZ6XsZIZxXjBLvOpcDVXFw
	8ApoSVxe7ArSwCKgKrH4TxMLiM0GFN7/4gYbiC0qECaxcvoVsDivgKDEj8n3wGwRoJpvB/4x
	g8xkFtjEKLFq2ixmkISwQLzE30c/wc4TEnCWOHZ0C5jNKeAi8WX6E7ChzAI6Evtbp0HZ8hKb
	17wFGyQh8Ihd4ubiWUwQFwlIfJt8iAXkUAkBWYlNB5ghPpOUOLjiBssERrFZSG6ahWTsLCRj
	FzAyr2IUTS1ILihOSi8y1itOzC0uzUvXS87P3cQIjMnT/57172C8e8D6EGMy0MqJzFKiyfnA
	mM4riTc0NjOyMDUxNTYytzQjTVhJnFetxTpQSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA6Ow
	p0Riwebsptn2H3et2s++xnST0vVvlyffjPqXf1Fq5z/lbxw9Fm/uvFDWKFzP9TSC6V2P26Up
	gatY6h0mqpRv1zs1SVAjZG7t/8eLpydzTujTniv3pM1M7Ms1Vr0AxiM6Yhe8N/zpqUpqFfQz
	nLnZwK7rAUeMYGezWcaxBWbH1wS/al9y/IsSS3FGoqEWc1FxIgAir+w03wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsVy+t9jQd2Z0vcCDf7NN7Q4MPshq0X/FheL
	C0972CyW7lvNYrGwbQmLxeVdc9gsbjeuYLNY93I6iwOHx6vVM1k9zs9YyOjR2/yOzaNvyypG
	j6lT/jJ6HL+xncnj8ya5APaoBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWF
	vMTcVFslF58AXbfMHKCrlBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGENYwZ
	+y66FLwTqrg79yFrA+M93i5GTg4JAROJv3PesEHYYhIX7q0Hsrk4hASmM0qcmb6XEcJ5xSjx
	rnM5excjBwevgJbE5cWuIA0sAqoSi/80sYDYbEDh/S9ugA0SFQiTWDn9ClicV0BQ4sfke2C2
	CFDNtwP/mEFmMgtsYpRYNW0WM0hCWCBe4u+jn6wgtpCAs8Sxo1vAbE4BF4kv05+ADWUW0JHY
	3zoNypaX2LzmLfMERoFZSHbMQlI2C0nZAkbmVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjB
	Ef9MagfjygaLQ4wCHIxKPLwN8XcDhVgTy4orcw8xSnAwK4nwnpwCFOJNSaysSi3Kjy8qzUkt
	PsSYDAyCicxSosn5wGSUVxJvaGxiZmRpZG5oYWRsTpqwkjjvgVbrQCGB9MSS1OzU1ILUIpgt
	TBycUg2MU5/Ga8y6v01MPjSM+5gzX5j4+YwES6u/BnYcem2q3NkHpzh3mH76/lF4YvaHN9au
	l2V+J36xWffSeU/EZP67qgUnvcwqXf54vT+v3nCLTVdPwnRn8aEdkQs3Ngjs7tk+a4910Lvc
	vKm2L3nuONx7d2k/zzrb8G3+U8oEVnS+vpYmEWbRvPmYEktxRqKhFnNRcSIAP0liGjwDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laxman,

>  static int palmas_usb_probe(struct platform_device *pdev)
> @@ -137,20 +140,26 @@ static int palmas_usb_probe(struct platform_device *pdev)
>  	struct palmas_usb *palmas_usb;
>  	int status;
>  
> -	if (node && !pdata) {
> -		pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
> -
> -		if (!pdata)
> -			return -ENOMEM;
> +	palmas_usb = devm_kzalloc(&pdev->dev, sizeof(*palmas_usb), GFP_KERNEL);
> +	if (!palmas_usb)
> +		return -ENOMEM;
>  
> -		pdata->wakeup = of_property_read_bool(node, "ti,wakeup");
> +	if (node && !pdata) {
> +		palmas_usb->wakeup = of_property_read_bool(node, "ti,wakeup");
> +		palmas_usb->enable_id_detection = of_property_read_bool(node,
> +						"ti,enable-id-detection");
> +		palmas_usb->enable_vbus_detection = of_property_read_bool(node,
> +						"ti,enable-vbus-detection");
> +	} else if (pdata) {
> +		palmas_usb->wakeup = pdata->wakeup;
> +		palmas_usb->enable_id_detection = true;
> +		palmas_usb->enable_vbus_detection = true;
>  	} else if (!pdata) {
> -		return -EINVAL;
> +		palmas_usb->wakeup = true;
> +		palmas_usb->enable_id_detection = true;
> +		palmas_usb->enable_vbus_detection = true;
>  	}

I think we could modify it as following patch to remove duplicate line.
If you agree about below modification, I will apply your patch with following patch.

index 5c218d2..56909cc 100644
--- a/drivers/extcon/extcon-palmas.c
+++ b/drivers/extcon/extcon-palmas.c
@@ -150,16 +150,14 @@ static int palmas_usb_probe(struct platform_device *pdev)
                                                "ti,enable-id-detection");
                palmas_usb->enable_vbus_detection = of_property_read_bool(node,
                                                "ti,enable-vbus-detection");
-       } else if (pdata) {
-               palmas_usb->wakeup = pdata->wakeup;
-               palmas_usb->enable_id_detection = true;
-               palmas_usb->enable_vbus_detection = true;
-       } else if (!pdata) {
+       } else {
                palmas_usb->wakeup = true;
                palmas_usb->enable_id_detection = true;
                palmas_usb->enable_vbus_detection = true;
-       }
 
+               if (pdata)
+                       palmas_usb->wakeup = pdata->wakeup;
+       }
 
        palmas->usb = palmas_usb;
        palmas_usb->palmas = palmas;


Thanks,
Chanwoo Choi


