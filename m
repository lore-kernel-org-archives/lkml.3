Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186Ab3FEO2D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 10:28:03 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:49324 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756080Ab3FEO2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 10:28:01 -0400
Date: Wed, 5 Jun 2013 10:27:23 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, will.deacon@arm.com,
        catalin.marinas@arm.com, Ian.Campbell@citrix.com
Subject: Re: [PATCH v3 6/6] MAINTAINERS: add myself as arm64/xen maintainer
Message-ID: <20130605142723.GC4576@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1306041712100.4589@kaball.uk.xensource.com>
 <1370434530-22428-6-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370434530-22428-6-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 01:15:30PM +0100, Stefano Stabellini wrote:
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

(not sure if that is needed, but I am more than happy to have Stefano be
the Xen-ARM guy and I can be the Xen-generic-and-x86 guy).

> ---
>  MAINTAINERS |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index fd3a495..95a6a51 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -9096,6 +9096,13 @@ S:	Supported
>  F:	arch/arm/xen/
>  F:	arch/arm/include/asm/xen/
>  
> +XEN HYPERVISOR ARM64
> +M:	Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> +L:	xen-devel@lists.xensource.com (moderated for non-subscribers)
> +S:	Supported
> +F:	arch/arm64/xen/
> +F:	arch/arm64/include/asm/xen/
> +
>  XEN NETWORK BACKEND DRIVER
>  M:	Ian Campbell <ian.campbell@citrix.com>
>  L:	xen-devel@lists.xensource.com (moderated for non-subscribers)
> -- 
> 1.7.2.5
> 
