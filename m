Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083AbaHZCz1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 22:55:27 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:19368 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757051AbaHZCzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 22:55:25 -0400
X-AuditID: cbfee691-f79546d0000011a1-07-53fbf71a9904
Message-id: <53FBF71B.7070107@samsung.com>
Date: Tue, 26 Aug 2014 11:55:23 +0900
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
Subject: Re: [PATCH 03/15] drm/exynos/ipp: move file reference from memory to
 command node
References: <1408693946-15456-1-git-send-email-a.hajda@samsung.com>
 <1408693946-15456-4-git-send-email-a.hajda@samsung.com>
In-reply-to: <1408693946-15456-4-git-send-email-a.hajda@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPIsWRmVeSWpSXmKPExsWyRsSkSFf6++9gg7X/mS1urTvHanHl63s2
	i0n3J7BYvLh3kcXibNMbdovLu+awWcw4v4/JYu2Ru+wWMya/ZHPg9LjffZzJo2/LKkaPz5vk
	ApijuGxSUnMyy1KL9O0SuDJ+TTrNWvBAuOLy0xeMDYx9Al2MnBwSAiYSn//sY4WwxSQu3FvP
	BmILCSxllHi+ygam5vm7aywQ8UWMEl9+FXcxcgHZrxglpr3YwwSS4BXQkuifdQ6smUVAVeLo
	lFeMIDabgJ7EnW3HwWpEBUIk3hxvZ4eoF5T4Mfke2FARAQ+J+W/2MIPYzAJnmCS+rtcFsYUF
	YiRu3bkKtbhWYvK9HrAaTgEXiVUtS4F2cQDV60ncv6gF0SovsXnNW2aIm0+xS7R0ikGcIyDx
	bfIhFpByCQFZiU0HoEokJQ6uuMEygVFsFpKDZiEMnYVk6AJG5lWMoqkFyQXFSelFpnrFibnF
	pXnpesn5uZsYgfF2+t+ziTsY7x+wPsQowMGoxMN7I/53sBBrYllxZe4hRlOgIyYyS4km5wOj
	Oq8k3tDYzMjC1MTU2Mjc0kxJnFdH+mewkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBkauSvXC
	hAdPuioUxU2NmbX21i3Lby/10GLtfOVwfKXgRf6E/Q+XLP7ZebY+uK1Co6X7ybs+ZuueBUHt
	Z/4Ya3Uu59tktTIy/fiNx0qtzC650je6Mo/qX1nuab+h1u21fXwMW57NsabUTau2CTp5x+z4
	w7B1ssTtbx62joFZneEb7vxbdeSfgxJLcUaioRZzUXEiAJlqCjWyAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsVy+t9jAV2p77+DDa68t7C4te4cq8WVr+/Z
	LCbdn8Bi8eLeRRaLs01v2C0u75rDZjHj/D4mi7VH7rJbzJj8ks2B0+N+93Emj74tqxg9Pm+S
	C2COamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6
	Q0mhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMOY8WvSadaCB8IVl5++YGxg
	7BPoYuTkkBAwkXj+7hoLhC0mceHeejYQW0hgEaPEl1/FXYxcQPYrRolpL/YwgSR4BbQk+med
	AytiEVCVODrlFSOIzSagJ3Fn23GwGlGBEIk3x9vZIeoFJX5Mvge2QETAQ2L+mz3MIDazwBkm
	ia/rdUFsYYEYiVt3rrJALK6VmHyvB6yGU8BFYlXLUqBdHED1ehL3L2pBtMpLbF7zlnkCo8As
	JBtmIVTNQlK1gJF5FaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZwRD+T3sG4qsHiEKMAB6MS
	D++N+N/BQqyJZcWVuYcYJTiYlUR4GR4ChXhTEiurUovy44tKc1KLDzGaAv0/kVlKNDkfmGzy
	SuINjU3MjCyNzA0tjIzNlcR5D7ZaBwoJpCeWpGanphakFsH0MXFwSjUwLntbrLDg8d4r3y/8
	dlD75r7YKk+qf86bhc+iJVW6Ompbd+7QDD3B5iF38WPql+sFmtFqZ/QDr21dsr0y6oPpfd/b
	tsfD9nZkJ9yrXNd0oONevNnanQ+NeVjZN/OH6/0/m33ic2ThioNmK2w37PZdY7OqiutOV1B1
	/ffuhtPRdoLvGFtMGW9tVWIpzkg01GIuKk4EAODaCXL+AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrzej,

On 08/22/2014 04:52 PM, Andrzej Hajda wrote:
> Command node should contain file reference to distinguish commands
> created by different processes.
> 
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> ---
>  drivers/gpu/drm/exynos/exynos_drm_ipp.c | 5 ++---
>  drivers/gpu/drm/exynos/exynos_drm_ipp.h | 2 ++
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.c b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
> index 9770966..bbe9968 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_ipp.c
> +++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
> @@ -75,7 +75,6 @@ struct drm_exynos_ipp_mem_node {
>  	u32	prop_id;
>  	u32	buf_id;
>  	struct drm_exynos_ipp_buf_info	buf_info;
> -	struct drm_file		*filp;
>  };
>  
>  /*
> @@ -448,6 +447,7 @@ int exynos_drm_ipp_set_property(struct drm_device *drm_dev, void *data,
>  	c_node->dev = dev;
>  	c_node->property = *property;
>  	c_node->state = IPP_STATE_IDLE;
> +	c_node->filp = file;
>  
>  	c_node->start_work = ipp_create_cmd_work();
>  	if (IS_ERR(c_node->start_work)) {
> @@ -645,7 +645,6 @@ static struct drm_exynos_ipp_mem_node
>  		}
>  	}
>  
> -	m_node->filp = file;
>  	mutex_lock(&c_node->mem_lock);
>  	list_add_tail(&m_node->list, &c_node->mem_list[qbuf->ops_id]);
>  	mutex_unlock(&c_node->mem_lock);
> @@ -677,7 +676,7 @@ static int ipp_put_mem_node(struct drm_device *drm_dev,

Then, could you remove file argument from exynos_drm_ipp_queue_buf() and
ipp_get_event()?

>  		unsigned long handle = m_node->buf_info.handles[i];
>  		if (handle)
>  			exynos_drm_gem_put_dma_addr(drm_dev, handle,
> -							m_node->filp);
> +							c_node->filp);
>  	}
>  
>  	/* delete list in queue */
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.h b/drivers/gpu/drm/exynos/exynos_drm_ipp.h
> index 6f48d62..0311035 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_ipp.h
> +++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.h
> @@ -62,6 +62,7 @@ struct drm_exynos_ipp_cmd_work {
>   * @stop_work: stop command work structure.
>   * @event_work: event work structure.
>   * @state: state of command node.
> + * @filp: associated file pointer.
>   */
>  struct drm_exynos_ipp_cmd_node {
>  	struct device		*dev;
> @@ -78,6 +79,7 @@ struct drm_exynos_ipp_cmd_node {
>  	struct drm_exynos_ipp_cmd_work *stop_work;
>  	struct drm_exynos_ipp_event_work *event_work;
>  	enum drm_exynos_ipp_state	state;
> +	struct drm_file	*filp;
>  };
>  
>  /*
> 

