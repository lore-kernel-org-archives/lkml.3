Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695AbaF0ESt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 00:18:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36252 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbaF0ESq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 00:18:46 -0400
Date: Thu, 26 Jun 2014 21:08:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Cheng-Wei Lee <lee.rhapsody@gmail.com>
Cc: Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>,
        Avinash Kumar <avi.kp.137@gmail.com>,
        Peter Senna Tschudin <peter.senna@gmail.com>,
        devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: wlan-ng/hfa384x_usb.c: add blank line after
 declarations
Message-ID: <20140627010825.GA13959@kroah.com>
References: <CAJKoSVTS8vEtND1frBmU8mzZckR3DRC+jPbUGFTswAM-n6J+VQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJKoSVTS8vEtND1frBmU8mzZckR3DRC+jPbUGFTswAM-n6J+VQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 10:43:55PM +0800, Cheng-Wei Lee wrote:
> This patch fixes the following checkpatch.pl issues in hfa384x_usb.c:
> WARNING: Missing a blank line after declarations
> 
> Signed-off-by: Quentin Lee <lee.rhapsody@gmail.com>
> ---
>  drivers/staging/wlan-ng/hfa384x_usb.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c
> b/drivers/staging/wlan-ng/hfa384x_usb.c
> index 98343ff7..07cee56 100644
> --- a/drivers/staging/wlan-ng/hfa384x_usb.c
> +++ b/drivers/staging/wlan-ng/hfa384x_usb.c
> @@ -3705,6 +3705,7 @@ static void hfa384x_usbout_callback(struct urb *urb)
>  		case -EPIPE:
>  			{
>  				hfa384x_t *hw = wlandev->priv;
> +
>  				netdev_warn(hw->wlandev->netdev,
>  					    "%s tx pipe stalled: requesting reset\n",
>  					    wlandev->netdev->name);
> -- 
> 1.7.9.5

You have sent a bunch of patches, and no "version" information as to
which ones to apply and which ones superseed others.

So I've deleted them all from my inbox, can you please resend the proper
ones that you wish to have applied?

thanks,

greg k-h
