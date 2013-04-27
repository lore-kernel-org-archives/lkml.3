Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755784Ab3D0Ofr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 10:35:47 -0400
Received: from smtp.citrix.com ([66.165.176.89]:59264 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754555Ab3D0Ofq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 10:35:46 -0400
X-IronPort-AV: E=Sophos;i="4.87,562,1363132800"; 
   d="scan'208";a="21961243"
Date: Sat, 27 Apr 2013 15:35:39 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Wei Yongjun <weiyj.lk@gmail.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "yongjun_wei@trendmicro.com.cn" <yongjun_wei@trendmicro.com.cn>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] xen/arm: remove duplicated include from
 enlighten.c
In-Reply-To: <CAPgLHd95AtzEDXUMHryWmmVAkBfkh42hgeLKdSLFYwkO_JB-ZA@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1304271535210.4180@kaball.uk.xensource.com>
References: <CAPgLHd95AtzEDXUMHryWmmVAkBfkh42hgeLKdSLFYwkO_JB-ZA@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Apr 2013, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Remove duplicated include.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>


>  arch/arm/xen/enlighten.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
> index 9a0a917..d30042e 100644
> --- a/arch/arm/xen/enlighten.c
> +++ b/arch/arm/xen/enlighten.c
> @@ -10,7 +10,6 @@
>  #include <xen/platform_pci.h>
>  #include <xen/xenbus.h>
>  #include <xen/page.h>
> -#include <xen/xen.h>
>  #include <xen/interface/sched.h>
>  #include <xen/xen-ops.h>
>  #include <asm/xen/hypervisor.h>
> 
