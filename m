Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab3KYBTp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 20:19:45 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:36515 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab3KYBTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 20:19:42 -0500
Date: Sun, 24 Nov 2013 19:19:38 -0600
From: rkuo <rkuo@codeaurora.org>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: linux-hexagon@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch: hexagon: Kconfig: add HAVE_DMA_ATTR in Kconfig and
 remove "linux/dma-mapping.h" from "asm/dma-mapping.h"
Message-ID: <20131125011938.GB18921@codeaurora.org>
References: <528AEFB7.4060301@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528AEFB7.4060301@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 12:57:27PM +0800, Chen Gang wrote:
> When HAS_DMA, and also need use generic implementation, HAVE_DMA_ATTR
> must be enabled, or can not pass compiling with allmodconfig, the
> related error:
> 
>     CC [M]  drivers/ata/libata-core.o
>   drivers/ata/libata-core.c: In function 'ata_sg_clean':
>   drivers/ata/libata-core.c:4598:3: error: implicit declaration of function 'dma_unmap_sg' [-Werror=implicit-function-declaration]
>   drivers/ata/libata-core.c: In function 'ata_sg_setup':
>   drivers/ata/libata-core.c:4708:2: error: implicit declaration of function 'dma_map_sg' [-Werror=implicit-function-declaration]
> 
> "linux/dma-mapping.h" will include "asm/dma-mapping.h", so need remove
> "linux/dma-mapping.h" from "asm/dma-mapping.h",
> 
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>

Acked-by: Richard Kuo <rkuo@codeaurora.org>

-- 

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
