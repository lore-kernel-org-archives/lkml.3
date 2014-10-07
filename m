Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbaJGP2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 11:28:34 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:38417 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122AbaJGP2a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 11:28:30 -0400
X-AuditID: cbfee68f-f791c6d000004834-93-5434069cf279
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <5434069C.3030004@samsung.com>
Date: Wed, 08 Oct 2014 00:28:28 +0900
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
 <5433DC15.5000000@samsung.com>
In-reply-to: <5433DC15.5000000@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsWyRsSkUHcOm0mIQeNLXYtb686xWvSeO8lk
	8X/bRGaLR/MfM1tc+fqezeLFvYssFr0LrrJZnG16w25xedccNosZ5/cxWaw9cpfdYsbkl2wO
	PB6Lvmd57P22gMVj+7cHrB73u48zefRtWcXo8XmTXABbFJdNSmpOZllqkb5dAlfGrqPLWAsW
	ilVc3KbYwDhLqIuRg0NCwERizQ3XLkZOIFNM4sK99WxdjFwcQgJLGSWWr5/BBJEwkfhz9gs7
	RGIRo8SVg3cYQRK8AoISPybfYwGxmQXUJSbNW8QMYYtI/JgxC8rWlli28DUzRPMrRon9q26z
	QTRrSXxrXgNWxCKgKnFo2QUwmw3InrjiPliNqECYxItXu8DiIkALZp+8AzX0FLPEjTYVEFtY
	wE1iyuMXzCDfCAmkSLz9WQUS5gTa23D5NdjREgI/2SXu/JjIBLFLQOLb5EMsEN/LSmw6wAzx
	pKTEwRU3WCYwis9C8tosJK/NQvLaLCSvLWBkWcUomlqQXFCclF5krFecmFtcmpeul5yfu4kR
	GN2n/z3r38F494D1IUYBDkYlHt4VWsYhQqyJZcWVuYcYTYEumsgsJZqcD0wheSXxhsZmRham
	JqbGRuaWZkrivAulfgYLCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYNx4+2vlw21Fb6sXmZtH
	/fT43XDH4tisS39NTzenqG0/JRVq/drS20jjyyYJf4+tfMxGF1iFJdqnn7x5s2FC7mS/7E3H
	V/A/futfl2j+IUCoSN7yef2zGCmHT6vvBwjOOvbt8eHA7y/Tzv280i9Sc/B4m8gO3SQG2UKb
	qvci9/M9vzhKNOuxdiixFGckGmoxFxUnAgCgFQzz6QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgleLIzCtJLcpLzFFi42I5/e+xgO4cNpMQgyUrVCxurTvHatF77iST
	xf9tE5ktHs1/zGxx5et7NosX9y6yWPQuuMpmcbbpDbvF5V1z2CxmnN/HZLH2yF12ixmTX7I5
	8Hgs+p7lsffbAhaP7d8esHrc7z7O5NG3ZRWjx+dNcgFsUQ2MNhmpiSmpRQqpecn5KZl56bZK
	3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlARyoplCXmlAKFAhKLi5X07TBNCA1x07WA
	aYzQ9Q0JgusxMkADCWsYM77eOMJe0C5WcWfmOvYGxgahLkZODgkBE4k/Z7+wQ9hiEhfurWfr
	YuTiEBJYxChx5eAdRpAEr4CgxI/J91i6GDk4mAXkJY5cygYJMwuoS0yat4gZov4Vo8T+VbfZ
	IOq1JL41r2EGsVkEVCUOLbsAZrMB2RNX3AerERUIk3jxahdYXARo0OyTd5ghhp5ilrjRpgJi
	Cwu4SUx5/IIZZK+QQIrE259VIGFOAW2Jhsuv2ScwCsxCct0shOtmIbluASPzKkbR1ILkguKk
	9FwjveLE3OLSvHS95PzcTYzgVPBMegfjqgaLQ4wCHIxKPLwrtIxDhFgTy4orcw8xSnAwK4nw
	TnkPFOJNSaysSi3Kjy8qzUktPsRoCvTbRGYp0eR8YJrKK4k3NDYxM7I0Mje0MDI2VxLnPdhq
	HSgkkJ5YkpqdmlqQWgTTx8TBKdXAuHZLGJf/sfwp67YFLv1WmFcna/4m/4DM63mvlITkm3MT
	Yg0Olxjc//H8v6R1Wur9ZYqpkWqfOYqZt5b1z93SrsNz8MmiSXc+r5wQ/cyj6k3S+ZSgT7YR
	X5P0njw40jNROC3zcv4lxtpteava1Zf/4irKSeldtSFfornqnuSx/4sPJYuVfn7UosRSnJFo
	qMVcVJwIAMDoX70bAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sorry for late.

On 2014년 10월 07일 21:27, Andrzej Hajda wrote:
> Hi Inki,
> 
> Gently ping.
> 
> Andrzej
> 
> 
> On 09/19/2014 02:57 PM, Andrzej Hajda wrote:
>> Initialization of vblank with MAX_CRTC caused attempts
>> to disabling vblanks for non-existing crtcs in case
>> drm used fewer crtcs. The patch fixes it.

Nice catch~ This patch also resolves unbind issue. When exynos driver is
unbound, disable_vblank callback is called as dev->num_crtcs so if the
number of probed crtc drivers is different from the one of enabled crtc
drivers then it could attempt to disabling vblank for non-existing crtc,
which in turn, null pointer access occurs.

Thanks,
Inki Dae

>>
>> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
>> ---
>>  drivers/gpu/drm/exynos/exynos_drm_drv.c | 18 +++++++++---------
>>  1 file changed, 9 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/exynos/exynos_drm_drv.c b/drivers/gpu/drm/exynos/exynos_drm_drv.c
>> index 9b00e4e..dc4affd 100644
>> --- a/drivers/gpu/drm/exynos/exynos_drm_drv.c
>> +++ b/drivers/gpu/drm/exynos/exynos_drm_drv.c
>> @@ -94,10 +94,6 @@ static int exynos_drm_load(struct drm_device *dev, unsigned long flags)
>>  	/* init kms poll for handling hpd */
>>  	drm_kms_helper_poll_init(dev);
>>  
>> -	ret = drm_vblank_init(dev, MAX_CRTC);
>> -	if (ret)
>> -		goto err_mode_config_cleanup;
>> -
>>  	/* setup possible_clones. */
>>  	exynos_drm_encoder_setup(dev);
>>  
>> @@ -106,22 +102,26 @@ static int exynos_drm_load(struct drm_device *dev, unsigned long flags)
>>  	/* Try to bind all sub drivers. */
>>  	ret = component_bind_all(dev->dev, dev);
>>  	if (ret)
>> -		goto err_cleanup_vblank;
>> +		goto err_mode_config_cleanup;
>> +
>> +	ret = drm_vblank_init(dev, dev->mode_config.num_crtc);
>> +	if (ret)
>> +		goto err_unbind_all;
>>  
>>  	/* Probe non kms sub drivers and virtual display driver. */
>>  	ret = exynos_drm_device_subdrv_probe(dev);
>>  	if (ret)
>> -		goto err_unbind_all;
>> +		goto err_cleanup_vblank;
>>  
>>  	/* force connectors detection */
>>  	drm_helper_hpd_irq_event(dev);
>>  
>>  	return 0;
>>  
>> -err_unbind_all:
>> -	component_unbind_all(dev->dev, dev);
>>  err_cleanup_vblank:
>>  	drm_vblank_cleanup(dev);
>> +err_unbind_all:
>> +	component_unbind_all(dev->dev, dev);
>>  err_mode_config_cleanup:
>>  	drm_mode_config_cleanup(dev);
>>  	drm_release_iommu_mapping(dev);
>> @@ -138,8 +138,8 @@ static int exynos_drm_unload(struct drm_device *dev)
>>  	exynos_drm_fbdev_fini(dev);
>>  	drm_kms_helper_poll_fini(dev);
>>  
>> -	component_unbind_all(dev->dev, dev);
>>  	drm_vblank_cleanup(dev);
>> +	component_unbind_all(dev->dev, dev);
>>  	drm_mode_config_cleanup(dev);
>>  	drm_release_iommu_mapping(dev);
>>  
>>
> 
> 

