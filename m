Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab3FEMYI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 08:24:08 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:17874 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130Ab3FEMYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 08:24:06 -0400
X-IronPort-AV: E=Sophos;i="4.87,806,1363132800"; 
   d="scan'208";a="5350958"
Message-ID: <1370435032.24512.191.camel@zakaz.uk.xensource.com>
Subject: Re: [PATCH v3 6/6] MAINTAINERS: add myself as arm64/xen maintainer
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xensource.com>, <will.deacon@arm.com>,
        <catalin.marinas@arm.com>, <konrad.wilk@oracle.com>
Date: Wed, 5 Jun 2013 13:23:52 +0100
In-Reply-To: <1370434530-22428-6-git-send-email-stefano.stabellini@eu.citrix.com>
References: <alpine.DEB.2.02.1306041712100.4589@kaball.uk.xensource.com>
	 <1370434530-22428-6-git-send-email-stefano.stabellini@eu.citrix.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.203.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-05 at 13:15 +0100, Stefano Stabellini wrote:
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Acked-by: Ian Campbell <ian.campbell@citrix.com>

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


