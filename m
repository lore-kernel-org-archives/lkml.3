Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab3HAUqo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 16:46:44 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39656 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab3HAUqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 16:46:42 -0400
Date: Thu, 1 Aug 2013 21:45:52 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Andreas Herrmann <andreas.herrmann@calxeda.com>
Cc: Rob Herring <rob.herring@calxeda.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>, Will Deacon <will.deacon@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: dma-mapping: highbank: Restrict DMA to 32-bit
	addresses
Message-ID: <20130801204552.GI23006@n2100.arm.linux.org.uk>
References: <20130801204047.GY20842@alberich>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130801204047.GY20842@alberich>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 10:40:47PM +0200, Andreas Herrmann wrote:
> 
> Some devices on Calxeda ECX-2000 are restricted to 32-bit DMA. Thus
> the platform needs to set dma_zone_size, otherwise dma-mapping code is
> complaining, e.g.
> 
>   calxedaxgmac fff50000.ethernet: coherent DMA mask 0xffffffff is smaller than system
>     GFP_DMA mask 0xffffffffffffffff
> 
> Same is true for sata_highbank. For the latter dma_coherent_mask could
> be increased but due to the lack of DMA32 zone we need to adapt
> arm_dma_limit in general.

Please wait until I post my dma mask patches.  Thanks.
