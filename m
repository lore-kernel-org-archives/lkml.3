Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409AbaHLRt5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 13:49:57 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:10463 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920AbaHLRt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 13:49:56 -0400
X-IronPort-AV: E=Sophos;i="5.01,850,1400025600"; 
   d="scan'208";a="161706396"
Date: Tue, 12 Aug 2014 18:48:34 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Andreas Schwab <schwab@linux-m68k.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <xen-devel@lists.xenproject.org>,
        David Vrabel <david.vrabel@citrix.com>
Subject: Re: [PATCH] arm/xen: fix wrong conflict resolution of xen merge
In-Reply-To: <87fvh1vd49.fsf@igel.home>
Message-ID: <alpine.DEB.2.02.1408121846310.2293@kaball.uk.xensource.com>
References: <87fvh1vd49.fsf@igel.home>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Aug 2014, Andreas Schwab wrote:
> Remove duplicate definition of arch_gnttab_init.
> 
> Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>

Thanks for the patch, however David Vrabel already committed a fix for
this.



>  arch/arm/xen/grant-table.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/arch/arm/xen/grant-table.c b/arch/arm/xen/grant-table.c
> index 2c4041c..e437918 100644
> --- a/arch/arm/xen/grant-table.c
> +++ b/arch/arm/xen/grant-table.c
> @@ -49,8 +49,3 @@ int arch_gnttab_init(unsigned long nr_shared)
>  {
>  	return 0;
>  }
> -
> -int arch_gnttab_init(unsigned long nr_shared, unsigned long nr_status)
> -{
> -	return 0;
> -}
> -- 
> 2.0.4
> 
> 
> -- 
> Andreas Schwab, schwab@linux-m68k.org
> GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
> "And now for something completely different."
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
