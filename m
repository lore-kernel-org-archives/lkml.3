Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343Ab3LBURG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:17:06 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:19493 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549Ab3LBTR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:17:27 -0500
Date: Mon, 2 Dec 2013 14:17:20 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] swiotlb: update format
Message-ID: <20131202191720.GB18624@phenom.dumpdata.com>
References: <alpine.LNX.2.00.1311271347290.14638@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1311271347290.14638@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 01:48:09PM +0100, Jiri Kosina wrote:
> Documentation/kernel-parameters.txt doesn't contain up-to-date 
> documentation regarding swiotlb= parameter. Update it.

Thanks. Will queue it for 3.14
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> ---
>  Documentation/kernel-parameters.txt |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 50680a5..5577634 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -3061,7 +3061,11 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  			controller if no parameter or 1 is given or disable
>  			it if 0 is given (See Documentation/cgroups/memory.txt)
>  
> -	swiotlb=	[IA-64] Number of I/O TLB slabs
> +	swiotlb=	[ARM,IA-64,PPC,MIPS,X86]
> +			Format: { <int> | force }
> +			<int> -- Number of I/O TLB slabs
> +			force -- force using of bounce buffers even if they
> +			         wouldn't be automatically used by the kernel
>  
>  	switches=	[HW,M68k]
>  
> -- 
> Jiri Kosina
> SUSE Labs
