Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624AbaJHBeK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 21:34:10 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:53828 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756266AbaJHBd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 21:33:58 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68f-f791c6d000004834-fd-54349483b880
Content-transfer-encoding: 8BIT
Message-id: <54349482.2020208@samsung.com>
Date: Wed, 08 Oct 2014 10:33:54 +0900
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
        open list <linux-kernel@vger.kernel.org>, drake@endlessm.com,
        daniel@ffwll.ch, m.szyprowski@samsung.com
Subject: Re: [PATCH] drm/exynos: init vblank with real number of crtcs
References: <1411131440-15395-1-git-send-email-a.hajda@samsung.com>
 <5433DC15.5000000@samsung.com> <5434069C.3030004@samsung.com>
In-reply-to: <5434069C.3030004@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsWyRsSkRLd5ikmIwY5mVYtb686xWvSeO8lk
	8X/bRGaLR/MfM1tc+fqezeLFvYssFr0LrrJZnG16w25xedccNosZ5/cxWaw9cpfdYsbkl2wO
	PB6Lvmd57P22gMVj+7cHrB73u48zefRtWcXo8XmTXABbFJdNSmpOZllqkb5dAlfGqQ1HmQvW
	SlZ8/RXfwPhApIuRg0NCwERi0QadLkZOIFNM4sK99WxdjFwcQgJLGSWu/F/ICpEwkdj68xcL
	iC0kMJ1R4vpsPhCbV0BQ4sfkeywgc5gF5CWOXMoGCTMLqEtMmreIGWLOK0aJG7vb2SHqtSS2
	X70OZrMIqEr0PrwMZrMB2RNX3GcDsUUFwiRevNrFDGKLAA2affIOM8TQU8wSN9pUQGxhATeJ
	KY9fMEPc08wocXJDDIjNKaAtcX5qB9TNX9klOh7rQuwSkPg2+RALxL+yEpsOMEOUSEocXHGD
	ZQKj2Cwk38xC+GYWkm8WMDKvYhRNLUguKE5KLzLWK07MLS7NS9dLzs/dxAiM09P/nvXvYLx7
	wPoQowAHoxIPr2GzSYgQa2JZcWXuIUZToCMmMkuJJucDk0FeSbyhsZmRhamJqbGRuaWZkjjv
	QqmfwUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoY+9RvTj3NbcC+jvPRccG9eS3zWCVl1n9j
	WN/06lr1mluH/4dLJu76f+FMxht15uvP1jbdPnmDOcpO+NZh1ekOv3v4BP+wHvuXvO7mla6T
	xz+YzYtXrT5UkLQ8n1dty+qJYVe7P3aWHa+yST67YlaHtvSEzumvjjM8DVnbzNGS/MtoqkGw
	kd/jRiWW4oxEQy3mouJEAFeh/qDOAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnleLIzCtJLcpLzFFi42I5/e+xoG7zFJMQg8nz5SxurTvHatF77iST
	xf9tE5ktHs1/zGxx5et7NosX9y6yWPQuuMpmcbbpDbvF5V1z2CxmnN/HZLH2yF12ixmTX7I5
	8Hgs+p7lsffbAhaP7d8esHrc7z7O5NG3ZRWjx+dNcgFsUQ2MNhmpiSmpRQqpecn5KZl56bZK
	3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlARyoplCXmlAKFAhKLi5X07TBNCA1x07WA
	aYzQ9Q0JgusxMkADCWsYM05tOMpcsFay4uuv+AbGByJdjJwcEgImElt//mKBsMUkLtxbzwZi
	CwlMZ5S4PpsPxOYVEJT4MfkeUA0HB7OAvMSRS9kgYWYBdYlJ8xYxdzFyAZW/YpS4sbudHaJe
	S2L71etgNouAqkTvw8tgNhuQPXHFfbD5ogJhEi9e7WIGsUWABs0+eYcZYugpZokbbSogtrCA
	m8SUxy+YIe5pZpQ4uSEGxOYU0JY4P7WDdQKjwCwk581COG8WkvMWMDKvYhRNLUguKE5KzzXS
	K07MLS7NS9dLzs/dxAhOBM+kdzCuarA4xCjAwajEw2vQbBIixJpYVlyZe4hRgoNZSYQ3Mhoo
	xJuSWFmVWpQfX1Sak1p8iNEU6LmJzFKiyfnAJJVXEm9obGJmZGlkbmhhZGyuJM57sNU6UEgg
	PbEkNTs1tSC1CKaPiYNTqoFxheT9awe2yEXG5S56cfqz+822//lnjFR1t7Soxr2zWXjkoEiD
	5q09Chr/2m81G76YMIvPndtD1vXQllWTwhWOOPetCF8fqCRY176zSy/DtSf8Q1Cf+o8j0SEd
	G009Zv+sqXivlTH3jVCCTPLNuj/1OeLvXtWVesUk5JUWRPj9PS7ZcLk4OlqJpTgj0VCLuag4
	EQDvCSunGgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014년 10월 08일 00:28, Inki Dae wrote:
> 
> Sorry for late.
> 
> On 2014년 10월 07일 21:27, Andrzej Hajda wrote:
>> Hi Inki,
>>
>> Gently ping.
>>
>> Andrzej
>>
>>
>> On 09/19/2014 02:57 PM, Andrzej Hajda wrote:
>>> Initialization of vblank with MAX_CRTC caused attempts
>>> to disabling vblanks for non-existing crtcs in case
>>> drm used fewer crtcs. The patch fixes it.
> 
> Nice catch~ This patch also resolves unbind issue. When exynos driver is
> unbound, disable_vblank callback is called as dev->num_crtcs so if the
> number of probed crtc drivers is different from the one of enabled crtc

Oops, s/the one of enabled crtc drivers/MAX_CRTC

> drivers then it could attempt to disabling vblank for non-existing crtc,
> which in turn, null pointer access occurs.
> 
> Thanks,
> Inki Dae
> 
>>>
>>> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
>>> ---
>>>  drivers/gpu/drm/exynos/exynos_drm_drv.c | 18 +++++++++---------
>>>  1 file changed, 9 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/drivers/gpu/drm/exynos/exynos_drm_drv.c b/drivers/gpu/drm/exynos/exynos_drm_drv.c
>>> index 9b00e4e..dc4affd 100644
>>> --- a/drivers/gpu/drm/exynos/exynos_drm_drv.c
>>> +++ b/drivers/gpu/drm/exynos/exynos_drm_drv.c
>>> @@ -94,10 +94,6 @@ static int exynos_drm_load(struct drm_device *dev, unsigned long flags)
>>>  	/* init kms poll for handling hpd */
>>>  	drm_kms_helper_poll_init(dev);
>>>  
>>> -	ret = drm_vblank_init(dev, MAX_CRTC);
>>> -	if (ret)
>>> -		goto err_mode_config_cleanup;
>>> -
>>>  	/* setup possible_clones. */
>>>  	exynos_drm_encoder_setup(dev);
>>>  
>>> @@ -106,22 +102,26 @@ static int exynos_drm_load(struct drm_device *dev, unsigned long flags)
>>>  	/* Try to bind all sub drivers. */
>>>  	ret = component_bind_all(dev->dev, dev);
>>>  	if (ret)
>>> -		goto err_cleanup_vblank;
>>> +		goto err_mode_config_cleanup;
>>> +
>>> +	ret = drm_vblank_init(dev, dev->mode_config.num_crtc);
>>> +	if (ret)
>>> +		goto err_unbind_all;
>>>  
>>>  	/* Probe non kms sub drivers and virtual display driver. */
>>>  	ret = exynos_drm_device_subdrv_probe(dev);
>>>  	if (ret)
>>> -		goto err_unbind_all;
>>> +		goto err_cleanup_vblank;
>>>  
>>>  	/* force connectors detection */
>>>  	drm_helper_hpd_irq_event(dev);
>>>  
>>>  	return 0;
>>>  
>>> -err_unbind_all:
>>> -	component_unbind_all(dev->dev, dev);
>>>  err_cleanup_vblank:
>>>  	drm_vblank_cleanup(dev);
>>> +err_unbind_all:
>>> +	component_unbind_all(dev->dev, dev);
>>>  err_mode_config_cleanup:
>>>  	drm_mode_config_cleanup(dev);
>>>  	drm_release_iommu_mapping(dev);
>>> @@ -138,8 +138,8 @@ static int exynos_drm_unload(struct drm_device *dev)
>>>  	exynos_drm_fbdev_fini(dev);
>>>  	drm_kms_helper_poll_fini(dev);
>>>  
>>> -	component_unbind_all(dev->dev, dev);
>>>  	drm_vblank_cleanup(dev);
>>> +	component_unbind_all(dev->dev, dev);
>>>  	drm_mode_config_cleanup(dev);
>>>  	drm_release_iommu_mapping(dev);
>>>  
>>>
>>
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

