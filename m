Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431AbaICBnC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 21:43:02 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:17589 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbaICBm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 21:42:59 -0400
X-AuditID: cbfee68f-f797f6d000001173-3b-5406721c8cca
Message-id: <5406721C.9030906@samsung.com>
Date: Wed, 03 Sep 2014 10:42:52 +0900
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
Subject: Re: [PATCH v3 16/17] drm/exynos/ipp: remove file argument from node
 related functions
References: <1409216861-12452-17-git-send-email-a.hajda@samsung.com>
 <1409662506-30270-1-git-send-email-a.hajda@samsung.com>
In-reply-to: <1409662506-30270-1-git-send-email-a.hajda@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAIsWRmVeSWpSXmKPExsWyRsSkQFe2iC3EYG+gxa1151gtrnx9z2Yx
	6f4EFosX9y6yWJxtesNucXnXHDaLGef3MVmsPXKX3WLG5JdsDpwe97uPM3n0bVnF6PF5k1wA
	cxSXTUpqTmZZapG+XQJXxuwb31kLJkpW9Oy+wNbAuEGki5GTQ0LARKJlzRFmCFtM4sK99Wxd
	jFwcQgJLGSXm/znNCFP0+NEjMFtIYBGjxIfvPhBFrxglFu1dwwSS4BXQkljc1ccCYrMIqEos
	/7MFbCqbgJ7EnW3HwWpEBUIk3hxvZ4eoF5T4MfkeWL2IgIfE/Dd7wOqZBc4wSXxdrwtiCwsk
	SBx/85UdYnGdxLJ/s8FqOAVcJNY/XgcU5wCq15O4f1ELolVeYvOat8wgt0kInGKXaL5wmg3i
	HgGJb5MPsYDUSwjISmw6APWwpMTBFTdYJjCKzUJy0SyEqbOQTF3AyLyKUTS1ILmgOCm9yFiv
	ODG3uDQvXS85P3cTIzDiTv971r+D8e4B60OMAhyMSjy8CwLYQoRYE8uKK3MPMZoCHTGRWUo0
	OR8Y13kl8YbGZkYWpiamxkbmlmZK4rwLpX4GCwmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamCc
	a9nzMszlbcntOWY7YkM/6SZNLzZUKctiP+N8NHDyl20eK0KXrIpTFJm0Y9uW4+c7Lh/deuL3
	HalOy7/GL1/wKX2Y98aWy5VtpuJPV/MNSs/3GMakdUw9KR13O3FhleSfpKkhCW2h1w+e3HHA
	+Uf2toDlLLsvz+d4ZVh29CHfo7AEzlW+T37yKrEUZyQaajEXFScCAOTfllKzAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsVy+t9jAV2ZIrYQg+23TS1urTvHanHl63s2
	i0n3J7BYvLh3kcXibNMbdovLu+awWcw4v4/JYu2Ru+wWMya/ZHPg9LjffZzJo2/LKkaPz5vk
	ApijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4Du
	UFIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBmzL7xnbVgomRFz+4LbA2M
	G0S6GDk5JARMJB4/esQIYYtJXLi3ng3EFhJYxCjx4btPFyMXkP2KUWLR3jVMIAleAS2JxV19
	LCA2i4CqxPI/W5hBbDYBPYk7246D1YgKhEi8Od7ODlEvKPFj8j2wehEBD4n5b/aA1TMLnGGS
	+LpeF8QWFkiQOP7mKzvE4jqJZf9mg9VwCrhIrH+8DijOAVSvJ3H/ohZEq7zE5jVvmScwCsxC
	smEWQtUsJFULGJlXMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgRH9DOpHYwrGywOMQpwMCrx
	8C4IYAsRYk0sK67MPcQowcGsJMLrmwgU4k1JrKxKLcqPLyrNSS0+xGgK9P9EZinR5Hxgsskr
	iTc0NjEzsjQyN7QwMjZXEuc90GodKCSQnliSmp2aWpBaBNPHxMEp1cC4foG1WlTD0wUHRbXY
	DmtuDUw7ddSYQ2uy42SV1S02mXt5NKbw/+bdJVd5sI/dWp/vjg5PnJPjGb1ENe/dj6MW7/p0
	aGrlyWUfZhxOCzZviU85uO3Gak622GLFaDfNJAvWG0IRk5RF07v+WeRbaX//aLHab/LJSQvT
	HD8H5yYdqfXs+6dxYYESS3FGoqEWc1FxIgDk+kMK/gIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2014 09:55 PM, Andrzej Hajda wrote:
> Since file pointer is preserved in c_node passing it
> as argument in node functions is redundant.
> 
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> ---
> v3:
> - file check moved to next patch
> ---
>  drivers/gpu/drm/exynos/exynos_drm_ipp.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
> 

About both patch 16 and 17

Reviewed-by: Joonyoung Shim <jy0922.shim@samsung.com>

Thanks.

> diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.c b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
> index 05f0f4e..9e9714a 100644
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

