Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393Ab3ANIiI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 03:38:08 -0500
Received: from ra.se.axis.com ([195.60.68.13]:54993 "EHLO ra.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606Ab3ANIiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 03:38:06 -0500
Date: Mon, 14 Jan 2013 09:38:02 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-cris-kernel@axis.com
Subject: Re: [PATCH 4/9] cris: Provide dma_mmap_coherent() and
 dma_get_sgtable()
Message-ID: <20130114083802.GA23529@axis.com>
References: <1358073890-3610-1-git-send-email-geert@linux-m68k.org>
 <1358073890-3610-4-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1358073890-3610-4-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 13, 2013 at 11:44:45AM +0100, Geert Uytterhoeven wrote:
> cris/allmodconfig:
> 
> drivers/media/v4l2-core/videobuf2-dma-contig.c: In function ‘vb2_dc_mmap’:
> drivers/media/v4l2-core/videobuf2-dma-contig.c:204: error: implicit declaration of function ‘dma_mmap_coherent’
> drivers/media/v4l2-core/videobuf2-dma-contig.c: In function ‘vb2_dc_get_base_sgt’:
> drivers/media/v4l2-core/videobuf2-dma-contig.c:387: error: implicit declaration of function ‘dma_get_sgtable’
> 
> For architectures using dma_map_ops, dma_mmap_coherent() and
> dma_get_sgtable() are provided in <asm-generic/dma-mapping-common.h>.
> 
> Cris does not use dma_map_ops, hence it should implement them as inline
> stubs using dma_common_mmap() and dma_common_get_sgtable().
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: linux-cris-kernel@axis.com

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
