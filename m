Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751246AbaJAFtD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 01:49:03 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:56125 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbaJAFtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 01:49:00 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee690-f79ab6d0000046f7-7d-542b95c16fd1
Content-transfer-encoding: 8BIT
Message-id: <542B95C1.9070704@samsung.com>
Date: Wed, 01 Oct 2014 14:48:49 +0900
From: Inki Dae <inki.dae@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        David Airlie <airlied@linux.ie>, Kukjin Kim <kgene.kim@samsung.com>,
        "open list:DRM DRIVERS FOR E..." <dri-devel@lists.freedesktop.org>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-samsung-soc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drm/exynos: remove ifdeferry from initialization code
References: <1410349980-10473-1-git-send-email-a.hajda@samsung.com>
 <542A93FD.7020002@samsung.com>
In-reply-to: <542A93FD.7020002@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBIsWRmVeSWpSXmKPExsWyRsSkRPfgVO0Qgyc7bCxurTvHatF77iST
	xZWv79ksXty7yGLRu+Aqm8XZpjfsFpd3zWGzmHF+H5PFjMkv2Rw4PbZ/e8Dqcb/7OJNH35ZV
	jB6fN8kFsERx2aSk5mSWpRbp2yVwZTxe/oet4FdAxbe+dywNjAucuxg5OSQETCQebl/MCGGL
	SVy4t56ti5GLQ0hgKaPE0nVfWWGKdp+9BZVYxChx+uULFpAEr4CgxI/J94BsDg5mAXmJI5ey
	QcLMAuoSk+YtYoaof8Uo8e3eJUaIei2JhxcawIayCKhKXLt3mB3EZgOyJ664zwZiiwqESbx4
	tYsZxBYBGjT75B2wQcwCncwSc+c8ABskLOAlcfb2f7BmIYEUicl9T8FsTgFtiZnbv4JdKiFw
	iV3idP85FohtAhLfJh8Cu1RCQFZi0wFmiM8kJQ6uuMEygVFsFpJ/ZiH8MwvJPwsYmVcxiqYW
	JBcUJ6UXmegVJ+YWl+al6yXn525iBEbg6X/PJuxgvHfA+hCjAAejEg+vQoJ2iBBrYllxZe4h
	RlOgIyYyS4km5wPjPK8k3tDYzMjC1MTU2Mjc0kxJnPe11M9gIYH0xJLU7NTUgtSi+KLSnNTi
	Q4xMHJxSDYwSKw923l/sdqLEJvPm/INhZZtfHDVa27HgzRvGyl2BbreTpMNez3s5d5/EqlNC
	+fyaogmbOeSUq96x72tY9MywO+7eO+mV/r98psYYVq92Wfnc60e+i0i4T+By+biiKzNcGCba
	2oW42fR/i7p7Pc7Z0b7r1o/HW6+H/m2rNZr84vmqvCnqVe5KLMUZiYZazEXFiQDW0JR/uwIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRmVeSWpSXmKPExsVy+t9jAd2DU7VDDL69MrS4te4cq0XvuZNM
	Fle+vmezeHHvIotF74KrbBZnm96wW1zeNYfNYsb5fUwWMya/ZHPg9Nj+7QGrx/3u40wefVtW
	MXp83iQXwBLVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg
	65aZA3SMkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjHj8fI/bAW/Aiq+
	9b1jaWBc4NzFyMkhIWAisfvsLTYIW0ziwr31QDYXh5DAIkaJ0y9fsIAkeAUEJX5Mvgdkc3Aw
	C8hLHLmUDRJmFlCXmDRvETNE/StGiW/3LjFC1GtJPLzQwApiswioSly7d5gdxGYDsieuuA+2
	TFQgTOLFq13MILYI0KDZJ++ADWIW6GSWmDvnAdggYQEvibO3/4M1CwmkSEzuewpmcwpoS8zc
	/pVtAqPALCT3zUK4bxaS+xYwMq9iFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECI7vZ9I7GFc1
	WBxiFOBgVOLhrUjSDhFiTSwrrsw9xCjBwawkwjuxAijEm5JYWZValB9fVJqTWnyI0RTou4nM
	UqLJ+cDUk1cSb2hsYmZkaWRuaGFkbK4kznuw1TpQSCA9sSQ1OzW1ILUIpo+Jg1OqgdHusIi+
	Yq3GPGvOnTx9qxmTtUWe7rwZsCK2tk4gzHKi0aTdlo6WH6IynzO8fGvS8vGs4z8/I8bqiVnX
	Y4JOfYyLeDNRP3HmE7E35xtEW6dEbGytyerbtnznw3NLAg8801G0idR1+DeXecKqLXufhMnc
	8N4oHFIynSNSe29UW6n+zgctea5MpUosxRmJhlrMRcWJAHftqCYFAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014년 09월 30일 20:29, Andrzej Hajda wrote:
> Hi Inki,
> 
> Gently ping.

Hi Andrzej,

I merged it to local repository to test. But now exynos drm doesn't work
correctly since pulling drm-next of Dave regardless of your patch.

Problems are,
1. error occurs when we try to test modetest with -v option from second
times.
2. error occurs when we try to test unbind.

Now we are checking these problems. Can you try to also check it?

Thanks,
Inki Dae

> 
> Andrzej
> 
> On 09/10/2014 01:53 PM, Andrzej Hajda wrote:
>> The patch replaces separate calls to driver (de)registration by
>> loops over the array of drivers. As a result it significantly
>> decreases number of ifdefs. Additionally it moves device registration
>> related ifdefs to header file.
>>
>> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
>> ---
>> Hi Inki,
>>
>> During testing your component match support patch [1] I have prepared patch
>> removing most ifdefs from exynos_drm_drv.c. It is based on your patch, but
>> I can rebase it if necessary.
>>
>> [1]: http://permalink.gmane.org/gmane.linux.kernel.samsung-soc/37031
>>
>> Regards
>> Andrzej
>> ---
>>  drivers/gpu/drm/exynos/exynos_drm_drv.c | 170 +++++++-------------------------
>>  drivers/gpu/drm/exynos/exynos_drm_drv.h |  25 +++--
>>  2 files changed, 48 insertions(+), 147 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/exynos/exynos_drm_drv.c b/drivers/gpu/drm/exynos/exynos_drm_drv.c
>> index b2c710a..a660e46 100644
>> --- a/drivers/gpu/drm/exynos/exynos_drm_drv.c
>> +++ b/drivers/gpu/drm/exynos/exynos_drm_drv.c
>> @@ -553,74 +553,54 @@ static const struct component_master_ops exynos_drm_ops = {
>>  	.unbind		= exynos_drm_unbind,
>>  };
>>  
>> -static int exynos_drm_platform_probe(struct platform_device *pdev)
>> -{
>> -	struct component_match *match;
>> -	int ret;
>> -
>> -	pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
>> -	exynos_drm_driver.num_ioctls = ARRAY_SIZE(exynos_ioctls);
>> -
>> +static struct platform_driver * const exynos_drm_drivers[] = {
>>  #ifdef CONFIG_DRM_EXYNOS_FIMD
>> -	ret = platform_driver_register(&fimd_driver);
>> -	if (ret < 0)
>> -		return ret;
>> +	&fimd_driver,
>>  #endif
>> -
>>  #ifdef CONFIG_DRM_EXYNOS_DP
>> -	ret = platform_driver_register(&dp_driver);
>> -	if (ret < 0)
>> -		goto err_unregister_fimd_drv;
>> +	&dp_driver,
>>  #endif
>> -
>>  #ifdef CONFIG_DRM_EXYNOS_DSI
>> -	ret = platform_driver_register(&dsi_driver);
>> -	if (ret < 0)
>> -		goto err_unregister_dp_drv;
>> +	&dsi_driver,
>>  #endif
>> -
>>  #ifdef CONFIG_DRM_EXYNOS_HDMI
>> -	ret = platform_driver_register(&mixer_driver);
>> -	if (ret < 0)
>> -		goto err_unregister_dsi_drv;
>> -	ret = platform_driver_register(&hdmi_driver);
>> -	if (ret < 0)
>> -		goto err_unregister_mixer_drv;
>> +	&mixer_driver,
>> +	&hdmi_driver,
>>  #endif
>> -
>>  #ifdef CONFIG_DRM_EXYNOS_G2D
>> -	ret = platform_driver_register(&g2d_driver);
>> -	if (ret < 0)
>> -		goto err_unregister_hdmi_drv;
>> +	&g2d_driver,
>>  #endif
>> -
>>  #ifdef CONFIG_DRM_EXYNOS_FIMC
>> -	ret = platform_driver_register(&fimc_driver);
>> -	if (ret < 0)
>> -		goto err_unregister_g2d_drv;
>> +	&fimc_driver,
>>  #endif
>> -
>>  #ifdef CONFIG_DRM_EXYNOS_ROTATOR
>> -	ret = platform_driver_register(&rotator_driver);
>> -	if (ret < 0)
>> -		goto err_unregister_fimc_drv;
>> +	&rotator_driver,
>>  #endif
>> -
>>  #ifdef CONFIG_DRM_EXYNOS_GSC
>> -	ret = platform_driver_register(&gsc_driver);
>> -	if (ret < 0)
>> -		goto err_unregister_rotator_drv;
>> +	&gsc_driver,
>>  #endif
>> -
>>  #ifdef CONFIG_DRM_EXYNOS_IPP
>> -	ret = platform_driver_register(&ipp_driver);
>> -	if (ret < 0)
>> -		goto err_unregister_gsc_drv;
>> +	&ipp_driver,
>> +#endif
>> +};
>> +
>> +static int exynos_drm_platform_probe(struct platform_device *pdev)
>> +{
>> +	struct component_match *match;
>> +	int ret, i;
>> +
>> +	pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
>> +	exynos_drm_driver.num_ioctls = ARRAY_SIZE(exynos_ioctls);
>> +
>> +	for (i = 0; i < ARRAY_SIZE(exynos_drm_drivers); ++i) {
>> +		ret = platform_driver_register(exynos_drm_drivers[i]);
>> +		if (ret < 0)
>> +			goto err_unregister_drivers;
>> +	}
>>  
>>  	ret = exynos_platform_device_ipp_register();
>>  	if (ret < 0)
>> -		goto err_unregister_ipp_drv;
>> -#endif
>> +		goto err_unregister_drivers;
>>  
>>  	match = exynos_drm_match_add(&pdev->dev);
>>  	if (IS_ERR(match)) {
>> @@ -632,96 +612,24 @@ static int exynos_drm_platform_probe(struct platform_device *pdev)
>>  						match);
>>  
>>  err_unregister_ipp_dev:
>> -
>> -#ifdef CONFIG_DRM_EXYNOS_IPP
>>  	exynos_platform_device_ipp_unregister();
>> -err_unregister_ipp_drv:
>> -	platform_driver_unregister(&ipp_driver);
>> -err_unregister_gsc_drv:
>> -#endif
>>  
>> -#ifdef CONFIG_DRM_EXYNOS_GSC
>> -	platform_driver_unregister(&gsc_driver);
>> -err_unregister_rotator_drv:
>> -#endif
>> +err_unregister_drivers:
>> +	while (--i >= 0)
>> +		platform_driver_unregister(exynos_drm_drivers[i]);
>>  
>> -#ifdef CONFIG_DRM_EXYNOS_ROTATOR
>> -	platform_driver_unregister(&rotator_driver);
>> -err_unregister_fimc_drv:
>> -#endif
>> -
>> -#ifdef CONFIG_DRM_EXYNOS_FIMC
>> -	platform_driver_unregister(&fimc_driver);
>> -err_unregister_g2d_drv:
>> -#endif
>> -
>> -#ifdef CONFIG_DRM_EXYNOS_G2D
>> -	platform_driver_unregister(&g2d_driver);
>> -err_unregister_hdmi_drv:
>> -#endif
>> -
>> -#ifdef CONFIG_DRM_EXYNOS_HDMI
>> -	platform_driver_unregister(&hdmi_driver);
>> -err_unregister_mixer_drv:
>> -	platform_driver_unregister(&mixer_driver);
>> -err_unregister_dsi_drv:
>> -#endif
>> -
>> -#ifdef CONFIG_DRM_EXYNOS_DSI
>> -	platform_driver_unregister(&dsi_driver);
>> -err_unregister_dp_drv:
>> -#endif
>> -
>> -#ifdef CONFIG_DRM_EXYNOS_DP
>> -	platform_driver_unregister(&dp_driver);
>> -err_unregister_fimd_drv:
>> -#endif
>> -
>> -#ifdef CONFIG_DRM_EXYNOS_FIMD
>> -	platform_driver_unregister(&fimd_driver);
>> -#endif
>>  	return ret;
>>  }
>>  
>>  static int exynos_drm_platform_remove(struct platform_device *pdev)
>>  {
>> -#ifdef CONFIG_DRM_EXYNOS_IPP
>> -	exynos_platform_device_ipp_unregister();
>> -	platform_driver_unregister(&ipp_driver);
>> -#endif
>> -
>> -#ifdef CONFIG_DRM_EXYNOS_GSC
>> -	platform_driver_unregister(&gsc_driver);
>> -#endif
>> -
>> -#ifdef CONFIG_DRM_EXYNOS_ROTATOR
>> -	platform_driver_unregister(&rotator_driver);
>> -#endif
>> -
>> -#ifdef CONFIG_DRM_EXYNOS_FIMC
>> -	platform_driver_unregister(&fimc_driver);
>> -#endif
>> -
>> -#ifdef CONFIG_DRM_EXYNOS_G2D
>> -	platform_driver_unregister(&g2d_driver);
>> -#endif
>> -
>> -#ifdef CONFIG_DRM_EXYNOS_HDMI
>> -	platform_driver_unregister(&mixer_driver);
>> -	platform_driver_unregister(&hdmi_driver);
>> -#endif
>> +	int i;
>>  
>> -#ifdef CONFIG_DRM_EXYNOS_FIMD
>> -	platform_driver_unregister(&fimd_driver);
>> -#endif
>> +	exynos_platform_device_ipp_unregister();
>>  
>> -#ifdef CONFIG_DRM_EXYNOS_DSI
>> -	platform_driver_unregister(&dsi_driver);
>> -#endif
>> +	for (i = ARRAY_SIZE(exynos_drm_drivers) - 1; i >= 0; --i)
>> +		platform_driver_unregister(exynos_drm_drivers[i]);
>>  
>> -#ifdef CONFIG_DRM_EXYNOS_DP
>> -	platform_driver_unregister(&dp_driver);
>> -#endif
>>  	component_master_del(&pdev->dev, &exynos_drm_ops);
>>  	return 0;
>>  }
>> @@ -745,11 +653,9 @@ static int exynos_drm_init(void)
>>  	if (IS_ERR(exynos_drm_pdev))
>>  		return PTR_ERR(exynos_drm_pdev);
>>  
>> -#ifdef CONFIG_DRM_EXYNOS_VIDI
>>  	ret = exynos_drm_probe_vidi();
>>  	if (ret < 0)
>>  		goto err_unregister_pd;
>> -#endif
>>  
>>  	ret = platform_driver_register(&exynos_drm_platform_driver);
>>  	if (ret)
>> @@ -758,11 +664,9 @@ static int exynos_drm_init(void)
>>  	return 0;
>>  
>>  err_remove_vidi:
>> -#ifdef CONFIG_DRM_EXYNOS_VIDI
>>  	exynos_drm_remove_vidi();
>>  
>>  err_unregister_pd:
>> -#endif
>>  	platform_device_unregister(exynos_drm_pdev);
>>  
>>  	return ret;
>> @@ -771,9 +675,9 @@ err_unregister_pd:
>>  static void exynos_drm_exit(void)
>>  {
>>  	platform_driver_unregister(&exynos_drm_platform_driver);
>> -#ifdef CONFIG_DRM_EXYNOS_VIDI
>> +
>>  	exynos_drm_remove_vidi();
>> -#endif
>> +
>>  	platform_device_unregister(exynos_drm_pdev);
>>  }
>>  
>> diff --git a/drivers/gpu/drm/exynos/exynos_drm_drv.h b/drivers/gpu/drm/exynos/exynos_drm_drv.h
>> index 69a6fa3..76d5d02 100644
>> --- a/drivers/gpu/drm/exynos/exynos_drm_drv.h
>> +++ b/drivers/gpu/drm/exynos/exynos_drm_drv.h
>> @@ -324,15 +324,14 @@ int exynos_platform_device_hdmi_register(void);
>>   */
>>  void exynos_platform_device_hdmi_unregister(void);
>>  
>> -/*
>> - * this function registers exynos drm ipp platform device.
>> - */
>> +#ifdef CONFIG_DRM_EXYNOS_IPP
>>  int exynos_platform_device_ipp_register(void);
>> -
>> -/*
>> - * this function unregisters exynos drm ipp platform device if it exists.
>> - */
>>  void exynos_platform_device_ipp_unregister(void);
>> +#else
>> +static inline int exynos_platform_device_ipp_register(void) { return 0; }
>> +static inline void exynos_platform_device_ipp_unregister(void) {}
>> +#endif
>> +
>>  
>>  #ifdef CONFIG_DRM_EXYNOS_DPI
>>  struct exynos_drm_display * exynos_dpi_probe(struct device *dev);
>> @@ -343,15 +342,13 @@ exynos_dpi_probe(struct device *dev) { return NULL; }
>>  static inline int exynos_dpi_remove(struct device *dev) { return 0; }
>>  #endif
>>  
>> -/*
>> - * this function registers exynos drm vidi platform device/driver.
>> - */
>> +#ifdef CONFIG_DRM_EXYNOS_VIDI
>>  int exynos_drm_probe_vidi(void);
>> -
>> -/*
>> - * this function unregister exynos drm vidi platform device/driver.
>> - */
>>  void exynos_drm_remove_vidi(void);
>> +#else
>> +static inline int exynos_drm_probe_vidi(void) { return 0; }
>> +static inline void exynos_drm_remove_vidi(void) {}
>> +#endif
>>  
>>  /* This function creates a encoder and a connector, and initializes them. */
>>  int exynos_drm_create_enc_conn(struct drm_device *dev,
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

