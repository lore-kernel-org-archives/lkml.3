Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab3HEWGb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 18:06:31 -0400
Received: from smtp.citrix.com ([66.165.176.89]:58536 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755208Ab3HEWG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 18:06:26 -0400
X-IronPort-AV: E=Sophos;i="4.89,821,1367971200"; 
   d="scan'208";a="41526244"
Date: Mon, 5 Aug 2013 23:04:52 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        <stefano.stabellini@eu.citrix.com>
Subject: Re: [PATCH 2/3] MAINTAINERS: Update the Xen subsystem's with proper
 mailing list.
In-Reply-To: <1375725937-22930-3-git-send-email-konrad.wilk@oracle.com>
Message-ID: <alpine.DEB.2.02.1308052304420.4893@kaball.uk.xensource.com>
References: <1375725937-22930-1-git-send-email-konrad.wilk@oracle.com> <1375725937-22930-3-git-send-email-konrad.wilk@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Aug 2013, Konrad Rzeszutek Wilk wrote:
> And also drop the virtualization one since we don't really use it.
> 
> CC: stefano.stabellini@eu.citrix.com
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>


>  MAINTAINERS | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 440af74..785f56a 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -9237,8 +9237,7 @@ F:	drivers/media/tuners/tuner-xc2028.*
>  
>  XEN HYPERVISOR INTERFACE
>  M:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> -L:	xen-devel@lists.xensource.com (moderated for non-subscribers)
> -L:	virtualization@lists.linux-foundation.org
> +L:	xen-devel@lists.xenproject.org (moderated for non-subscribers)
>  S:	Supported
>  F:	arch/x86/xen/
>  F:	drivers/*/xen-*front.c
> @@ -9249,35 +9248,35 @@ F:	include/uapi/xen/
>  
>  XEN HYPERVISOR ARM
>  M:	Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> -L:	xen-devel@lists.xensource.com (moderated for non-subscribers)
> +L:	xen-devel@lists.xenproject.org (moderated for non-subscribers)
>  S:	Supported
>  F:	arch/arm/xen/
>  F:	arch/arm/include/asm/xen/
>  
>  XEN HYPERVISOR ARM64
>  M:	Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> -L:	xen-devel@lists.xensource.com (moderated for non-subscribers)
> +L:	xen-devel@lists.xenproject.org (moderated for non-subscribers)
>  S:	Supported
>  F:	arch/arm64/xen/
>  F:	arch/arm64/include/asm/xen/
>  
>  XEN NETWORK BACKEND DRIVER
>  M:	Ian Campbell <ian.campbell@citrix.com>
> -L:	xen-devel@lists.xensource.com (moderated for non-subscribers)
> +L:	xen-devel@lists.xenproject.org (moderated for non-subscribers)
>  L:	netdev@vger.kernel.org
>  S:	Supported
>  F:	drivers/net/xen-netback/*
>  
>  XEN PCI SUBSYSTEM
>  M:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> -L:	xen-devel@lists.xensource.com (moderated for non-subscribers)
> +L:	xen-devel@lists.xenproject.org (moderated for non-subscribers)
>  S:	Supported
>  F:	arch/x86/pci/*xen*
>  F:	drivers/pci/*xen*
>  
>  XEN SWIOTLB SUBSYSTEM
>  M:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> -L:	xen-devel@lists.xensource.com (moderated for non-subscribers)
> +L:	xen-devel@lists.xenproject.org (moderated for non-subscribers)
>  S:	Supported
>  F:	arch/x86/xen/*swiotlb*
>  F:	drivers/xen/*swiotlb*
> -- 
> 1.8.3.1
> 
