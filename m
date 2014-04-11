Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484AbaDKKjm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 06:39:42 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:42153 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755939AbaDKKjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 06:39:40 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-05-5347c6692ce6
Message-id: <5347C66C.2040304@samsung.com>
Date: Fri, 11 Apr 2014 12:39:40 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Liu Hua <sdu.liu@huawei.com>, nicolas.pitre@linaro.org
Cc: linux@arm.linux.org.uk, will.deacon@arm.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        wangnan0@huawei.com, peifeiyue@huawei.com, liusdu@126.com
Subject: Re: [PATCH v2 1/2] ARM : DMA : remove useless information about DMA
References: <1397203252-22977-1-git-send-email-sdu.liu@huawei.com>
 <1397203252-22977-2-git-send-email-sdu.liu@huawei.com>
In-reply-to: <1397203252-22977-2-git-send-email-sdu.liu@huawei.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsVy+t/xa7qZx9yDDV79NLPY9Pgaq8XlXXPY
	LG5f5rVY1red2eLTs3/sFvuWnGC3eL5sJbvFjWVT2S1efjzB4sDpsfTmBRaPNfPWMHq0NPew
	ebQcecvqcefaHjaPzUvqPT5vkgtgj+KySUnNySxLLdK3S+DK+PZnJlPBHu6K/4f+szQwTuHs
	YuTkkBAwkVi+bj4bhC0mceHeeiCbi0NIYCmjxO2rP9ghnE+MEnvu72QEqeIV0JJ4vOQRmM0i
	oCrx/ckhsG42AUOJrrddYLaoQIzEyh1HmCDqBSV+TL7HAmKLCFhJ/Lh2E2wDs8AmRokZm2az
	giSEBXwkLrZeAWsQEqiWeLO8CayBU8BZYv+0brChzAJmEo9a1jFD2PISm9e8ZZ7AKDALyY5Z
	SMpmISlbwMi8ilE0tTS5oDgpPddQrzgxt7g0L10vOT93EyMkGr7sYFx8zOoQowAHoxIP74FL
	bsFCrIllxZW5hxglOJiVRHjN97oHC/GmJFZWpRblxxeV5qQWH2Jk4uCUamAMuN7b717CK+Lz
	W+O6Z+il9e6Lp3/XfBq28vlCbtfAc69OaD99mfjIc2btLsa7cWXzJL/UmBq4u3Q8zlgj4pR7
	ZpnT/i8Plco4MyYesU6avc5QU/D0zPrsnGy1bm/jet5CvtpreU8mhPhLhfOecaowW9crK6Ff
	5ZQj0vq/Ys28Tqk3/CfcHyuxFGckGmoxFxUnAgCe4ljJZAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-04-11 10:00, Liu Hua wrote:
> Because commit e9da6e9905e6 has remove custom consistent dma
> region. So the related variable and document should be removed
>
> Signed-off-by: Liu Hua <sdu.liu@huawei.com>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>   Documentation/arm/memory.txt  | 4 ----
>   arch/arm/include/asm/memory.h | 2 --
>   2 files changed, 6 deletions(-)
>
> diff --git a/Documentation/arm/memory.txt b/Documentation/arm/memory.txt
> index 4bfb9ff..8a361c0 100644
> --- a/Documentation/arm/memory.txt
> +++ b/Documentation/arm/memory.txt
> @@ -44,10 +44,6 @@ fffe0000	fffe7fff	ITCM mapping area for platforms with
>   fff00000	fffdffff	Fixmap mapping region.  Addresses provided
>   				by fix_to_virt() will be located here.
>   
> -ffc00000	ffefffff	DMA memory mapping region.  Memory returned
> -				by the dma_alloc_xxx functions will be
> -				dynamically mapped here.
> -
>   ff000000	ffbfffff	Reserved for future expansion of DMA
>   				mapping region.
>   
> diff --git a/arch/arm/include/asm/memory.h b/arch/arm/include/asm/memory.h
> index 02fa255..2b75146 100644
> --- a/arch/arm/include/asm/memory.h
> +++ b/arch/arm/include/asm/memory.h
> @@ -83,8 +83,6 @@
>    */
>   #define IOREMAP_MAX_ORDER	24
>   
> -#define CONSISTENT_END		(0xffe00000UL)
> -
>   #else /* CONFIG_MMU */
>   
>   /*

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

