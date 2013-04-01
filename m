Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919Ab3DARLA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 13:11:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:49401 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab3DARK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 13:10:59 -0400
Message-ID: <5159B196.10005@infradead.org>
Date: Mon, 01 Apr 2013 09:11:02 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: linux-kernel@vger.kernel.org, Andy King <acking@vmware.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dtor@vmware.com>
Subject: Re: [PATCH] misc/vmw_vmci: VMWARE_VMCI depends on NET
References: <1364791439-28396-1-git-send-email-linux@roeck-us.net>
In-Reply-To: <1364791439-28396-1-git-send-email-linux@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/13 21:43, Guenter Roeck wrote:
> Fix:
> 
> ERROR: "memcpy_toiovec" [drivers/misc/vmw_vmci/vmw_vmci.ko] undefined!
> ERROR: "memcpy_fromiovec" [drivers/misc/vmw_vmci/vmw_vmci.ko] undefined!
> 
> Both functions are defined in the core networking code.
> 
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
>  drivers/misc/vmw_vmci/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/misc/vmw_vmci/Kconfig b/drivers/misc/vmw_vmci/Kconfig
> index 39c2eca..ea98f7e 100644
> --- a/drivers/misc/vmw_vmci/Kconfig
> +++ b/drivers/misc/vmw_vmci/Kconfig
> @@ -4,7 +4,7 @@
>  
>  config VMWARE_VMCI
>  	tristate "VMware VMCI Driver"
> -	depends on X86 && PCI
> +	depends on X86 && PCI && NET
>  	help
>  	  This is VMware's Virtual Machine Communication Interface.  It enables
>  	  high-speed communication between host and guest in a virtual
> 


-- 
~Randy
