Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319Ab3AMQkO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 11:40:14 -0500
Received: from cassarossa.samfundet.no ([129.241.93.19]:33036 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755090Ab3AMQkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 11:40:13 -0500
X-Greylist: delayed 2295 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 Jan 2013 11:40:12 EST
Date: Sun, 13 Jan 2013 17:01:52 +0100
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>
Subject: Re: [PATCH 1/9] avr32: Provide dma_mmap_coherent() and
 dma_get_sgtable()
Message-ID: <20130113160152.GA5885@samfundet.no>
References: <1358073890-3610-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1358073890-3610-1-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Sun 13 Jan 2013 11:44:42 +0100 or thereabout, Geert Uytterhoeven wrote:
> avr32/allmodconfig:
> 
> drivers/media/v4l2-core/videobuf2-dma-contig.c: In function ‘vb2_dc_mmap’:
> drivers/media/v4l2-core/videobuf2-dma-contig.c:204: error: implicit declaration of function ‘dma_mmap_coherent’
> drivers/media/v4l2-core/videobuf2-dma-contig.c: In function ‘vb2_dc_get_base_sgt’:
> drivers/media/v4l2-core/videobuf2-dma-contig.c:387: error: implicit declaration of function ‘dma_get_sgtable’
> 
> For architectures using dma_map_ops, dma_mmap_coherent() and
> dma_get_sgtable() are provided in <asm-generic/dma-mapping-common.h>.
> 
> Avr32 does not use dma_map_ops, hence it should implement them as inline
> stubs using dma_common_mmap() and dma_common_get_sgtable().

Thanks for fixing.

> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
> Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

<snipp diff>

-- 
mvh
Hans-Christian Egtvedt
