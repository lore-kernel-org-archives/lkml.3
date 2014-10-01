Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751376AbaJAGLR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 02:11:17 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:55472 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbaJAGLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 02:11:15 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee691-f79b86d000004a5a-0d-542b9b004896
Content-transfer-encoding: 8BIT
Message-id: <542B9A0E.7020206@samsung.com>
Date: Wed, 01 Oct 2014 15:07:10 +0900
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
 <542A93FD.7020002@samsung.com> <542B95C1.9070704@samsung.com>
In-reply-to: <542B95C1.9070704@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJIsWRmVeSWpSXmKPExsWyRsSkQJdxtnaIwenbTBa31p1jteg9d5LJ
	4srX92wWL+5dZLHoXXCVzeJs0xt2i8u75rBZzDi/j8lixuSXbA6cHtu/PWD1uN99nMmjb8sq
	Ro/Pm+QCWKK4bFJSczLLUov07RK4Mj53NjIVnAip2HltKVMD4wm3LkZODgkBE4n5bTdZIWwx
	iQv31rN1MXJxCAksZZSYv20ZC0zRzI5zTBCJRYwSC5pbmUASvAKCEj8m3wMq4uBgFpCXOHIp
	GyTMLKAuMWneImaI+leMErOmTmOHqNeSuL51Algvi4CqxOcVX8HibED2xBX32UBsUYEwiRev
	djGD2CJAg2afvAM2iFmgk1li7pwHjCAJYQEvibO3/7NDbGhmlJj9eynYqZwC2hJXp70CS0gI
	XGOXaDz3lRFinYDEt8mHwE6VEJCV2HSAGeI1SYmDK26wTGAUm4XkoVkID81C8tACRuZVjKKp
	BckFxUnpRaZ6xYm5xaV56XrJ+bmbGIExePrfs4k7GO8fsD7EKMDBqMTDq5CgHSLEmlhWXJl7
	iNEU6IiJzFKiyfnASM8riTc0NjOyMDUxNTYytzRTEufVkf4ZLCSQnliSmp2aWpBaFF9UmpNa
	fIiRiYNTqoFR2b3u5kXRG1VRnC51hVe95CPeSfn7vY5Tu37ksPyWBuudP67ILCuxPnFmP9si
	9xWygds/F28tudZg17h+k37cvMXTTjKIplTEnYrYPv1KqXn27YkHpf++nbTk8HdNB/Gsv5ve
	a0/5VF1ZenDCqfOS5/9MFTyzcG6QiHW6Gpv05agXcuc9DGLNlViKMxINtZiLihMBxuLdnbwC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsVy+t9jAV2+WdohBsuXmFjcWneO1aL33Ekm
	iytf37NZvLh3kcWid8FVNouzTW/YLS7vmsNmMeP8PiaLGZNfsjlwemz/9oDV4373cSaPvi2r
	GD0+b5ILYIlqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQ
	dcvMATpGSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5jxubORqeBESMXO
	a0uZGhhPuHUxcnJICJhIzOw4xwRhi0lcuLeerYuRi0NIYBGjxILmVrAEr4CgxI/J91i6GDk4
	mAXkJY5cygYJMwuoS0yat4gZov4Vo8SsqdPYIeq1JK5vnQDWyyKgKvF5xVewOBuQPXHFfTYQ
	W1QgTOLFq13MILYI0KDZJ++ADWIW6GSWmDvnASNIQljAS+Ls7f/sEBuaGSVm/17KApLgFNCW
	uDrtFfsERoFZSA6chXDgLCQHLmBkXsUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHOHPpHcw
	rmqwOMQowMGoxMNbkaQdIsSaWFZcmXuIUYKDWUmEd2IFUIg3JbGyKrUoP76oNCe1+BCjKdB7
	E5mlRJPzgcknryTe0NjEzMjSyNzQwsjYXEmc92CrdaCQQHpiSWp2ampBahFMHxMHp1QDY8n9
	8nJ3g+52E/PGkvD//yUzZ2zzlo5zk3lxrHXWrvNJbKZ/fsyR1LxWf8FBfPXVGXx1QpZu8VYh
	X7LP/NdLqrkbnHLJaqfV/uB95y+f9ptYkrX29O2YDU3Ka3o+LW4LzK7IyeTyzrq56EtYTNhb
	+/Ppq5/acMq1ss56PuXYCrHDR37bsUZ/VGIpzkg01GIuKk4EAA8QmFUGAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014년 10월 01일 14:48, Inki Dae wrote:
> On 2014년 09월 30일 20:29, Andrzej Hajda wrote:
>> Hi Inki,
>>
>> Gently ping.
> 
> Hi Andrzej,
> 
> I merged it to local repository to test. But now exynos drm doesn't work
> correctly since pulling drm-next of Dave regardless of your patch.
> 
> Problems are,
> 1. error occurs when we try to test modetest with -v option from second
> times.
> 2. error occurs when we try to test unbind.
> 
> Now we are checking these problems. Can you try to also check it?

In addition, we are testing it on trats2 board.

> 
> Thanks,
> Inki Dae
> 
>>
>> Andrzej
>>
>> On 09/10/2014 01:53 PM, Andrzej Hajda wrote:
>>> The patch replaces separate calls to driver (de)registration by
>>> loops over the array of drivers. As a result it significantly
>>> decreases number of ifdefs. Additionally it moves device registration
>>> related ifdefs to header file.
>>>
>>> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
>>> ---
>>> Hi Inki,
>>>
>>> During testing your component match support patch [1] I have prepared patch
>>> removing most ifdefs from exynos_drm_drv.c. It is based on your patch, but
>>> I can rebase it if necessary.
>>>
>>> [1]: http://permalink.gmane.org/gmane.linux.kernel.samsung-soc/37031
>>>
>>> Regards
>>> Andrzej
>>> ---
>>>  drivers/gpu/drm/exynos/exynos_drm_drv.c | 170 +++++++-------------------------
>>>  drivers/gpu/drm/exynos/exynos_drm_drv.h |  25 +++--
>>>  2 files changed, 48 insertions(+), 147 deletions(-)
>>>
>>> diff --git a/drivers/gpu/drm/exynos/exynos_drm_drv.c b/drivers/gpu/drm/exynos/exynos_drm_drv.c
>>> index b2c710a..a660e46 100644
>>> --- a/drivers/gpu/drm/exynos/exynos_drm_drv.c
>>> +++ b/drivers/gpu/drm/exynos/exynos_drm_drv.c
>>> @@ -553,74 +553,54 @@ static const struct component_master_ops exynos_drm_ops = {
>>>  	.unbind		= exynos_drm_unbind,
>>>  };
>>>  
>>> -static int exynos_drm_platform_probe(struct platform_device *pdev)
>>> -{
>>> -	struct component_match *match;
>>> -	int ret;
>>> -
>>> -	pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
>>> -	exynos_drm_driver.num_ioctls = ARRAY_SIZE(exynos_ioctls);
>>> -
>>> +static struct platform_driver * const exynos_drm_drivers[] = {
>>>  #ifdef CONFIG_DRM_EXYNOS_FIMD
>>> -	ret = platform_driver_register(&fimd_driver);
>>> -	if (ret < 0)
>>> -		return ret;
>>> +	&fimd_driver,
>>>  #endif
>>> -
>>>  #ifdef CONFIG_DRM_EXYNOS_DP
>>> -	ret = platform_driver_register(&dp_driver);
>>> -	if (ret < 0)
>>> -		goto err_unregister_fimd_drv;
>>> +	&dp_driver,
>>>  #endif
>>> -
>>>  #ifdef CONFIG_DRM_EXYNOS_DSI
>>> -	ret = platform_driver_register(&dsi_driver);
>>> -	if (ret < 0)
>>> -		goto err_unregister_dp_drv;
>>> +	&dsi_driver,
>>>  #endif
>>> -
>>>  #ifdef CONFIG_DRM_EXYNOS_HDMI
>>> -	ret = platform_driver_register(&mixer_driver);
>>> -	if (ret < 0)
>>> -		goto err_unregister_dsi_drv;
>>> -	ret = platform_driver_register(&hdmi_driver);
>>> -	if (ret < 0)
>>> -		goto err_unregister_mixer_drv;
>>> +	&mixer_driver,
>>> +	&hdmi_driver,
>>>  #endif
>>> -
>>>  #ifdef CONFIG_DRM_EXYNOS_G2D
>>> -	ret = platform_driver_register(&g2d_driver);
>>> -	if (ret < 0)
>>> -		goto err_unregister_hdmi_drv;
>>> +	&g2d_driver,
>>>  #endif
>>> -
>>>  #ifdef CONFIG_DRM_EXYNOS_FIMC
>>> -	ret = platform_driver_register(&fimc_driver);
>>> -	if (ret < 0)
>>> -		goto err_unregister_g2d_drv;
>>> +	&fimc_driver,
>>>  #endif
>>> -
>>>  #ifdef CONFIG_DRM_EXYNOS_ROTATOR
>>> -	ret = platform_driver_register(&rotator_driver);
>>> -	if (ret < 0)
>>> -		goto err_unregister_fimc_drv;
>>> +	&rotator_driver,
>>>  #endif
>>> -
>>>  #ifdef CONFIG_DRM_EXYNOS_GSC
>>> -	ret = platform_driver_register(&gsc_driver);
>>> -	if (ret < 0)
>>> -		goto err_unregister_rotator_drv;
>>> +	&gsc_driver,
>>>  #endif
>>> -
>>>  #ifdef CONFIG_DRM_EXYNOS_IPP
>>> -	ret = platform_driver_register(&ipp_driver);
>>> -	if (ret < 0)
>>> -		goto err_unregister_gsc_drv;
>>> +	&ipp_driver,
>>> +#endif
>>> +};
>>> +
>>> +static int exynos_drm_platform_probe(struct platform_device *pdev)
>>> +{
>>> +	struct component_match *match;
>>> +	int ret, i;
>>> +
>>> +	pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
>>> +	exynos_drm_driver.num_ioctls = ARRAY_SIZE(exynos_ioctls);
>>> +
>>> +	for (i = 0; i < ARRAY_SIZE(exynos_drm_drivers); ++i) {
>>> +		ret = platform_driver_register(exynos_drm_drivers[i]);
>>> +		if (ret < 0)
>>> +			goto err_unregister_drivers;
>>> +	}
>>>  
>>>  	ret = exynos_platform_device_ipp_register();
>>>  	if (ret < 0)
>>> -		goto err_unregister_ipp_drv;
>>> -#endif
>>> +		goto err_unregister_drivers;
>>>  
>>>  	match = exynos_drm_match_add(&pdev->dev);
>>>  	if (IS_ERR(match)) {
>>> @@ -632,96 +612,24 @@ static int exynos_drm_platform_probe(struct platform_device *pdev)
>>>  						match);
>>>  
>>>  err_unregister_ipp_dev:
>>> -
>>> -#ifdef CONFIG_DRM_EXYNOS_IPP
>>>  	exynos_platform_device_ipp_unregister();
>>> -err_unregister_ipp_drv:
>>> -	platform_driver_unregister(&ipp_driver);
>>> -err_unregister_gsc_drv:
>>> -#endif
>>>  
>>> -#ifdef CONFIG_DRM_EXYNOS_GSC
>>> -	platform_driver_unregister(&gsc_driver);
>>> -err_unregister_rotator_drv:
>>> -#endif
>>> +err_unregister_drivers:
>>> +	while (--i >= 0)
>>> +		platform_driver_unregister(exynos_drm_drivers[i]);
>>>  
>>> -#ifdef CONFIG_DRM_EXYNOS_ROTATOR
>>> -	platform_driver_unregister(&rotator_driver);
>>> -err_unregister_fimc_drv:
>>> -#endif
>>> -
>>> -#ifdef CONFIG_DRM_EXYNOS_FIMC
>>> -	platform_driver_unregister(&fimc_driver);
>>> -err_unregister_g2d_drv:
>>> -#endif
>>> -
>>> -#ifdef CONFIG_DRM_EXYNOS_G2D
>>> -	platform_driver_unregister(&g2d_driver);
>>> -err_unregister_hdmi_drv:
>>> -#endif
>>> -
>>> -#ifdef CONFIG_DRM_EXYNOS_HDMI
>>> -	platform_driver_unregister(&hdmi_driver);
>>> -err_unregister_mixer_drv:
>>> -	platform_driver_unregister(&mixer_driver);
>>> -err_unregister_dsi_drv:
>>> -#endif
>>> -
>>> -#ifdef CONFIG_DRM_EXYNOS_DSI
>>> -	platform_driver_unregister(&dsi_driver);
>>> -err_unregister_dp_drv:
>>> -#endif
>>> -
>>> -#ifdef CONFIG_DRM_EXYNOS_DP
>>> -	platform_driver_unregister(&dp_driver);
>>> -err_unregister_fimd_drv:
>>> -#endif
>>> -
>>> -#ifdef CONFIG_DRM_EXYNOS_FIMD
>>> -	platform_driver_unregister(&fimd_driver);
>>> -#endif
>>>  	return ret;
>>>  }
>>>  
>>>  static int exynos_drm_platform_remove(struct platform_device *pdev)
>>>  {
>>> -#ifdef CONFIG_DRM_EXYNOS_IPP
>>> -	exynos_platform_device_ipp_unregister();
>>> -	platform_driver_unregister(&ipp_driver);
>>> -#endif
>>> -
>>> -#ifdef CONFIG_DRM_EXYNOS_GSC
>>> -	platform_driver_unregister(&gsc_driver);
>>> -#endif
>>> -
>>> -#ifdef CONFIG_DRM_EXYNOS_ROTATOR
>>> -	platform_driver_unregister(&rotator_driver);
>>> -#endif
>>> -
>>> -#ifdef CONFIG_DRM_EXYNOS_FIMC
>>> -	platform_driver_unregister(&fimc_driver);
>>> -#endif
>>> -
>>> -#ifdef CONFIG_DRM_EXYNOS_G2D
>>> -	platform_driver_unregister(&g2d_driver);
>>> -#endif
>>> -
>>> -#ifdef CONFIG_DRM_EXYNOS_HDMI
>>> -	platform_driver_unregister(&mixer_driver);
>>> -	platform_driver_unregister(&hdmi_driver);
>>> -#endif
>>> +	int i;
>>>  
>>> -#ifdef CONFIG_DRM_EXYNOS_FIMD
>>> -	platform_driver_unregister(&fimd_driver);
>>> -#endif
>>> +	exynos_platform_device_ipp_unregister();
>>>  
>>> -#ifdef CONFIG_DRM_EXYNOS_DSI
>>> -	platform_driver_unregister(&dsi_driver);
>>> -#endif
>>> +	for (i = ARRAY_SIZE(exynos_drm_drivers) - 1; i >= 0; --i)
>>> +		platform_driver_unregister(exynos_drm_drivers[i]);
>>>  
>>> -#ifdef CONFIG_DRM_EXYNOS_DP
>>> -	platform_driver_unregister(&dp_driver);
>>> -#endif
>>>  	component_master_del(&pdev->dev, &exynos_drm_ops);
>>>  	return 0;
>>>  }
>>> @@ -745,11 +653,9 @@ static int exynos_drm_init(void)
>>>  	if (IS_ERR(exynos_drm_pdev))
>>>  		return PTR_ERR(exynos_drm_pdev);
>>>  
>>> -#ifdef CONFIG_DRM_EXYNOS_VIDI
>>>  	ret = exynos_drm_probe_vidi();
>>>  	if (ret < 0)
>>>  		goto err_unregister_pd;
>>> -#endif
>>>  
>>>  	ret = platform_driver_register(&exynos_drm_platform_driver);
>>>  	if (ret)
>>> @@ -758,11 +664,9 @@ static int exynos_drm_init(void)
>>>  	return 0;
>>>  
>>>  err_remove_vidi:
>>> -#ifdef CONFIG_DRM_EXYNOS_VIDI
>>>  	exynos_drm_remove_vidi();
>>>  
>>>  err_unregister_pd:
>>> -#endif
>>>  	platform_device_unregister(exynos_drm_pdev);
>>>  
>>>  	return ret;
>>> @@ -771,9 +675,9 @@ err_unregister_pd:
>>>  static void exynos_drm_exit(void)
>>>  {
>>>  	platform_driver_unregister(&exynos_drm_platform_driver);
>>> -#ifdef CONFIG_DRM_EXYNOS_VIDI
>>> +
>>>  	exynos_drm_remove_vidi();
>>> -#endif
>>> +
>>>  	platform_device_unregister(exynos_drm_pdev);
>>>  }
>>>  
>>> diff --git a/drivers/gpu/drm/exynos/exynos_drm_drv.h b/drivers/gpu/drm/exynos/exynos_drm_drv.h
>>> index 69a6fa3..76d5d02 100644
>>> --- a/drivers/gpu/drm/exynos/exynos_drm_drv.h
>>> +++ b/drivers/gpu/drm/exynos/exynos_drm_drv.h
>>> @@ -324,15 +324,14 @@ int exynos_platform_device_hdmi_register(void);
>>>   */
>>>  void exynos_platform_device_hdmi_unregister(void);
>>>  
>>> -/*
>>> - * this function registers exynos drm ipp platform device.
>>> - */
>>> +#ifdef CONFIG_DRM_EXYNOS_IPP
>>>  int exynos_platform_device_ipp_register(void);
>>> -
>>> -/*
>>> - * this function unregisters exynos drm ipp platform device if it exists.
>>> - */
>>>  void exynos_platform_device_ipp_unregister(void);
>>> +#else
>>> +static inline int exynos_platform_device_ipp_register(void) { return 0; }
>>> +static inline void exynos_platform_device_ipp_unregister(void) {}
>>> +#endif
>>> +
>>>  
>>>  #ifdef CONFIG_DRM_EXYNOS_DPI
>>>  struct exynos_drm_display * exynos_dpi_probe(struct device *dev);
>>> @@ -343,15 +342,13 @@ exynos_dpi_probe(struct device *dev) { return NULL; }
>>>  static inline int exynos_dpi_remove(struct device *dev) { return 0; }
>>>  #endif
>>>  
>>> -/*
>>> - * this function registers exynos drm vidi platform device/driver.
>>> - */
>>> +#ifdef CONFIG_DRM_EXYNOS_VIDI
>>>  int exynos_drm_probe_vidi(void);
>>> -
>>> -/*
>>> - * this function unregister exynos drm vidi platform device/driver.
>>> - */
>>>  void exynos_drm_remove_vidi(void);
>>> +#else
>>> +static inline int exynos_drm_probe_vidi(void) { return 0; }
>>> +static inline void exynos_drm_remove_vidi(void) {}
>>> +#endif
>>>  
>>>  /* This function creates a encoder and a connector, and initializes them. */
>>>  int exynos_drm_create_enc_conn(struct drm_device *dev,
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 

