Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbaH2HDc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 03:03:32 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:28746 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaH2HD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 03:03:29 -0400
X-AuditID: cbfee68e-f79536d000000fd1-7a-540025ba36ad
Message-id: <540025BB.6070209@samsung.com>
Date: Fri, 29 Aug 2014 16:03:23 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101
 Thunderbird/31.0
MIME-version: 1.0
To: Andrzej Hajda <a.hajda@samsung.com>, Inki Dae <inki.dae@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        dri-devel@lists.freedesktop.org,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-samsung-soc@vger.kernel.org>,
        Joonyoung Shim <jy0922.shim@samsung.com>
Subject: Re: [PATCH v2 16/17] drm/exynos/ipp: remove file argument from node
 related functions
References: <1409216861-12452-1-git-send-email-a.hajda@samsung.com>
 <1409216861-12452-17-git-send-email-a.hajda@samsung.com>
In-reply-to: <1409216861-12452-17-git-send-email-a.hajda@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsWyRsSkUHeXKkOIwe7XOha31p1jtbjy9T2b
	xaT7E1gsXty7yGJxtukNu8XlXXPYLGac38dksfbIXXaLGZNfsjlwetzvPs7k0bdlFaPH501y
	AcxRXDYpqTmZZalF+nYJXBnvuw8wFsySrtjxvpW5gfG/aBcjJ4eEgInE84UzGCFsMYkL99az
	dTFycQgJLGWUWHz3AhNMUeP1u8wQiemMEr3Tz7JAOK8YJQ7duQnWziugJdHwfwKYzSKgKnFt
	9n1WEJtNQE/izrbjYJNEBUIk3hxvZ4eoF5T4MfkeC4gtIuAhMf/NHmYQm1ngDJPE1/W6ILaw
	QIJE/7QWsF4hgTqJc5v/s4HYnAKuErvPvAPq5QCq15O4f1ELolVeYvOat2CHSgicY5f4dOoz
	C8Q9AhLfJh8Cq5cQkJXYdIAZ4jFJiYMrbrBMYBSbheSiWQhTZyGZuoCReRWjaGpBckFxUnqR
	kV5xYm5xaV66XnJ+7iZGYNSd/vesbwfjzQPWhxgFOBiVeHg7Tv4PFmJNLCuuzD3EaAp0xERm
	KdHkfGBs55XEGxqbGVmYmpgaG5lbmimJ8yZI/QwWEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnV
	wKjntCb+NG+jhIv3YdfktDcV2S5CnzSmtX+Push9g2vPx/n2p9n1115aLHH+kbf+jGvTyj/Z
	nN9Ys6Rih/Nd+fWKD4SXnZFU1nssdNS+583edtvTi87l7H3vvOOau/pKAy6VRJO9F9l+X1vS
	5u/8TF/ulK9qWSgTa5qsi/HkWpurDftqVxu+bVJiKc5INNRiLipOBADZupootQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDIsWRmVeSWpSXmKPExsVy+t9jQd1dqgwhBvOWqlrcWneO1eLK1/ds
	FpPuT2CxeHHvIovF2aY37BaXd81hs5hxfh+Txdojd9ktZkx+yebA6XG/+ziTR9+WVYwenzfJ
	BTBHNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gDd
	oaRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHMeN99gLFglnTFjvetzA2M
	/0W7GDk5JARMJBqv32WGsMUkLtxbz9bFyMUhJDCdUaJ3+lkWCOcVo8ShOzcZQap4BbQkGv5P
	ALNZBFQlrs2+zwpiswnoSdzZdpwJxBYVCJF4c7ydHaJeUOLH5HssILaIgIfE/Dd7wLYxC5xh
	kvi6XhfEFhZIkOif1gLWKyRQJ3Fu8382EJtTwFVi95l3QL0cQPV6EvcvakG0yktsXvOWeQKj
	wCwkG2YhVM1CUrWAkXkVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnBMP5PawbiyweIQowAH
	oxIPb8fJ/8FCrIllxZW5hxglOJiVRHgLnwGFeFMSK6tSi/Lji0pzUosPMZoC/T+RWUo0OR+Y
	bvJK4g2NTcyMLI3MDS2MjM2VxHkPtFoHCgmkJ5akZqemFqQWwfQxcXBKNTAaarvYyq4Teqym
	bPswaL3H3QVtsSZvrsTFL5vJuuI02yO5p8E3H7YJFFk6T5mgP6V1/rkPG2RfuL6flFF2+IWG
	ZB4n15ZZDJYaGYtXBqt9/lRTt1Www1/vuGh5UkT8KqV7jAtXxs+odHZr4Dqsci9POTs8VPen
	kfTJRZpfecQmiwQmbeY7MF+JpTgj0VCLuag4EQDMoArh/wIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrzej,

On 08/28/2014 06:07 PM, Andrzej Hajda wrote:
> Since file pointer is preserved in c_node passing it
> as argument in node functions is redundant.
> 
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> ---
>  drivers/gpu/drm/exynos/exynos_drm_ipp.c | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.c b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
> index 05f0f4e..fc8bb67 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_ipp.c
> +++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
> @@ -529,7 +529,6 @@ static int ipp_put_mem_node(struct drm_device *drm_dev,
>  
>  static struct drm_exynos_ipp_mem_node
>  		*ipp_get_mem_node(struct drm_device *drm_dev,
> -		struct drm_file *file,
>  		struct drm_exynos_ipp_cmd_node *c_node,
>  		struct drm_exynos_ipp_queue_buf *qbuf)
>  {
> @@ -560,7 +559,7 @@ static struct drm_exynos_ipp_mem_node
>  			dma_addr_t *addr;
>  
>  			addr = exynos_drm_gem_get_dma_addr(drm_dev,
> -					qbuf->handle[i], file);
> +					qbuf->handle[i], c_node->filp);
>  			if (IS_ERR(addr)) {
>  				DRM_ERROR("failed to get addr.\n");
>  				ipp_put_mem_node(drm_dev, c_node, m_node);
> @@ -606,7 +605,6 @@ static void ipp_free_event(struct drm_pending_event *event)
>  }
>  
>  static int ipp_get_event(struct drm_device *drm_dev,
> -		struct drm_file *file,
>  		struct drm_exynos_ipp_cmd_node *c_node,
>  		struct drm_exynos_ipp_queue_buf *qbuf)
>  {
> @@ -618,7 +616,7 @@ static int ipp_get_event(struct drm_device *drm_dev,
>  	e = kzalloc(sizeof(*e), GFP_KERNEL);
>  	if (!e) {
>  		spin_lock_irqsave(&drm_dev->event_lock, flags);
> -		file->event_space += sizeof(e->event);
> +		c_node->filp->event_space += sizeof(e->event);
>  		spin_unlock_irqrestore(&drm_dev->event_lock, flags);
>  		return -ENOMEM;
>  	}
> @@ -630,7 +628,7 @@ static int ipp_get_event(struct drm_device *drm_dev,
>  	e->event.prop_id = qbuf->prop_id;
>  	e->event.buf_id[EXYNOS_DRM_OPS_DST] = qbuf->buf_id;
>  	e->base.event = &e->event.base;
> -	e->base.file_priv = file;
> +	e->base.file_priv = c_node->filp;
>  	e->base.destroy = ipp_free_event;
>  	mutex_lock(&c_node->event_lock);
>  	list_add_tail(&e->base.link, &c_node->event_list);
> @@ -899,7 +897,7 @@ int exynos_drm_ipp_queue_buf(struct drm_device *drm_dev, void *data,
>  	/* find command node */
>  	c_node = ipp_find_obj(&ctx->prop_idr, &ctx->prop_lock,
>  		qbuf->prop_id);
> -	if (!c_node) {
> +	if (!c_node || c_node->filp != file) {

I think this should go to patch 17.

Thanks.

>  		DRM_ERROR("failed to get command node.\n");
>  		return -ENODEV;
>  	}
> @@ -908,7 +906,7 @@ int exynos_drm_ipp_queue_buf(struct drm_device *drm_dev, void *data,
>  	switch (qbuf->buf_type) {
>  	case IPP_BUF_ENQUEUE:
>  		/* get memory node */
> -		m_node = ipp_get_mem_node(drm_dev, file, c_node, qbuf);
> +		m_node = ipp_get_mem_node(drm_dev, c_node, qbuf);
>  		if (IS_ERR(m_node)) {
>  			DRM_ERROR("failed to get m_node.\n");
>  			return PTR_ERR(m_node);
> @@ -921,7 +919,7 @@ int exynos_drm_ipp_queue_buf(struct drm_device *drm_dev, void *data,
>  		 */
>  		if (qbuf->ops_id == EXYNOS_DRM_OPS_DST) {
>  			/* get event for destination buffer */
> -			ret = ipp_get_event(drm_dev, file, c_node, qbuf);
> +			ret = ipp_get_event(drm_dev, c_node, qbuf);
>  			if (ret) {
>  				DRM_ERROR("failed to get event.\n");
>  				goto err_clean_node;
> 

