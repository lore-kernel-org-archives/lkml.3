Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135Ab3FGCc1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 22:32:27 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:38225 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643Ab3FGCcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 22:32:25 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee691-b7fef6d000002d62-0a-51b146377ea1
Content-transfer-encoding: 8BIT
Message-id: <51B14644.9070706@samsung.com>
Date: Fri, 07 Jun 2013 11:32:36 +0900
From: =?UTF-8?B?6rmA7Iq57Jqw?= <sw0312.kim@samsung.com>
Reply-to: sw0312.kim@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011
 Thunderbird/16.0.1
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org, sumit.semwal@linaro.org,
        airlied@linux.ie, daniel.vetter@ffwll.ch, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: Re: [RFC][PATCH 1/2] dma-buf: add importer private data to attachment
References: <1369990487-23510-1-git-send-email-sw0312.kim@samsung.com>
 <1369990487-23510-2-git-send-email-sw0312.kim@samsung.com>
 <51AF3BD7.5070001@canonical.com>
In-reply-to: <51AF3BD7.5070001@canonical.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsWyRsSkQNfcbWOgwclmRYvecyeZLBY+vMts
	ceXrezaLs01v2C2+XHnIZHF51xw2i54NW1ktnj69wGZx6u5ndosZk1+yOXB5zGroZfPY+20B
	i8eda3vYPLZ/e8Dqcb/7OJPH7X+PmT36tqxi9Pi8SS6AI4rLJiU1J7MstUjfLoEr42bXY7aC
	S6IVOzfqNDCeE+xi5OSQEDCROPxuLxOELSZx4d56ti5GLg4hgaWMEu8WTmSEKVq+8Q1UYhGj
	xJV9H9hAErwCghI/Jt9j6WLk4GAWkJc4cikbJMwsoC4xad4iZoj6F4wST9+/hKrXknjW84oV
	pJ5FQFXi9g51kDCbgLlE58dLYCVCAgoSVyYeYwcpERUIk9i5OR0kLAJScuQRI8hIZoEuJoml
	v1+B3SYs4Cdx6PQSJohdyxglpj15yAyS4BTQBfpsNytIQkKgl0NiQeMCsASLgIDEt8mHwI6W
	EJCV2HSAGeJJSYmDK26wTGAUn4XktVkIr81C8toCRuZVjKKpBckFxUnpRaZ6xYm5xaV56XrJ
	+bmbGIFxfPrfs4k7GO8fsD7EmAy0cSKzlGhyPjAN5JXEGxqbGVmYmpgaG5lbmpEmrCTOq95i
	HSgkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBMW/F/g0ay9cc/6SzK+1rbNysmN179JbdWLj7
	1Wf/hY6Pz7uoHJsf4vnpzRX2ZSGJEWz+168tVZy36wLfyQe/jKx/FrX7TdlevFAs7cvHA5ef
	1vrY3Jt2tevhqUfbWnXKXwoFmgu/jXOL0P004cnMJMEC68uZG44Hn3V8WiRUYXSqpl5CZ1Vr
	nLESS3FGoqEWc1FxIgCo/OFI+QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMKsWRmVeSWpSXmKPExsVy+t9jAV1zt42BBlPPSFj0njvJZLHw4V1m
	iytf37NZnG16w27x5cpDJovLu+awWfRs2Mpq8fTpBTaLU3c/s1vMmPySzYHLY1ZDL5vH3m8L
	WDzuXNvD5rH92wNWj/vdx5k8bv97zOzRt2UVo8fnTXIBHFENjDYZqYkpqUUKqXnJ+SmZeem2
	St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QFcqKZQl5pQChQISi4uV9O0wTQgNcdO1
	gGmM0PUNCYLrMTJAAwlrGDNudj1mK7gkWrFzo04D4znBLkZODgkBE4nlG9+wQdhiEhfurQey
	uTiEBBYxSlzZ9wEswSsgKPFj8j2WLkYODmYBeYkjl7JBwswC6hKT5i1ihqh/wSjx9P1LqHot
	iWc9r1hB6lkEVCVu71AHCbMJmEt0frwEViIkoCBxZeIxdpASUYEwiZ2b00HCIiAlRx4xgoxk
	Fuhiklj6+xUjSEJYwE/i0OklTBC7ljFKTHvykBkkwSmgK3H43W7WCYyCs5CcOgvh1FlITl3A
	yLyKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzhJPJPewbiqweIQowAHoxIP749VGwKFWBPL
	iitzDzFKcDArifCe0tgYKMSbklhZlVqUH19UmpNafIgxGejRicxSosn5wASWVxJvaGxiZmRp
	ZG5oYWRsTpqwkjjvwVbrQCGB9MSS1OzU1ILUIpgtTBycUg2M2qK12yP17s03iiw84uFfK/7X
	6MAysxOMgU9We5bneR0PdTxyga/72oH2dw67Y7PYZk5/Huhjtt2cueuxuvqvcPHwDRHvixmZ
	ed57GZ6cY3Z1qWi64v7F1SqrD86sePe2bHFVnmrKz79NPf9sp7ioOJvvW1PgP5P7gyabsYKd
	6NaV689y6lxRYinOSDTUYi4qTgQAznAdd1YDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Maarten,

On 2013년 06월 05일 22:23, Maarten Lankhorst wrote:
> Op 31-05-13 10:54, Seung-Woo Kim schreef:
>> dma-buf attachment has only exporter private data, but importer private data
>> can be useful for importer especially to re-import the same dma-buf.
>> To use importer private data in attachment of the device, the function to
>> search attachment in the attachment list of dma-buf is also added.
>>
>> Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
>> ---
>>  drivers/base/dma-buf.c  |   31 +++++++++++++++++++++++++++++++
>>  include/linux/dma-buf.h |    4 ++++
>>  2 files changed, 35 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
>> index 08fe897..a1eaaf2 100644
>> --- a/drivers/base/dma-buf.c
>> +++ b/drivers/base/dma-buf.c
>> @@ -259,6 +259,37 @@ err_attach:
>>  EXPORT_SYMBOL_GPL(dma_buf_attach);
>>  
>>  /**
>> + * dma_buf_get_attachment - Get attachment with the device from dma_buf's
>> + * attachments list
>> + * @dmabuf:	[in]	buffer to find device from.
>> + * @dev:	[in]	device to be found.
>> + *
>> + * Returns struct dma_buf_attachment * attaching the device; may return
>> + * negative error codes.
>> + *
>> + */
>> +struct dma_buf_attachment *dma_buf_get_attachment(struct dma_buf *dmabuf,
>> +						  struct device *dev)
>> +{
>> +	struct dma_buf_attachment *attach;
>> +
>> +	if (WARN_ON(!dmabuf || !dev))
>> +		return ERR_PTR(-EINVAL);
>> +
>> +	mutex_lock(&dmabuf->lock);
>> +	list_for_each_entry(attach, &dmabuf->attachments, node) {
>> +		if (attach->dev == dev) {
>> +			mutex_unlock(&dmabuf->lock);
>> +			return attach;
>> +		}
>> +	}
>> +	mutex_unlock(&dmabuf->lock);
>> +
>> +	return ERR_PTR(-ENODEV);
>> +}
>> +EXPORT_SYMBOL_GPL(dma_buf_get_attachment);
> NAK in any form..
> 
> Spot the race condition between dma_buf_get_attachment and dma_buf_attach....

Both dma_buf_get_attachment and dma_buf_attach has mutet with
dmabuf->lock, and dma_buf_get_attachment is used for get attachment from
same device before calling dma_buf_attach.

While, dma_buf_detach can removes attachment because it does not have
ref count. So importer should check ref count in its importer private
data before calling dma_buf_detach if the importer want to use
dma_buf_get_attachment.

And dma_buf_get_attachment is for the importer, so exporter attach and
detach callback operation should not call it as like exporter detach
callback operation should not call dma_buf_attach if you mean this kind
of race.

If you have other considerations here, please describe more specifically.

Thanks and Best Regards,
- Seung-Woo Kim

> 
> ~Maarten
> 
> 

-- 
Seung-Woo Kim
Samsung Software R&D Center
--

