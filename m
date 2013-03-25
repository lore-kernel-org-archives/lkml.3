Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316Ab3CYFM0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 01:12:26 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:29335 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756635Ab3CYFMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 01:12:24 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-e5-514fdcb62229
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Guennadi Liakhovetski'" <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        "'Magnus Damm'" <magnus.damm@gmail.com>,
        "'Simon Horman'" <horms@verge.net.au>,
        devicetree-discuss@lists.ozlabs.org,
        "'Samuel Ortiz'" <sameo@linux.intel.com>,
        "'Richard Purdie'" <rpurdie@rpsys.net>, linux-fbdev@vger.kernel.org,
        "'Guennadi Liakhovetski'" <g.liakhovetski+renesas@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1363968949-12151-1-git-send-email-g.liakhovetski@gmx.de>
 <1363968949-12151-4-git-send-email-g.liakhovetski@gmx.de>
In-reply-to: <1363968949-12151-4-git-send-email-g.liakhovetski@gmx.de>
Subject: Re: [PATCH v3 3/3] backlight: as3711: add OF support
Date: Mon, 25 Mar 2013 14:12:21 +0900
Message-id: <00da01ce2917$54856ce0$fd9046a0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4nGMiwHomTRl/CQuqSbJXWTSY84wB/bQaw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEKsWRmVeSWpSXmKPExsVy+t8zY91td/wDDc5NV7GYs34Nm8W/2afY
	LA7MfshqcXP6I2aL9xvnMVk0b/3KaHF54SVWixN9H1gtLu+aw2bxYPVbNovdu56yWpzuZnXg
	8dg56y67x4ePcR4nZvxm8Zh3MtDj/IyFjB4vJ/5m89gz/werR9+WVYwec35+Y/H4vEkugCuK
	yyYlNSezLLVI3y6BK2Nl92WWgndqFVOm/2ZsYNwq18XIySEhYCLx8sctJghbTOLCvfVsXYxc
	HEICyxgl2j+vY4cpOt78ixkisYhRYub3H1DOL0aJFzMegbWzCahJfPlyGKxDRCBJ4lXLPXaQ
	ImaBOcwSZ1cth5rbyCjx+eQ1oAwHB6eAm8SzfieQBmEBW4ktu+8ygtgsAqoSS/7sZgGxeYHi
	fZsnsUPYghI/Jt8DizMLaEms33mcCcKWl9i85i0zyEgJAXWJR391IW4wkvi2+BozRImIxL4X
	7xhBTpAQ2MEh0XTpIwvELgGJb5MPsUD0ykpsOsAM8bGkxMEVN1gmMErMQrJ5FpLNs5BsnoVk
	xQJGllWMoqkFyQXFSelFpnrFibnFpXnpesn5uZsYIelh4g7G+wesDzEmA62fyCwlmpwPTC95
	JfGGxmZGFqYmpsZG5pZmpAkrifOqt1gHCgmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamBklp3c
	Gfpt3417F7/fLq+4m3pUly1+SY18kuSH+Xy+4vVt79JF7Ofb3bq+9qn0w2+n/+4u2nf1bqfm
	whnX1qnPtg0w5b6cKrfCYerONarnp9zbJxX46Is5j7nkvyXz7zCn6hRGh8ra1lWf3m1W/CGX
	K2K9/qaPByr+ZB3VXaT++15EYIyqupK9EktxRqKhFnNRcSIAH36KOyUDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPKsWRmVeSWpSXmKPExsVy+t9jAd1td/wDDT4dErKYs34Nm8W/2afY
	LA7MfshqcXP6I2aL9xvnMVk0b/3KaHF54SVWixN9H1gtLu+aw2bxYPVbNovdu56yWpzuZnXg
	8dg56y67x4ePcR4nZvxm8Zh3MtDj/IyFjB4vJ/5m89gz/werR9+WVYwec35+Y/H4vEkugCuq
	gdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB+hsJYWy
	xJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhHWPGyu7LLAXv1CqmTP/N2MC4Va6L
	kZNDQsBE4njzL2YIW0ziwr31bF2MXBxCAosYJWZ+/8EM4fxilHgx4xETSBWbgJrEly+H2UFs
	EYEkiVct99hBipgF5jBLnF21HKq9kVHi88lrQBkODk4BN4ln/U4gDcICthJbdt9lBLFZBFQl
	lvzZzQJi8wLF+zZPYoewBSV+TL4HFmcW0JJYv/M4E4QtL7F5zVtmkJESAuoSj/7qQtxgJPFt
	8TVmiBIRiX0v3jFOYBSahWTSLCSTZiGZNAtJywJGllWMoqkFyQXFSem5RnrFibnFpXnpesn5
	uZsYwcnnmfQOxlUNFocYBTgYlXh4BWr8A4VYE8uKK3MPMUpwMCuJ8J5cDxTiTUmsrEotyo8v
	Ks1JLT7EmAz06ERmKdHkfGBizCuJNzQ2MTOyNDKzMDIxNydNWEmc92CrdaCQQHpiSWp2ampB
	ahHMFiYOTqkGRm/1K5PMNlsb7tfieJVqqZp7OGDZydqfZ1MqPJ4X/FYVqD97enJmzrbWkutB
	G2svzLFafXIW85EV68McZQ+239X7IPku22r7K7UvR9KPfHu1+cPpmwt9+l94hKR8SY1vf9a0
	dovvC2X7K46z1/yLWSO6SGKBzZJC5hlben3dJnwLO3dXbdsUXz0lluKMREMt5qLiRACNw4aZ
	ggMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, March 23, 2013 1:16 AM, Guennadi Liakhovetski wrote:
> 
> Add support for configuring AS3711 backlight driver from DT.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
> Reviwed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Acked-by: Jingoo Han <jg1.han@samsung.com>


But, there is a typo in comment.
> +		 * At least one su2-auto-curr* must be specified iff
s/iff/if

Best regards.
Jingoo Han

> ---
>  drivers/video/backlight/as3711_bl.c |  118 ++++++++++++++++++++++++++++++++++-
>  1 files changed, 117 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/video/backlight/as3711_bl.c b/drivers/video/backlight/as3711_bl.c
> index 41d52fe..123887c 100644
> --- a/drivers/video/backlight/as3711_bl.c
> +++ b/drivers/video/backlight/as3711_bl.c
> @@ -258,6 +258,109 @@ static int as3711_bl_register(struct platform_device *pdev,
>  	return 0;
>  }
> 
> +static int as3711_backlight_parse_dt(struct device *dev)
> +{
> +	struct as3711_bl_pdata *pdata = dev_get_platdata(dev);
> +	struct device_node *bl =
> +		of_find_node_by_name(dev->parent->of_node, "backlight"), *fb;
> +	int ret;
> +
> +	if (!bl) {
> +		dev_dbg(dev, "backlight node not found\n");
> +		return -ENODEV;
> +	}
> +
> +	fb = of_parse_phandle(bl, "su1-dev", 0);
> +	if (fb) {
> +		pdata->su1_fb = fb->full_name;
> +
> +		ret = of_property_read_u32(bl, "su1-max-uA", &pdata->su1_max_uA);
> +		if (pdata->su1_max_uA <= 0)
> +			ret = -EINVAL;
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	fb = of_parse_phandle(bl, "su2-dev", 0);
> +	if (fb) {
> +		int count = 0;
> +
> +		pdata->su2_fb = fb->full_name;
> +
> +		ret = of_property_read_u32(bl, "su2-max-uA", &pdata->su2_max_uA);
> +		if (pdata->su2_max_uA <= 0)
> +			ret = -EINVAL;
> +		if (ret < 0)
> +			return ret;
> +
> +		if (of_find_property(bl, "su2-feedback-voltage", NULL)) {
> +			pdata->su2_feedback = AS3711_SU2_VOLTAGE;
> +			count++;
> +		}
> +		if (of_find_property(bl, "su2-feedback-curr1", NULL)) {
> +			pdata->su2_feedback = AS3711_SU2_CURR1;
> +			count++;
> +		}
> +		if (of_find_property(bl, "su2-feedback-curr2", NULL)) {
> +			pdata->su2_feedback = AS3711_SU2_CURR2;
> +			count++;
> +		}
> +		if (of_find_property(bl, "su2-feedback-curr3", NULL)) {
> +			pdata->su2_feedback = AS3711_SU2_CURR3;
> +			count++;
> +		}
> +		if (of_find_property(bl, "su2-feedback-curr-auto", NULL)) {
> +			pdata->su2_feedback = AS3711_SU2_CURR_AUTO;
> +			count++;
> +		}
> +		if (count != 1)
> +			return -EINVAL;
> +
> +		count = 0;
> +		if (of_find_property(bl, "su2-fbprot-lx-sd4", NULL)) {
> +			pdata->su2_fbprot = AS3711_SU2_LX_SD4;
> +			count++;
> +		}
> +		if (of_find_property(bl, "su2-fbprot-gpio2", NULL)) {
> +			pdata->su2_fbprot = AS3711_SU2_GPIO2;
> +			count++;
> +		}
> +		if (of_find_property(bl, "su2-fbprot-gpio3", NULL)) {
> +			pdata->su2_fbprot = AS3711_SU2_GPIO3;
> +			count++;
> +		}
> +		if (of_find_property(bl, "su2-fbprot-gpio4", NULL)) {
> +			pdata->su2_fbprot = AS3711_SU2_GPIO4;
> +			count++;
> +		}
> +		if (count != 1)
> +			return -EINVAL;
> +
> +		count = 0;
> +		if (of_find_property(bl, "su2-auto-curr1", NULL)) {
> +			pdata->su2_auto_curr1 = true;
> +			count++;
> +		}
> +		if (of_find_property(bl, "su2-auto-curr2", NULL)) {
> +			pdata->su2_auto_curr2 = true;
> +			count++;
> +		}
> +		if (of_find_property(bl, "su2-auto-curr3", NULL)) {
> +			pdata->su2_auto_curr3 = true;
> +			count++;
> +		}
> +
> +		/*
> +		 * At least one su2-auto-curr* must be specified iff
> +		 * AS3711_SU2_CURR_AUTO is used
> +		 */
> +		if (!count ^ (pdata->su2_feedback != AS3711_SU2_CURR_AUTO))
> +			return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
>  static int as3711_backlight_probe(struct platform_device *pdev)
>  {
>  	struct as3711_bl_pdata *pdata = dev_get_platdata(&pdev->dev);
> @@ -267,11 +370,24 @@ static int as3711_backlight_probe(struct platform_device *pdev)
>  	unsigned int max_brightness;
>  	int ret;
> 
> -	if (!pdata || (!pdata->su1_fb && !pdata->su2_fb)) {
> +	if (!pdata) {
>  		dev_err(&pdev->dev, "No platform data, exiting...\n");
>  		return -ENODEV;
>  	}
> 
> +	if (pdev->dev.parent->of_node) {
> +		ret = as3711_backlight_parse_dt(&pdev->dev);
> +		if (ret < 0) {
> +			dev_err(&pdev->dev, "DT parsing failed: %d\n", ret);
> +			return ret;
> +		}
> +	}
> +
> +	if (!pdata->su1_fb && !pdata->su2_fb) {
> +		dev_err(&pdev->dev, "No framebuffer specified\n");
> +		return -EINVAL;
> +	}
> +
>  	/*
>  	 * Due to possible hardware damage I chose to block all modes,
>  	 * unsupported on my hardware. Anyone, wishing to use any of those modes
> --
> 1.7.2.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

