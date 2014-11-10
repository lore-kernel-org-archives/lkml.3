Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024AbaKJSpD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 13:45:03 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:55774 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbaKJSpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 13:45:01 -0500
Date: Mon, 10 Nov 2014 18:44:46 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        David Vrabel <david.vrabel@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 0/13] introduce GNTTABOP_cache_flush
Message-ID: <20141110184446.GJ25609@e104818-lin.cambridge.arm.com>
References: <alpine.DEB.2.02.1411101607130.22875@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1411101607130.22875@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 04:12:40PM +0000, Stefano Stabellini wrote:
> this patch series introduces support for GNTTABOP_cache_flush to perform
> cache maintenance operation on foreign pages and reverts the current
> code based on XENFEAT_grant_map_identity.
> 
> It also provides a very slow fallback by bouncing on the swiotlb buffer,
> in case the hypercall is not available.
> 
> v7 introduces a flag named dma_coherent in dev_archdata and an accessor
> function named is_device_dma_coherent in asm/dma-mapping.h under arm and
> arm64.

Apart from a few minor comments I gave already, the series looks fine to
me. Once addressed, you can add:

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
