Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751669Ab3CRDKQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 23:10:16 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:26523 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab3CRDKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 23:10:12 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-31-5146859271b9
From: Jingoo Han <jg1.han@samsung.com>
To: "'Fabio Porcedda'" <fabio.porcedda@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-input@vger.kernel.org, linux-fbdev@vger.kernel.org
Cc: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Linus Walleij'" <linus.walleij@linaro.org>,
        "'Samuel Ortiz'" <sameo@linux.intel.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1363280978-24051-1-git-send-email-fabio.porcedda@gmail.com>
 <1363280978-24051-7-git-send-email-fabio.porcedda@gmail.com>
In-reply-to: <1363280978-24051-7-git-send-email-fabio.porcedda@gmail.com>
Subject: Re: [PATCH v2 6/8] drivers: mfd: use module_platform_driver_probe()
Date: Mon, 18 Mar 2013 12:10:10 +0900
Message-id: <018b01ce2386$19ba9090$4d2fb1b0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4g10bo0svb/PQwQ46Y25wiAhKXdwCriAiw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsVy+t8zI91JrW6BBqdWaFu83rmUzaJ58Xo2
	i8sLL7FaTPmznMli0+NrrBYn+j6wWhzb8YjJ4uanb6wWl3fNYbPo2bCV1eJ0N6sDt8fOWXfZ
	Pe5c28PmMe9koMf+uWvYPTYvqffo27KK0ePzJrkA9igum5TUnMyy1CJ9uwSujFtLj7IVnBCp
	ePnyMXsD4xbBLkZODgkBE4nFv9ayQNhiEhfurWfrYuTiEBJYxihx+O0UZpiiE6fnM0MkpjNK
	7Jy+lR3C+cUosW7xC3aQKjYBNYkvXw6D2SICrxkl3u5MAbGZBTYySkyZUwNiCwm0M0o8X+Ha
	xcjBwSngKXFqfRlIWFjAR6Lh3kJGEJtFQFVi7+5bYDavgK3Ejbb37BC2oMSPyfdYIEZqSazf
	eZwJwpaX2LzmLTPISAkBdYlHf3UhLjCSmLD/BVSJiMS+F+8YQU6WEJjKIdFwZg0zxC4BiW+T
	D7FA9MpKbDoA9a+kxMEVN1gmMErMQrJ5FpLNs5BsnoVkxQJGllWMoqkFyQXFSelFpnrFibnF
	pXnpesn5uZsYITE/cQfj/QPWhxiTgdZPZJYSTc4Hpoy8knhDYzMjC1MTU2Mjc0sz0oSVxHnV
	W6wDhQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTBetAmRqb86/b3jKaEXFsXup+f4ubcdrVjO
	aR8lKndHa3vw0iz1F+furYgOM9UxtY1ak38pPigwpdmuvHRf6kGOlv+SR+4GdzXO76jRex10
	TPXXhZyUg+9KgvZp3Vl8tdtI9+JsySNmn65nch9cMPVQ+uPXKnMu6z1bU3CY0T39Wv+j7bck
	UhYqsRRnJBpqMRcVJwIADULWeg8DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJKsWRmVeSWpSXmKPExsVy+t9jQd1JrW6BBhfvqVq83rmUzaJ58Xo2
	i8sLL7FaTPmznMli0+NrrBYn+j6wWhzb8YjJ4uanb6wWl3fNYbPo2bCV1eJ0N6sDt8fOWXfZ
	Pe5c28PmMe9koMf+uWvYPTYvqffo27KK0ePzJrkA9qgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/g
	eOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoBOVFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG
	6PqGBMH1GBmggYR1jBm3lh5lKzghUvHy5WP2BsYtgl2MnBwSAiYSJ07PZ4awxSQu3FvP1sXI
	xSEkMJ1RYuf0rewQzi9GiXWLX7CDVLEJqEl8+XIYzBYReM0o8XZnCojNLLCRUWLKnBoQW0ig
	nVHi+QrXLkYODk4BT4lT68tAwsICPhIN9xYygtgsAqoSe3ffArN5BWwlbrS9Z4ewBSV+TL7H
	AjFSS2L9zuNMELa8xOY1b5lBRkoIqEs8+qsLcYGRxIT9L6BKRCT2vXjHOIFRaBaSSbOQTJqF
	ZNIsJC0LGFlWMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgQnlGdSOxhXNlgcYhTgYFTi4TXg
	cQ0UYk0sK67MPcQowcGsJMLbEOIWKMSbklhZlVqUH19UmpNafIgxGejRicxSosn5wGSXVxJv
	aGxiZmRpZGZhZGJuTpqwkjjvgVbrQCGB9MSS1OzU1ILUIpgtTBycUg2MJe/SNvhlx+42mNEq
	YSnfsfmG5PngA+Wtr7rXXaqxmc95MPDF28TUBwoZfdcsoiyfrWGbe2P53bOmnHVFaz61B50v
	v3xy5oVTV3kWybXtKbulfe2SyPvEJ60N145ev8gTZC4575zqg77D2+d6nustuLxxPru6XZ9B
	8ssk7jBXx20SF16WisivU2Ipzkg01GIuKk4EALMYTj5sAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 15, 2013 2:10 AM, Fabio Porcedda wrote:
> 
> This patch converts the drivers to use the
> module_platform_driver_probe() macro which makes the code smaller and
> a bit simpler.
> 
> Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: linux-arm-kernel@lists.infradead.org
> ---
>  drivers/mfd/davinci_voicecodec.c | 12 +-----------
>  drivers/mfd/htc-pasic3.c         | 13 +------------
>  2 files changed, 2 insertions(+), 23 deletions(-)

I already submitted the patch 2 weeks ago.

https://patchwork.kernel.org/patch/2217301/
https://patchwork.kernel.org/patch/2217291/


Best regards,
Jingoo Han

> 
> diff --git a/drivers/mfd/davinci_voicecodec.c b/drivers/mfd/davinci_voicecodec.c
> index c0bcc87..c60ab0c 100644
> --- a/drivers/mfd/davinci_voicecodec.c
> +++ b/drivers/mfd/davinci_voicecodec.c
> @@ -177,17 +177,7 @@ static struct platform_driver davinci_vc_driver = {
>  	.remove	= davinci_vc_remove,
>  };
> 
> -static int __init davinci_vc_init(void)
> -{
> -	return platform_driver_probe(&davinci_vc_driver, davinci_vc_probe);
> -}
> -module_init(davinci_vc_init);
> -
> -static void __exit davinci_vc_exit(void)
> -{
> -	platform_driver_unregister(&davinci_vc_driver);
> -}
> -module_exit(davinci_vc_exit);
> +module_platform_driver_probe(davinci_vc_driver, davinci_vc_probe);
> 
>  MODULE_AUTHOR("Miguel Aguilar");
>  MODULE_DESCRIPTION("Texas Instruments DaVinci Voice Codec Core Interface");
> diff --git a/drivers/mfd/htc-pasic3.c b/drivers/mfd/htc-pasic3.c
> index 9e5453d..0285fce 100644
> --- a/drivers/mfd/htc-pasic3.c
> +++ b/drivers/mfd/htc-pasic3.c
> @@ -208,18 +208,7 @@ static struct platform_driver pasic3_driver = {
>  	.remove		= pasic3_remove,
>  };
> 
> -static int __init pasic3_base_init(void)
> -{
> -	return platform_driver_probe(&pasic3_driver, pasic3_probe);
> -}
> -
> -static void __exit pasic3_base_exit(void)
> -{
> -	platform_driver_unregister(&pasic3_driver);
> -}
> -
> -module_init(pasic3_base_init);
> -module_exit(pasic3_base_exit);
> +module_platform_driver_probe(pasic3_driver, pasic3_probe);
> 
>  MODULE_AUTHOR("Philipp Zabel <philipp.zabel@gmail.com>");
>  MODULE_DESCRIPTION("Core driver for HTC PASIC3");
> --
> 1.8.1.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

