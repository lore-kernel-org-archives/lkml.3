Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934268Ab3JPUks (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 16:40:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37257 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934138Ab3JPUkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 16:40:46 -0400
Date: Wed, 16 Oct 2013 13:40:44 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Matthias Beyer <mail@beyermatthias.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/5] drivers: usb: core: devio.c: Put arguments on new
 line
Message-ID: <20131016204044.GB6701@kroah.com>
References: <20131014181214.GB6023@kroah.com>
 <1381780000-23327-1-git-send-email-mail@beyermatthias.de>
 <1381780000-23327-6-git-send-email-mail@beyermatthias.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381780000-23327-6-git-send-email-mail@beyermatthias.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 09:46:40PM +0200, Matthias Beyer wrote:
> To fit the 80-cols convention, this patch moves the arguments (the
> second and third one) for driver->unlocked_ioctl() onto a new line.
> 
> Signed-off-by: Matthias Beyer <mail@beyermatthias.de>
> ---
>  drivers/usb/core/devio.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
> index 9761a27..0387948 100644
> --- a/drivers/usb/core/devio.c
> +++ b/drivers/usb/core/devio.c
> @@ -1870,7 +1870,8 @@ static int proc_ioctl(struct dev_state *ps, struct usbdevfs_ioctl *ctl)
>  			if (driver == NULL || driver->unlocked_ioctl == NULL) {
>  				retval = -ENOTTY;
>  			} else {
> -				retval = driver->unlocked_ioctl(intf, ctl->ioctl_code, buf);
> +				retval = driver->unlocked_ioctl(intf,
> +						ctl->ioctl_code, buf);

Nah, it looks worse this way, just leave it alone.

thanks,

greg k-h
