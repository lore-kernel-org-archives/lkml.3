Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674Ab3LBIWe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 03:22:34 -0500
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:54755 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab3LBIWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 03:22:32 -0500
Date: Mon, 2 Dec 2013 09:22:26 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -rc1] s390: increase the NR_CPUS limit
Message-ID: <20131202082226.GA3690@osiris>
References: <1385739182-3687-1-git-send-email-xose.vazquez@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385739182-3687-1-git-send-email-xose.vazquez@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120208-3548-0000-0000-0000075473BA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 29, 2013 at 04:33:02PM +0100, Xose Vazquez Perez wrote:
> In current models, maximum number of active cores is 101.
> 
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: <linux390@de.ibm.com>
> Cc: <linux-s390@vger.kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  arch/s390/Kconfig | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
> index 314fced..87afb9a 100644
> --- a/arch/s390/Kconfig
> +++ b/arch/s390/Kconfig
> @@ -347,14 +347,14 @@ config SMP
>  	  Even if you don't know what to do here, say Y.
> 
>  config NR_CPUS
> -	int "Maximum number of CPUs (2-64)"
> -	range 2 64
> +	int "Maximum number of CPUs (2-101)"
> +	range 2 101
>  	depends on SMP
>  	default "32" if !64BIT
>  	default "64" if 64BIT
>  	help
>  	  This allows you to specify the maximum number of CPUs which this
> -	  kernel will support.  The maximum supported value is 64 and the
> +	  kernel will support.  The maximum supported value is 101 and the
>  	  minimum value which makes sense is 2.

Hi Xose,

I modified your patch and applied a version which changes the maximum
value to 256 instead.

Thanks!

