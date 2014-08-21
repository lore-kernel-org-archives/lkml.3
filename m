Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509AbaHUKiy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 06:38:54 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:51387 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329AbaHUKiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 06:38:52 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-80-53f5cc397cc2
Message-id: <53F5CC38.7060902@samsung.com>
Date: Thu, 21 Aug 2014 12:38:48 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101
 Thunderbird/31.0
MIME-version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linaro-mm-sig@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] dma-mapping: Provide write-combine allocations
References: <1403863018-20033-1-git-send-email-thierry.reding@gmail.com>
 <20140801124057.GA19889@ulmo> <20140801151917.GS30282@n2100.arm.linux.org.uk>
In-reply-to: <20140801151917.GS30282@n2100.arm.linux.org.uk>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrILMWRmVeSWpSXmKPExsVy+t/xa7qWZ74GG5w8Y27xd9IxdosvVx4y
	WXTs+spisenxNVaLy7vmsFncvsxr8XPXPBYHdo+W5h42j9+/JjF67Jx1l91j85J6j9v/HjN7
	fN4kF8AWxWWTkpqTWZZapG+XwJUxec9lxoKLXBUT2ieyNjAe4+hi5OSQEDCRODvrDCOELSZx
	4d56ti5GLg4hgaWMEn9evWGEcD4xSvRNuMEKUsUroCWxpOEFE4jNIqAqsX9zMzOIzSZgKNH1
	tguom4NDVCBK4tjXPIhyQYkfk++xgNgiAkkSP5e+ZAeZyQyyYOLjk8wg9cICbhL/9nNB7JrB
	KLG9dT07SAOngI3E+vk3wHYxC5hJfHl5mBXClpfYvOYt8wRGgVlIdsxCUjYLSdkCRuZVjKKp
	pckFxUnpuYZ6xYm5xaV56XrJ+bmbGCHB/mUH4+JjVocYBTgYlXh4byz6EizEmlhWXJl7iFGC
	g1lJhDdz99dgId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYyThJ2jOBgXRYZwl/1stO2I31kesMBW
	9tvZv5fvLs3mKrJISvgSf+/iphsPRXMcXA+xV7gyfT+q9XBDbeZV0b5sf+OaP/LmTCv2iK0Q
	Zqtl2n9kymnLPRGuzZdimmp5fr/Ztc7pxWQZpZBagZRojz/9ThO/LVLs/Pb9weKj03eoc2p2
	dX56uViJpTgj0VCLuag4EQAetpcQVAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-08-01 17:19, Russell King - ARM Linux wrote:
> On Fri, Aug 01, 2014 at 02:40:59PM +0200, Thierry Reding wrote:
>> On Fri, Jun 27, 2014 at 11:56:58AM +0200, Thierry Reding wrote:
>>> From: Thierry Reding <treding@nvidia.com>
>>>
>>> Provide an implementation for dma_{alloc,free,mmap}_writecombine() when
>>> the architecture supports DMA attributes.
>>>
>>> Signed-off-by: Thierry Reding <treding@nvidia.com>
>>> ---
>>> Changes in v2:
>>> - Add a generic dma_mmap_writecombine() function
>>>
>>>   arch/arm/include/asm/dma-mapping.h       | 16 ----------------
>>>   include/asm-generic/dma-mapping-common.h |  8 --------
>>>   include/linux/dma-mapping.h              | 26 ++++++++++++++++++++++++++
>>>   3 files changed, 26 insertions(+), 24 deletions(-)
>> Ping?
> I have no problem with this, but I don't think I can say yes to it; that
> depends whether other people are happy for this to live in
> include/linux/dma-mapping.h.
>
> I guess consent for this change can only come by no one objecting to it
> after several postings.

I will take this patch my dma-mapping-next tree and later send pull request
to Linus, so it will be handled in a similar way as all other changes to
generic dma-mapping subsystem done in last 2 years.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

