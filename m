Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601AbaAUA4a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 19:56:30 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:50270 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbaAUA4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 19:56:23 -0500
Date: Tue, 21 Jan 2014 09:56:17 +0900
From: Simon Horman <horms@verge.net.au>
To: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: linux-kernel@lists.codethink.co.uk, linux-sh@vger.kernel.org,
        Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [V2] MAINTAINERS: Add dts files for r8 series to SHMOBILE
Message-ID: <20140121005617.GC31997@verge.net.au>
References: <1390234232-943-1-git-send-email-ben.dooks@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390234232-943-1-git-send-email-ben.dooks@codethink.co.uk>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

thanks for your work on this.

On Mon, Jan 20, 2014 at 04:10:32PM +0000, Ben Dooks wrote:
> Add a number of files to the list of files covered by SHMOBILE
> so any changes to these can be reported with get_maintailers.pl
> for the current SHMOILE architectures.

I'm fine with you only addressing r8 and r7 SoCs, I am happy
to make an incremental patch to cover the stragglers (sh7*, emev2).
And I would be even happier if this patch didn't suffer excessive
bike-shedding.  But I think there are some minor inconsistencies in this
patch.

Firstly, I think the subject should probably mention r7 and defconfigs.

> 
> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
> ---
> v2:
>   - add defconfigs and r7 configurations
>   - fix path to dt-bindings
> 
> Cc: Joe Perches <joe@perches.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Magnus Damm <magnus.damm@gmail.com>
> Cc: Simon Horman <horms@verge.net.au>
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-sh@vger.kernel.org
> ---
>  MAINTAINERS | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6c20792..f74d830 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1239,7 +1239,14 @@ Q:	http://patchwork.kernel.org/project/linux-sh/list/
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/horms/renesas.git next
>  S:	Supported
>  F:	arch/arm/mach-shmobile/
> +F:	arch/arm/boot/dts/r8*
> +F:	arch/arm/boot/dts/r7*
> +F:	arch/arm/configs/bockw_defconfig
> +F:	arch/arm/configs/genmai_defconfig
> +F:	arch/arm/configs/lager_defconfig
> +F:	arch/arm/configs/marzen_defconfig

I believe you should ad the following as they are for boards
that use SoCs whose name matches r8*.

arch/arm/configs/armadillo800eva_defconfig
arch/arm/configs/ape6evm_defconfig
arch/arm/configs/koelsch_defconfig

>  F:	drivers/sh/
> +F:	include/dt-bindings/clock/r8a*
>  
>  ARM/SOCFPGA ARCHITECTURE
>  M:	Dinh Nguyen <dinguyen@altera.com>
> -- 
> 1.8.5.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sh" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
