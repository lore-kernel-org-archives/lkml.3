Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750900Ab3HSPLv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 11:11:51 -0400
Received: from mga03.intel.com ([143.182.124.21]:32040 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738Ab3HSPLu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 11:11:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,913,1367996400"; 
   d="scan'208";a="348405219"
Message-ID: <1376925445.2089.492.camel@sauron.fi.intel.com>
Subject: Re: [PATCH RESEND] mtd: MTD_NAND_DENALI should depend on HAS_DMA
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Mon, 19 Aug 2013 18:17:25 +0300
In-Reply-To: <1376823839-5853-1-git-send-email-geert@linux-m68k.org>
References: <1376823839-5853-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-08-18 at 13:03 +0200, Geert Uytterhoeven wrote:
> If NO_DMA=y:
> 
> drivers/built-in.o: In function `denali_remove':
> drivers/mtd/nand/denali.c:1605: undefined reference to `dma_unmap_single'
> drivers/built-in.o: In function `denali_read_page_raw':
> drivers/mtd/nand/denali.c:1190: undefined reference to `dma_sync_single_for_cpu'
> drivers/built-in.o: In function `denali_read_page':
> drivers/mtd/nand/denali.c:1140: undefined reference to `dma_sync_single_for_cpu'
> drivers/built-in.o: In function `write_page':
> drivers/mtd/nand/denali.c:1051: undefined reference to `dma_sync_single_for_cpu'
> drivers/built-in.o: In function `denali_init':
> drivers/mtd/nand/denali.c:1433: undefined reference to `dma_set_mask'
> drivers/mtd/nand/denali.c:1438: undefined reference to `dma_map_single'
> drivers/mtd/nand/denali.c:1442: undefined reference to `dma_mapping_error'
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Pushed to l2-mtd.git, thanks!

-- 
Best Regards,
Artem Bityutskiy

