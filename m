Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651AbaKMB2p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 20:28:45 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:65238 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136AbaKMB2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 20:28:44 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-98-54640949c129
From: Weijie Yang <weijie.yang@samsung.com>
To: "'Mahendran Ganesh'" <opensource.ganesh@gmail.com>
Cc: "'Minchan Kim'" <minchan@kernel.org>, ngupta@vflare.org,
        sergey.senozhatsky@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
References: <1415803038-7913-1-git-send-email-opensource.ganesh@gmail.com>
 <20141113000216.GA1074@bbox>
In-reply-to: <20141113000216.GA1074@bbox>
Subject: RE: [PATCH] mm/zram: correct ZRAM_ZERO flag bit position
Date: Thu, 13 Nov 2014 09:27:33 +0800
Message-id: <000001cffee1$28362ed0$78a28c70$%yang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/+1Q+V64BeicsdT/qZxTcfBwh5IgAC5yRQ
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsVy+t9jQV0vzpQQg+kHGC0u75rDZnFvzX9W
	i2Vf37NbbGiZxW7Reusxi8Xaz4/ZHdg8ds66y+6xaVUnm8emT5PYPXZ+2szq8XmTXABrFJdN
	SmpOZllqkb5dAlfGs7mzmQr2clYc29/N2sB4m72LkZNDQsBE4vLJz1C2mMSFe+vZQGwhgemM
	EkfPGHQxcgHZfxgl3u7eygqSYBPQlrjbvxHMFgFqblqwlhGkiFmgm1Hi7+oeVojuTImmpZPB
	bE4BTYkX7y+ATRUWcJS4sXwDI4jNIqAqMfX9cSYQm1fATuLb28eMELagxI/J91i6GDmAhqpL
	TJmSCxJmFpCX2LzmLTNIWAIo/OivLsQJRhJHFnYyQZSIS2w8cotlAqPQLCSDZiEMmoVk0Cwk
	HQsYWVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBMfHM+kdjKsaLA4xCnAwKvHwvmBJCRFi
	TSwrrsw9xCjBwawkwmv8KTlEiDclsbIqtSg/vqg0J7X4EKM0B4uSOO/BVutAIYH0xJLU7NTU
	gtQimCwTB6dUA+OcVb2Tj4vHvml9296Q2yWoE1HJlHfMVWrDollJtnp1XTq3Gn31X+Rusf95
	eI+ko1p13Y4nsbemN+elul9aznRuifixzVcVvhzX/upwUTD5/9SadZfLv5+epehRExxt1pG3
	Q3jdYuU9Pts3rDTYqtcv9KLmz8WrfDwm73oZL3/+68z98VazVLMSS3FGoqEWc1FxIgAwoedf
	iwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 8:02 AM, Minchan Kim <minchan@kernel.org> wrote:
> On Wed, Nov 12, 2014 at 10:37:18PM +0800, Mahendran Ganesh wrote:
>> In struct zram_table_entry, the element *value* contains obj size and
>> obj zram flags. Bit 0 to bit (ZRAM_FLAG_SHIFT - 1) represent obj size,
>> and bit ZRAM_FLAG_SHIFT to the highest bit of unsigned long represent obj
>> zram_flags. So the first zram flag(ZRAM_ZERO) should be from ZRAM_FLAG_SHIFT
>> instead of (ZRAM_FLAG_SHIFT + 1).
>>
>> This patch fixes this issue.
>>
>> Also this patch fixes a typo, "page in now accessed" -> "page is now accessed"
>>
>> Signed-off-by: Mahendran Ganesh <opensource.ganesh@gmail.com>
> Acked-by: Minchan Kim <minchan@kernel.org>

Acked-by: Weijie Yang <weijie.yang@samsung.com>

> To be clear about "fixes this issue", it's not a bug but just clean up
> so it doesn't change any behavior.
>
> Thanks!
>
> --
> Kind regards,
> Minchan Kim
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


