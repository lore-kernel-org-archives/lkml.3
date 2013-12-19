Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935Ab3LSSWf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 13:22:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44411 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754814Ab3LSSWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 13:22:34 -0500
Date: Thu, 19 Dec 2013 10:22:36 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Matthias Beyer <mail@beyermatthias.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>, linux-usb@vger.kernel.org,
        josh@joshtriplett.org
Subject: Re: [PATCH 1/7] drivers: usb: Include appropriate header file in
 hcd.c
Message-ID: <20131219182236.GA6253@kroah.com>
References: <0e0e74b4487edd341b66674333d734d5828c7e64.1387439261.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0e0e74b4487edd341b66674333d734d5828c7e64.1387439261.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 03:36:00PM +0530, Rashika Kheria wrote:
> Include appropriate header file include/linux/usb/otg.h in core/hcd.c
> because function usb_bus_start_enum() has its prototype declaration in
> include/linux/usb/otg.h.
> 
> This eliminates the following warning in core/hcd.c:
> drivers/usb/core/hcd.c:2295:5: warning: no previous prototype for ‘usb_bus_start_enum’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> ---
>  drivers/usb/core/hcd.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
> index 6bffb8c..077be7c 100644
> --- a/drivers/usb/core/hcd.c
> +++ b/drivers/usb/core/hcd.c
> @@ -44,6 +44,7 @@
>  
>  #include <linux/usb.h>
>  #include <linux/usb/hcd.h>
> +#include <linux/usb/otg.h>

This patch fails to apply to my usb-next branch of my usb.git tree, so I
can't accept it.

Can you refresh it against that branch and resend it please?

thanks,

greg k-h
