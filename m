Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297Ab3B0HvX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 02:51:23 -0500
Received: from multi.imgtec.com ([194.200.65.239]:52644 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846Ab3B0HvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 02:51:22 -0500
Message-ID: <512DBAA6.9090402@imgtec.com>
Date: Wed, 27 Feb 2013 07:49:58 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Marek Szyprowski <m.szyprowski@samsung.com>
CC: <linux-kernel@vger.kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 1/5] metag: Provide dma_get_sgtable()
References: <1361876642-10247-1-git-send-email-james.hogan@imgtec.com> <1361876642-10247-2-git-send-email-james.hogan@imgtec.com> <512DB11F.7080909@samsung.com>
In-Reply-To: <512DB11F.7080909@samsung.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_02_27_07_51_21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/02/13 07:09, Marek Szyprowski wrote:
> Hello,
> 
> On 2/26/2013 12:03 PM, James Hogan wrote:
>> metag/allmodconfig:
>>
>> drivers/media/v4l2-core/videobuf2-dma-contig.c: In function
>> 'vb2_dc_get_base_sgt':
>> drivers/media/v4l2-core/videobuf2-dma-contig.c:387: error: implicit
>> declaration of function 'dma_get_sgtable'
>>
>> For architectures using dma_map_ops, dma_get_sgtable() is provided in
>> <asm-generic/dma-mapping-common.h>.
>>
>> Metag does not use dma_map_ops yet, hence it should implement it as an
>> inline stub using dma_common_get_sgtable().
>>
>> Signed-off-by: James Hogan <james.hogan@imgtec.com>
>> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
>> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> 
> Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

Thanks Marek,

Cheers
James

