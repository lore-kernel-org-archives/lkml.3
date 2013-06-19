Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964968Ab3FSWwJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 18:52:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37390 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935028Ab3FSWwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 18:52:08 -0400
Date: Wed, 19 Jun 2013 15:52:45 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Anders Hammarquist <iko@iko.pp.se>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] USB: serial: ti_usb_3410_5052: Be explicit about the
 Abbott product ids being product ids.
Message-ID: <20130619225245.GA12282@kroah.com>
References: <201306190021.r5J0LkvQ032449@eskarina.iko.pp.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201306190021.r5J0LkvQ032449@eskarina.iko.pp.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 01:58:49AM +0200, Anders Hammarquist wrote:
> Be explicit about the Abbott product ids being product ids.
> 
> Signed-off-by: Anders Hammarquist <iko@iko.pp.se>
> ---
>  drivers/usb/serial/ti_usb_3410_5052.h |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/serial/ti_usb_3410_5052.h b/drivers/usb/serial/ti_usb_3410_5052.h
> index 4a2423e..ea8b273 100644
> --- a/drivers/usb/serial/ti_usb_3410_5052.h
> +++ b/drivers/usb/serial/ti_usb_3410_5052.h
> @@ -52,9 +52,9 @@
>  
>  /* Abbott Diabetics vendor and product ids */
>  #define ABBOTT_VENDOR_ID		0x1a61
> -#define ABBOTT_STEREO_PLUG_ID		0x3410
> +#define ABBOTT_STEREO_PLUG_PRODUCT_ID	0x3410
>  #define ABBOTT_PRODUCT_ID		ABBOTT_STEREO_PLUG_ID

Can you just delete ABBOTT_PRODUCT_ID here, because if you ever use it,
you will get a build error, right?

I'll just take the first patch for now, please resend this one.

thanks,

greg k-h
