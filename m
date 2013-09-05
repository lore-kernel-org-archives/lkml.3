Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab3IEQG0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 12:06:26 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54602 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752250Ab3IEQGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 12:06:25 -0400
Date: Thu, 5 Sep 2013 17:05:36 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH v5 03/13] arm64: define DMA_ERROR_CODE
Message-ID: <20130905160536.GH11887@arm.com>
References: <alpine.DEB.2.02.1308291917290.6397@kaball.uk.xensource.com>
 <1377801154-29215-3-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377801154-29215-3-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 07:32:24PM +0100, Stefano Stabellini wrote:
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> CC: catalin.marinas@arm.com
> CC: will.deacon@arm.com
> ---
>  arch/arm64/include/asm/dma-mapping.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/dma-mapping.h b/arch/arm64/include/asm/dma-mapping.h
> index 8d18100..c2cb8a0 100644
> --- a/arch/arm64/include/asm/dma-mapping.h
> +++ b/arch/arm64/include/asm/dma-mapping.h
> @@ -25,6 +25,7 @@
>  
>  #define ARCH_HAS_DMA_GET_REQUIRED_MASK
>  
> +#define DMA_ERROR_CODE	(~0)

I wonder why this isn't more generic. It looks like most (all?)
architectures define it in the same way.

-- 
Catalin
