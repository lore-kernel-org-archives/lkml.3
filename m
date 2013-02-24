Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758842Ab3BXRBl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 12:01:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41959 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757363Ab3BXRBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 12:01:40 -0500
Message-ID: <1361725296.2801.386.camel@bling.home>
Subject: Re: [PATCH] drivers/vfio: remove depends on CONFIG_EXPERIMENTAL
From: Alex Williamson <alex.williamson@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Sun, 24 Feb 2013 10:01:36 -0700
In-Reply-To: <20130223073614.GA5108@www.outflux.net>
References: <20130223073614.GA5108@www.outflux.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-02-22 at 23:36 -0800, Kees Cook wrote:
> The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
> while now and is almost always enabled by default. As agreed during the
> Linux kernel summit, remove it from any "depends on" lines in Kconfigs.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> ---
>  drivers/vfio/pci/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> index e84300b..c41b01e 100644
> --- a/drivers/vfio/pci/Kconfig
> +++ b/drivers/vfio/pci/Kconfig
> @@ -9,7 +9,7 @@ config VFIO_PCI
>  
>  config VFIO_PCI_VGA
>  	bool "VFIO PCI support for VGA devices"
> -	depends on VFIO_PCI && X86 && VGA_ARB && EXPERIMENTAL
> +	depends on VFIO_PCI && X86 && VGA_ARB
>  	help
>  	  Support for VGA extension to VFIO PCI.  This exposes an additional
>  	  region on VGA devices for accessing legacy VGA addresses used by

Applied.  Thanks,

Alex

