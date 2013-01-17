Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759507Ab3AQKLf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 05:11:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26822 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759486Ab3AQKLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 05:11:33 -0500
Date: Thu, 17 Jan 2013 08:10:57 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 39/86] drivers/edac: remove depends on
 CONFIG_EXPERIMENTAL
Message-ID: <20130117081057.3e3d6b60@redhat.com>
In-Reply-To: <1358391258-1771-40-git-send-email-keescook@chromium.org>
References: <1358391258-1771-1-git-send-email-keescook@chromium.org>
	<1358391258-1771-40-git-send-email-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, 16 Jan 2013 18:53:31 -0800
Kees Cook <keescook@chromium.org> escreveu:

> The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
> while now and is almost always enabled by default. As agreed during the
> Linux kernel summit, remove it from any "depends on" lines in Kconfigs.
> 
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>  drivers/edac/Kconfig |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
> index 6671992..acb709b 100644
> --- a/drivers/edac/Kconfig
> +++ b/drivers/edac/Kconfig
> @@ -158,7 +158,7 @@ config EDAC_I3000
>  
>  config EDAC_I3200
>  	tristate "Intel 3200"
> -	depends on EDAC_MM_EDAC && PCI && X86 && EXPERIMENTAL
> +	depends on EDAC_MM_EDAC && PCI && X86
>  	help
>  	  Support for error detection and correction on the Intel
>  	  3200 and 3210 server chipsets.
> @@ -224,7 +224,7 @@ config EDAC_I7300
>  config EDAC_SBRIDGE
>  	tristate "Intel Sandy-Bridge Integrated MC"
>  	depends on EDAC_MM_EDAC && PCI && X86_64 && X86_MCE_INTEL
> -	depends on PCI_MMCONFIG && EXPERIMENTAL
> +	depends on PCI_MMCONFIG
>  	help
>  	  Support for error detection and correction the Intel
>  	  Sandy Bridge Integrated Memory Controller.


-- 

Cheers,
Mauro
