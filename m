Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361Ab3CVMXS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 08:23:18 -0400
Received: from service87.mimecast.com ([91.220.42.44]:33347 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932206Ab3CVMXQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 08:23:16 -0400
Message-ID: <514C4D2F.8030100@arm.com>
Date: Fri, 22 Mar 2013 12:23:11 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        Will Deacon <Will.Deacon@arm.com>, "arnd@arndb.de" <arnd@arndb.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
Subject: Re: [PATCH 3/4] xen: move the xenvm machine to mach-virt
References: <alpine.DEB.2.02.1303211848150.5135@kaball.uk.xensource.com> <1363893380-14309-3-git-send-email-stefano.stabellini@eu.citrix.com>
In-Reply-To: <1363893380-14309-3-git-send-email-stefano.stabellini@eu.citrix.com>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 22 Mar 2013 12:23:12.0459 (UTC) FILETIME=[056541B0:01CE26F8]
X-MC-Unique: 113032212231410401
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/03/13 19:16, Stefano Stabellini wrote:
> xenvm is based on mach-vexpress, move it to mach-virt.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> CC: marc.zyngier@arm.com
> CC: will.deacon@arm.com
> CC: arnd@arndb.de
> CC: rob.herring@calxeda.com

Awesome!

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

> ---
>  arch/arm/mach-vexpress/v2m.c |    1 -
>  arch/arm/mach-virt/virt.c    |    1 +
>  2 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/mach-vexpress/v2m.c b/arch/arm/mach-vexpress/v2m.c
> index 915683c..c43ec78 100644
> --- a/arch/arm/mach-vexpress/v2m.c
> +++ b/arch/arm/mach-vexpress/v2m.c
> @@ -469,7 +469,6 @@ static void __init v2m_dt_init(void)
>  
>  static const char * const v2m_dt_match[] __initconst = {
>  	"arm,vexpress",
> -	"xen,xenvm",
>  	NULL,
>  };
>  
> diff --git a/arch/arm/mach-virt/virt.c b/arch/arm/mach-virt/virt.c
> index 31666f6..528c05e 100644
> --- a/arch/arm/mach-virt/virt.c
> +++ b/arch/arm/mach-virt/virt.c
> @@ -40,6 +40,7 @@ static void __init virt_timer_init(void)
>  
>  static const char *virt_dt_match[] = {
>  	"linux,dummy-virt",
> +	"xen,xenvm",
>  	NULL
>  };
>  
> 


-- 
Jazz is not dead. It just smells funny...

