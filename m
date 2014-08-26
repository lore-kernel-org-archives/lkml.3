Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084AbaHZC7m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 22:59:42 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:39726 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756788AbaHZC7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 22:59:40 -0400
X-AuditID: cbfee691-f79546d0000011a1-88-53fbf81802fc
Message-id: <53FBF818.70407@samsung.com>
Date: Tue, 26 Aug 2014 11:59:36 +0900
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
	<linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH 03/15] drm/exynos/ipp: move file reference from memory to
 command node
References: <1408693946-15456-1-git-send-email-a.hajda@samsung.com>
 <1408693946-15456-4-git-send-email-a.hajda@samsung.com>
 <53FBF71B.7070107@samsung.com>
In-reply-to: <53FBF71B.7070107@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDIsWRmVeSWpSXmKPExsWyRsSkUFfix+9gg6ttoha31p1jtbjy9T2b
	xaT7E1gszja9Ybe4vGsOm8WM8/uYLNYeuctuMWPySzYHDo/73ceZPPq2rGL0+LxJLoA5issm
	JTUnsyy1SN8ugStj9db57AWbRCu6th1nbmA8JNjFyMkhIWAi0fP2FCuELSZx4d56ti5GLg4h
	gaWMEq+XrGaFKfr++xQLRGIRo8SZ01fYQRJCAq8YJfb9dAWxeQU0JL7u6wBrYBFQlfj5sQfM
	ZhPQk7iz7TgTiC0qECLx5ng7O0S9oMSPyfdYQGwRAQ+J+W/2MIMsYBZYwCTx7UEHWIOwQIzE
	rTtXWSCWzWOUuL9HFsTmFNCWuPBnF9AgDqAGPYn7F7VAwswC8hKb17xlhjj6FLvE+3/aEPcI
	SHybfIgFpFxCQFZi0wGoEkmJgytusExgFJuF5KJZCENnIRm6gJF5FaNoakFyQXFSepGpXnFi
	bnFpXrpecn7uJkZgpJ3+92ziDsb7B6wPMQpwMCrx8N6I/x0sxJpYVlyZe4jRFOiIicxSosn5
	wHjOK4k3NDYzsjA1MTU2Mrc0UxLn1ZH+GSwkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBscFR
	0GCt9Cn1qm1p1T7uijq+Nv+WzW2U5Eh4dcVNsPP/zrePZP7ZWq1d4ClYVcMRtFRw6meXKZPu
	1bU57Lt7Pbb8xYldMTG7zmy98lom1+bwvW1e7F5e277FbfI77h41W0vwzBU9XyYWxX7vvSvf
	tHsHJlowdckv2Zp8jcf9Z8ULu01/ppv5KLEUZyQaajEXFScCADxELiSvAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOIsWRmVeSWpSXmKPExsVy+t9jAV2JH7+DDe7v4bW4te4cq8WVr+/Z
	LCbdn8BicbbpDbvF5V1z2CxmnN/HZLH2yF12ixmTX7I5cHjc7z7O5NG3ZRWjx+dNcgHMUQ2M
	NhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAJygplCXm
	lAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCWsYM1Zvnc9esEm0omvbceYGxkOCXYyc
	HBICJhLff59igbDFJC7cW8/WxcjFISSwiFHizOkr7CAJIYFXjBL7frqC2LwCGhJf93Wwgtgs
	AqoSPz/2gNlsAnoSd7YdZwKxRQVCJN4cb2eHqBeU+DH5HtgCEQEPiflv9jCDLGAWWMAk8e1B
	B1iDsECMxK07V1kgls1jlLi/RxbE5hTQlrjwZxfQIA6gBj2J+xe1QMLMAvISm9e8ZZ7AKDAL
	yYpZCFWzkFQtYGRexSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREcyc+kdzCuarA4xCjAwajE
	w3sj/newEGtiWXFl7iFGCQ5mJRFehodAId6UxMqq1KL8+KLSnNTiQ4ymwACYyCwlmpwPTDJ5
	JfGGxiZmRpZG5oYWRsbmSuK8B1utA4UE0hNLUrNTUwtSi2D6mDg4pRoYgy5LhLd4bwx982vz
	yWIF9mmPVzIGVNkx3gy8/OTSg/bG2OYz73QM2qZYsAkxrGzdIf4hXvOaZ8LTfhe+dUtbnjp4
	qys0Jhofvcfm/f9K6NTdDedmph+XOm0rZ1Eepjcp8z/PS4eJ3/V8al/+iDRdcOaA+pEGDekb
	xW1XZl1fPmHWHTVtuSmdSizFGYmGWsxFxYkAi9GEb/oCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2014 11:55 AM, Joonyoung Shim wrote:
> Hi Andrzej,
> 
> On 08/22/2014 04:52 PM, Andrzej Hajda wrote:
>> Command node should contain file reference to distinguish commands
>> created by different processes.
>>
>> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
>> ---
>>  drivers/gpu/drm/exynos/exynos_drm_ipp.c | 5 ++---
>>  drivers/gpu/drm/exynos/exynos_drm_ipp.h | 2 ++
>>  2 files changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.c b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
>> index 9770966..bbe9968 100644
>> --- a/drivers/gpu/drm/exynos/exynos_drm_ipp.c
>> +++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
>> @@ -75,7 +75,6 @@ struct drm_exynos_ipp_mem_node {
>>  	u32	prop_id;
>>  	u32	buf_id;
>>  	struct drm_exynos_ipp_buf_info	buf_info;
>> -	struct drm_file		*filp;
>>  };
>>  
>>  /*
>> @@ -448,6 +447,7 @@ int exynos_drm_ipp_set_property(struct drm_device *drm_dev, void *data,
>>  	c_node->dev = dev;
>>  	c_node->property = *property;
>>  	c_node->state = IPP_STATE_IDLE;
>> +	c_node->filp = file;
>>  
>>  	c_node->start_work = ipp_create_cmd_work();
>>  	if (IS_ERR(c_node->start_work)) {
>> @@ -645,7 +645,6 @@ static struct drm_exynos_ipp_mem_node
>>  		}
>>  	}
>>  
>> -	m_node->filp = file;
>>  	mutex_lock(&c_node->mem_lock);
>>  	list_add_tail(&m_node->list, &c_node->mem_list[qbuf->ops_id]);
>>  	mutex_unlock(&c_node->mem_lock);
>> @@ -677,7 +676,7 @@ static int ipp_put_mem_node(struct drm_device *drm_dev,
> 
> Then, could you remove file argument from exynos_drm_ipp_queue_buf() and
> ipp_get_event()?

sorry, i mean ipp_put_mem_node() instead of exynos_drm_ipp_queue_buf().

> 
>>  		unsigned long handle = m_node->buf_info.handles[i];
>>  		if (handle)
>>  			exynos_drm_gem_put_dma_addr(drm_dev, handle,
>> -							m_node->filp);
>> +							c_node->filp);
>>  	}
>>  
>>  	/* delete list in queue */
>> diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.h b/drivers/gpu/drm/exynos/exynos_drm_ipp.h
>> index 6f48d62..0311035 100644
>> --- a/drivers/gpu/drm/exynos/exynos_drm_ipp.h
>> +++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.h
>> @@ -62,6 +62,7 @@ struct drm_exynos_ipp_cmd_work {
>>   * @stop_work: stop command work structure.
>>   * @event_work: event work structure.
>>   * @state: state of command node.
>> + * @filp: associated file pointer.
>>   */
>>  struct drm_exynos_ipp_cmd_node {
>>  	struct device		*dev;
>> @@ -78,6 +79,7 @@ struct drm_exynos_ipp_cmd_node {
>>  	struct drm_exynos_ipp_cmd_work *stop_work;
>>  	struct drm_exynos_ipp_event_work *event_work;
>>  	enum drm_exynos_ipp_state	state;
>> +	struct drm_file	*filp;
>>  };
>>  
>>  /*
>>
> 
> 

