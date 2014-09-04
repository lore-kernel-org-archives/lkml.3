Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932735AbaIDGZT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 02:25:19 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:62289 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932526AbaIDGZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 02:25:17 -0400
X-AuditID: cbfee68d-f79c46d000000b84-63-540805ca64e9
Message-id: <54080606.3050106@samsung.com>
Date: Thu, 04 Sep 2014 15:26:14 +0900
From: Heesub Shin <heesub.shin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hugh Dickins <hughd@google.com>, Shaohua Li <shli@kernel.org>,
        Jerome Marchand <jmarchan@redhat.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Dan Streetman <ddstreet@ieee.org>, Nitin Gupta <ngupta@vflare.org>,
        Luigi Semenzato <semenzato@google.com>
Subject: Re: [RFC 3/3] zram: add swap_get_free hint
References: <1409794786-10951-1-git-send-email-minchan@kernel.org>
 <1409794786-10951-4-git-send-email-minchan@kernel.org>
In-reply-to: <1409794786-10951-4-git-send-email-minchan@kernel.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t8zHd1TrBwhBkdOqVjMWb+GzeJC224W
	i4OzlzBZPP3Ux2Jx6s91JovLu+awWdxb85/VYtnX9+wWG1pmsVuce1VssfbzY3aLC4fuMznw
	eOycdZfdY8GmUo+nEw4yeWxa1cnmsenTJHaPEzN+s3i833eVzaNvyypGj52fNrN6fN4kF8AV
	xWWTkpqTWZZapG+XwJVxZOIVpoK7vBXfT79jamD8ytXFyMkhIWAisfjNJEYIW0ziwr31bF2M
	XBxCAssYJRat28gIU3TlbxM7RGI6o8SXU6tYIJw3jBIzfvQydTFycPAKaEmcvxQB0sAioCrx
	7uVqdpAwm4C2xKFtwSBhUYEIiQN9z1hBbF4BQYkfk++xgNgiAv4SsyfNB9vFLHCYSWLdplAQ
	W1jAWGL23P/MILaQQLXE8r2/wXo5BZwl7j5tY4Oot5ZYOWkbVK+8xOY1b5khbp7JIfHjCTfE
	OQIS3yYfYgE5R0JAVmLTAagSSYmDK26wTGAUm4XkollIps5CMnUBI/MqRtHUguSC4qT0IkO9
	4sTc4tK8dL3k/NxNjJCY7t3BePuA9SFGAQ5GJR7eghfsIUKsiWXFlbmHGE2BrpjILCWanA9M
	HHkl8YbGZkYWpiamxkbmlmZK4ryKUj+DhQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTBKf9JU
	scx4tihASoOtkHU21+xtf/g5FnBkGGRPrZt2bVuyz/fl/o+Ypri9mzH9hLh57JsGbfm+8l+3
	fvxLuzU9/23d5sRyozMW8dMf+p14wKVx371c98b+XXfDftyUOJ1x1Zl/7j6VEvWZki68uZMb
	in55c6jlqk7OjHoU8PcW156I4pC4DZpKLMUZiYZazEXFiQAbwjz75AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsVy+t9jQd1TrBwhBm0TFSzmrF/DZnGhbTeL
	xcHZS5gsnn7qY7E49ec6k8XlXXPYLO6t+c9qsezre3aLDS2z2C3OvSq2WPv5MbvFhUP3mRx4
	PHbOusvusWBTqcfTCQeZPDat6mTz2PRpErvHiRm/WTze77vK5tG3ZRWjx85Pm1k9Pm+SC+CK
	amC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6W0mh
	LDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYcWTiFaaCu7wV30+/Y2pg/MrV
	xcjJISFgInHlbxM7hC0mceHeerYuRi4OIYHpjBJfTq1igXDeMErM+NHL1MXIwcEroCVx/lIE
	SAOLgKrEu5er2UHCbALaEoe2BYOERQUiJA70PWMFsXkFBCV+TL7HAmKLCPhLzJ40nxHEZhY4
	zCSxblMoiC0sYCwxe+5/ZhBbSKBaYvne32C9nALOEneftrFB1FtLrJy0DapXXmLzmrfMExgF
	ZiFZMQtJ2SwkZQsYmVcxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBKeMZ9I7GFc1WBxiFOBg
	VOLhLXjBHiLEmlhWXJl7iFGCg1lJhHf2WaAQb0piZVVqUX58UWlOavEhRlNgAExklhJNzgem
	s7ySeENjEzMjSyMzYxNzY2Mlcd6DrdaBQgLpiSWp2ampBalFMH1MHJxSDYzLdCdZsDyxWPeS
	L1/76e7jPd03ua7W82hNjTpmtsniyhbZtA1scpw2DN8nLpRXfb5mfxkjt/liMy6TZ9cm+jep
	7uxPluZ7mKAf+jZz5XSury137NU71/C5zNpnpuf9KyKDT25r3tENesdfRS5fs3SjRNSaY6wy
	rlP/rlqz4Mf+pdrppnO5Cm2VWIozEg21mIuKEwHsqkz5LwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Minchan,

First of all, I agree with the overall purpose of your patch set.

On 09/04/2014 10:39 AM, Minchan Kim wrote:
> This patch implement SWAP_GET_FREE handler in zram so that VM can
> know how many zram has freeable space.
> VM can use it to stop anonymous reclaiming once zram is full.
>
> Signed-off-by: Minchan Kim <minchan@kernel.org>
> ---
>   drivers/block/zram/zram_drv.c | 18 ++++++++++++++++++
>   1 file changed, 18 insertions(+)
>
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index 88661d62e46a..8e22b20aa2db 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -951,6 +951,22 @@ static int zram_slot_free_notify(struct block_device *bdev,
>   	return 0;
>   }
>
> +static int zram_get_free_pages(struct block_device *bdev, long *free)
> +{
> +	struct zram *zram;
> +	struct zram_meta *meta;
> +
> +	zram = bdev->bd_disk->private_data;
> +	meta = zram->meta;
> +
> +	if (!zram->limit_pages)
> +		return 1;
> +
> +	*free = zram->limit_pages - zs_get_total_pages(meta->mem_pool);

Even if 'free' is zero here, there may be free spaces available to store 
more compressed pages into the zs_pool. I mean calculation above is not 
quite accurate and wastes memory, but have no better idea for now.

heesub

> +
> +	return 0;
> +}
> +
>   static int zram_swap_hint(struct block_device *bdev,
>   				unsigned int hint, void *arg)
>   {
> @@ -958,6 +974,8 @@ static int zram_swap_hint(struct block_device *bdev,
>
>   	if (hint == SWAP_SLOT_FREE)
>   		ret = zram_slot_free_notify(bdev, (unsigned long)arg);
> +	else if (hint == SWAP_GET_FREE)
> +		ret = zram_get_free_pages(bdev, arg);
>
>   	return ret;
>   }
>
