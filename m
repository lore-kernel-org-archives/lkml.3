Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652AbaFRWVk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 18:21:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42702 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927AbaFRWVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 18:21:39 -0400
Date: Wed, 18 Jun 2014 15:25:37 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Benedict Boerger <benedict.boerger@cs.tu-dortmund.de>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH] staging: keucr: fix Missing blank line after declarations
Message-ID: <20140618222537.GA2419@kroah.com>
References: <1402774793-17224-1-git-send-email-benedict.boerger@cs.tu-dortmund.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402774793-17224-1-git-send-email-benedict.boerger@cs.tu-dortmund.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 14, 2014 at 09:39:53PM +0200, Benedict Boerger wrote:
> fix two Missing blank line after declarations issue reported by checkpatch.pl
> 
> Done to complete an eudyptula task.
> 
> Signed-off-by: Benedict Boerger <benedict.boerger@cs.tu-dortmund.de>
> ---
>  drivers/staging/keucr/usb.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/staging/keucr/usb.c b/drivers/staging/keucr/usb.c
> index 12ebde7..dbbd63f 100644
> --- a/drivers/staging/keucr/usb.c
> +++ b/drivers/staging/keucr/usb.c
> @@ -37,6 +37,7 @@ MODULE_DEVICE_TABLE(usb, eucr_usb_ids);
>  static int eucr_suspend(struct usb_interface *iface, pm_message_t message)
>  {
>  	struct us_data *us = usb_get_intfdata(iface);
> +
>  	pr_info("--- eucr_suspend ---\n");
>  	/* Wait until no command is running */
>  	mutex_lock(&us->dev_mutex);
> @@ -53,6 +54,7 @@ static int eucr_resume(struct usb_interface *iface)
>  	u8    tmp = 0;
>  
>  	struct us_data *us = usb_get_intfdata(iface);
> +
>  	pr_info("--- eucr_resume---\n");
>  	mutex_lock(&us->dev_mutex);
>  

Sorry, someone beat you to this file by 2 days, and the fix is now in my
tree :(

greg k-h
