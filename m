Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbaKKLQT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:16:19 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:7816 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752285AbaKKLQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:16:17 -0500
X-IronPort-AV: E=Sophos;i="5.07,360,1413244800"; 
   d="scan'208";a="191515657"
Date: Tue, 11 Nov 2014 11:16:03 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        David Vrabel <david.vrabel@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 0/13] introduce GNTTABOP_cache_flush
In-Reply-To: <20141110184446.GJ25609@e104818-lin.cambridge.arm.com>
Message-ID: <alpine.DEB.2.02.1411111115400.26318@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1411101607130.22875@kaball.uk.xensource.com> <20141110184446.GJ25609@e104818-lin.cambridge.arm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Nov 2014, Catalin Marinas wrote:
> On Mon, Nov 10, 2014 at 04:12:40PM +0000, Stefano Stabellini wrote:
> > this patch series introduces support for GNTTABOP_cache_flush to perform
> > cache maintenance operation on foreign pages and reverts the current
> > code based on XENFEAT_grant_map_identity.
> > 
> > It also provides a very slow fallback by bouncing on the swiotlb buffer,
> > in case the hypercall is not available.
> > 
> > v7 introduces a flag named dma_coherent in dev_archdata and an accessor
> > function named is_device_dma_coherent in asm/dma-mapping.h under arm and
> > arm64.
> 
> Apart from a few minor comments I gave already, the series looks fine to
> me. Once addressed, you can add:
> 
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

Thank you very much for your help!
