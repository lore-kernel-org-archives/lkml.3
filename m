Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049Ab3GOEZK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 00:25:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42548 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab3GOEZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 00:25:09 -0400
Date: Sun, 14 Jul 2013 19:59:48 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] driver-core: fix new kernel-doc warning in
 base/platform.c
Message-ID: <20130715025948.GA12595@kroah.com>
References: <51E3459A.7070909@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E3459A.7070909@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 14, 2013 at 05:43:06PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Fix new kernel-doc warning in drivers/base/platform.c:
> 
> Warning(drivers/base/platform.c:528): No description found for parameter 'owner'
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> ---
>  drivers/base/platform.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- lnx-311-rc1.orig/drivers/base/platform.c
> +++ lnx-311-rc1/drivers/base/platform.c
> @@ -522,6 +522,7 @@ static void platform_drv_shutdown(struct
>  /**
>   * __platform_driver_register - register a driver for platform-level devices
>   * @drv: platform driver structure
> + * @owner: owning module/driver
>   */
>  int __platform_driver_register(struct platform_driver *drv,
>  				struct module *owner)

Thanks, I'll queue this up with my next round of patches for Linus.

greg k-h
