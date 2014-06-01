Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650AbaFARqF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 13:46:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56549 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbaFARqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 13:46:02 -0400
Date: Sun, 1 Jun 2014 10:45:59 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Johan Hovold <jhovold@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: drop two usb-serial subdriver entries
Message-ID: <20140601174559.GB1281@kroah.com>
References: <1401615137-11862-1-git-send-email-jhovold@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401615137-11862-1-git-send-email-jhovold@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 01, 2014 at 11:32:17AM +0200, Johan Hovold wrote:
> Remove the remaining two obsolete usb-serial subdriver entries from
> MAINTAINERS, which were missed in the recent purge by commit
> f896b7968b62 ("USB: Maintainers change for usb serial drivers").
> 
> Signed-off-by: Johan Hovold <jhovold@gmail.com>
> ---
>  MAINTAINERS | 12 ------------
>  1 file changed, 12 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 51ebb779c5f3..68599b26f514 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -9298,12 +9298,6 @@ S:	Maintained
>  F:	drivers/usb/host/isp116x*
>  F:	include/linux/usb/isp116x.h
>  
> -USB KAWASAKI LSI DRIVER
> -M:	Oliver Neukum <oliver@neukum.org>
> -L:	linux-usb@vger.kernel.org
> -S:	Maintained
> -F:	drivers/usb/serial/kl5kusb105.*
> -
>  USB MASS STORAGE DRIVER
>  M:	Matthew Dharm <mdharm-usb@one-eyed-alien.net>
>  L:	linux-usb@vger.kernel.org
> @@ -9331,12 +9325,6 @@ S:	Maintained
>  F:	Documentation/usb/ohci.txt
>  F:	drivers/usb/host/ohci*
>  
> -USB OPTION-CARD DRIVER
> -M:	Matthias Urlichs <smurf@smurf.noris.de>
> -L:	linux-usb@vger.kernel.org
> -S:	Maintained
> -F:	drivers/usb/serial/option.c


Why are we taking away the maintainership of these individual drivers
from these developers?  I had no problem giving you the drivers I was
supposed to be in charge of, but I need a signed-off-by from Matthias
and Oliver for these if they want to do the same.

thanks,

greg k-h
