Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965611AbaH0X7G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 19:59:06 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:51188 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965385AbaH0X7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 19:59:03 -0400
X-AuditID: cbfee68f-f797f6d000001173-07-53fe70c21f7e
Message-id: <53FE70C4.9020501@samsung.com>
Date: Thu, 28 Aug 2014 08:59:00 +0900
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
Subject: Re: [PATCH 06/15] drm/exynos/ipp: free partially allocated resources
 on error
References: <1408693946-15456-1-git-send-email-a.hajda@samsung.com>
 <1408693946-15456-7-git-send-email-a.hajda@samsung.com>
 <53FC1460.5090000@samsung.com> <53FDB297.7070400@samsung.com>
In-reply-to: <53FDB297.7070400@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsWyRsSkUPdQwb9ggxdbFCxurTvHanHl63s2
	i0n3J7BYvLh3kcXibNMbdovLu+awWcw4v4/JYu2Ru+wWMya/ZHPg9LjffZzJo2/LKkaPz5vk
	ApijuGxSUnMyy1KL9O0SuDJatzcwFhyUrXh21aWB8aF4FyMnh4SAicTryxOYIGwxiQv31rN1
	MXJxCAksZZS4Me8VE0zR1J5DzBCJ6YwSi4/3sYAkhAReMUocaw4CsXkFtCQunJvHCmKzCKhK
	bFu7nw3EZhPQk7iz7TjYIFGBEIk3x9vZIeoFJX5Mvgc2R0TAQ2L+mz3MIDazwBkmia/rdUFs
	YYEIib8nj7NALN7LKLFlDcQgTgFtie7VbUANHEANehL3L2pB9MpLbF7zFuxQCYFT7BJ3dnxn
	gjhIQOLb5EMsIPUSArISmw4wQzwmKXFwxQ2WCYxis5CcNAth6iwkUxcwMq9iFE0tSC4oTkov
	MtYrTswtLs1L10vOz93ECIy50/+e9e9gvHvA+hCjAAejEg+vQ9y/YCHWxLLiytxDjKZAR0xk
	lhJNzgdGdl5JvKGxmZGFqYmpsZG5pZmSOO9CqZ/BQgLpiSWp2ampBalF8UWlOanFhxiZODil
	GhiPGy/P6/5pefJW/8TP+QlBesLu5uudWHcmbqyJCrVwv+Q6P+24w54trPqmb6UVKoszf0ow
	c5z0/X/oL5swy79jvy4c0sueFblP+vu/KTeUmLSqXxmH74vdJsCxqu73l8dpvEuvZN5wazx/
	nnnxjg8L4rKzP//VcnTbGxK6XHXFr1hmC8Xep3FKLMUZiYZazEXFiQD3pNw6tAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsVy+t9jQd1DBf+CDd5PF7e4te4cq8WVr+/Z
	LCbdn8Bi8eLeRRaLs01v2C0u75rDZjHj/D4mi7VH7rJbzJj8ks2B0+N+93Emj74tqxg9Pm+S
	C2COamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6
	Q0mhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMOY0bq9gbHgoGzFs6suDYwP
	xbsYOTkkBEwkpvYcYoawxSQu3FvP1sXIxSEkMJ1RYvHxPhaQhJDAK0aJY81BIDavgJbEhXPz
	WEFsFgFViW1r97OB2GwCehJ3th1nArFFBUIk3hxvZ4eoF5T4Mfke2BwRAQ+J+W/2gC1jFjjD
	JPF1vS6ILSwQIfH35HEWiMV7GSW2rIEYxCmgLdG9ug2ogQOoQU/i/kUtiF55ic1r3jJPYBSY
	hWTFLISqWUiqFjAyr2IUTS1ILihOSs810itOzC0uzUvXS87P3cQIjuhn0jsYVzVYHGIU4GBU
	4uF1iPsXLMSaWFZcmXuIUYKDWUmENx0kxJuSWFmVWpQfX1Sak1p8iNEUGAATmaVEk/OBySav
	JN7Q2MTMyNLI3NDCyNhcSZz3YKt1oJBAemJJanZqakFqEUwfEwenVANjSGNDdkz1Gykt9d/1
	Igw3H+XJlb9p1DeWTMppWbYn69RqZnb1hslSDg4ulUGWQR9ZKw5kTOve38ZQ07Rp5Tz5XUuD
	FTP+vo9xWfPlT/LbRZsenmVf5X1c94Gh1S/u3cFlvKvtLuit5OO4VWQ2f89VfZ+S1hP+lS11
	nRZ71WOvR9sl7sv7tVaJpTgj0VCLuag4EQCMHZY8/gIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 08/27/2014 07:27 PM, Andrzej Hajda wrote:
> On 08/26/2014 07:00 AM, Joonyoung Shim wrote:
>> Hi Andrzej,
>>
>> On 08/22/2014 04:52 PM, Andrzej Hajda wrote:
>>> In case of allocation errors some already allocated buffers
>>> were not freed. The patch fixes it.
>>>
>>> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
>>> ---
>>>  drivers/gpu/drm/exynos/exynos_drm_ipp.c | 68 ++++++++++++++++-----------------
>>>  1 file changed, 33 insertions(+), 35 deletions(-)
>>>
>>> diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.c b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
>>> index 060a198..728f3b9 100644
>>> --- a/drivers/gpu/drm/exynos/exynos_drm_ipp.c
>>> +++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
>>> @@ -599,6 +599,37 @@ static int ipp_set_mem_node(struct exynos_drm_ippdrv *ippdrv,
>>>  	return ret;
>>>  }
>>>  
>>> +static int ipp_put_mem_node(struct drm_device *drm_dev,
>>> +		struct drm_exynos_ipp_cmd_node *c_node,
>>> +		struct drm_exynos_ipp_mem_node *m_node)
>>> +{
>>> +	int i;
>>> +
>>> +	DRM_DEBUG_KMS("node[0x%x]\n", (int)m_node);
>>> +
>>> +	if (!m_node) {
>>> +		DRM_ERROR("invalid dequeue node.\n");
>>> +		return -EFAULT;
>>> +	}
>>> +
>>> +	DRM_DEBUG_KMS("ops_id[%d]\n", m_node->ops_id);
>>> +
>>> +	/* put gem buffer */
>>> +	for_each_ipp_planar(i) {
>>> +		unsigned long handle = m_node->buf_info.handles[i];
>>> +		if (handle)
>>> +			exynos_drm_gem_put_dma_addr(drm_dev, handle,
>>> +							c_node->filp);
>>> +	}
>>> +
>>> +	/* conditionally remove from queue */
>>> +	if (m_node->list.next)
>> How about do INIT_LIST_HEAD for list in ipp_get_mem_node()?
> 
> I am not sure if it is better. For sure it adds unnecessary
> initialization sequence.

In other words, this NULL checking is unnecessary if you initialize the
list_head by INIT_LIST_HEAD.

> Maybe adding list_is_initialized inline function to list.h would be the
> best solution.

There is just list_empty and we can't know whether list is initialized
or not. I recommend to use initialized list_head.

Thanks.

> 
> Regards
> Andrzej
> 
>>
>>> +		list_del(&m_node->list);
>>> +	kfree(m_node);
>>> +
>>> +	return 0;
>>> +}
>>> +
>>>  static struct drm_exynos_ipp_mem_node
>>>  		*ipp_get_mem_node(struct drm_device *drm_dev,
>>>  		struct drm_file *file,
>>> @@ -634,7 +665,8 @@ static struct drm_exynos_ipp_mem_node
>>>  					qbuf->handle[i], file);
>>>  			if (IS_ERR(addr)) {
>>>  				DRM_ERROR("failed to get addr.\n");
>>> -				goto err_clear;
>>> +				ipp_put_mem_node(drm_dev, c_node, m_node);
>>> +				return ERR_PTR(-EFAULT);
>>>  			}
>>>  
>>>  			buf_info->handles[i] = qbuf->handle[i];
>>> @@ -649,40 +681,6 @@ static struct drm_exynos_ipp_mem_node
>>>  	mutex_unlock(&c_node->mem_lock);
>>>  
>>>  	return m_node;
>>> -
>>> -err_clear:
>>> -	kfree(m_node);
>>> -	return ERR_PTR(-EFAULT);
>>> -}
>>> -
>>> -static int ipp_put_mem_node(struct drm_device *drm_dev,
>>> -		struct drm_exynos_ipp_cmd_node *c_node,
>>> -		struct drm_exynos_ipp_mem_node *m_node)
>>> -{
>>> -	int i;
>>> -
>>> -	DRM_DEBUG_KMS("node[0x%x]\n", (int)m_node);
>>> -
>>> -	if (!m_node) {
>>> -		DRM_ERROR("invalid dequeue node.\n");
>>> -		return -EFAULT;
>>> -	}
>>> -
>>> -	DRM_DEBUG_KMS("ops_id[%d]\n", m_node->ops_id);
>>> -
>>> -	/* put gem buffer */
>>> -	for_each_ipp_planar(i) {
>>> -		unsigned long handle = m_node->buf_info.handles[i];
>>> -		if (handle)
>>> -			exynos_drm_gem_put_dma_addr(drm_dev, handle,
>>> -							c_node->filp);
>>> -	}
>>> -
>>> -	/* delete list in queue */
>>> -	list_del(&m_node->list);
>>> -	kfree(m_node);
>>> -
>>> -	return 0;
>>>  }
>>>  
>>>  static void ipp_free_event(struct drm_pending_event *event)
>>>
>>
> 
> 

