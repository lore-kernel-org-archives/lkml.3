Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026AbaCaNmf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 09:42:35 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:46249 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617AbaCaNme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 09:42:34 -0400
Date: Mon, 31 Mar 2014 16:42:27 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Denis Pithon <denis.pithon@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, khoroshilov@ispras.ru
Subject: Re: [PATCH] staging/wlan-ng fix small coding style issue
Message-ID: <20140331134227.GP6991@mwanda>
References: <1396271603-12142-1-git-send-email-denis.pithon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396271603-12142-1-git-send-email-denis.pithon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 03:13:23PM +0200, Denis Pithon wrote:
> Signed-off-by: Denis Pithon <denis.pithon@gmail.com>

Changeglog sucks.  It doesn't even exist, actually.  What coding style
issue did you fix?

> ---
>  drivers/staging/wlan-ng/prism2usb.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/staging/wlan-ng/prism2usb.c b/drivers/staging/wlan-ng/prism2usb.c
> index 4739c14..ccb2c2e 100644
> --- a/drivers/staging/wlan-ng/prism2usb.c
> +++ b/drivers/staging/wlan-ng/prism2usb.c
> @@ -293,6 +293,7 @@ static int prism2sta_suspend(struct usb_interface *interface,
>  	hfa384x_t *hw = NULL;
>  	wlandevice_t *wlandev;
>  	wlandev = (wlandevice_t *) usb_get_intfdata(interface);
> +
>  	if (!wlandev)
>  		return -ENODEV;

The blank line should go be one line earlier.

	wlandevice_t *wlandev;
	[blank]
	wlandev = (wlandevice_t *) usb_get_intfdata(interface);

>  
> @@ -315,6 +316,7 @@ static int prism2sta_resume(struct usb_interface *interface)
>  	hfa384x_t *hw = NULL;
>  	wlandevice_t *wlandev;
>  	wlandev = (wlandevice_t *) usb_get_intfdata(interface);
> +

Same.

>  	if (!wlandev)
>  		return -ENODEV;

regards,
dan carpenter

