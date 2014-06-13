Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814AbaFMRLf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 13:11:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45864 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615AbaFMRLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 13:11:34 -0400
Date: Fri, 13 Jun 2014 10:15:26 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Cheng-Wei Lee <lee.rhapsody@gmail.com>
Cc: Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>,
        Avinash Kumar <avi.kp.137@gmail.com>,
        Peter Senna Tschudin <peter.senna@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: wlan-ng: fix Missing a blank line after
 declarations warnings
Message-ID: <20140613171526.GA19285@kroah.com>
References: <CAJKoSVTafxWR3eLO=tLv1VSrdyuAp_-eEJWCGBJ+zTRqcp=VVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJKoSVTafxWR3eLO=tLv1VSrdyuAp_-eEJWCGBJ+zTRqcp=VVw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 10:58:14PM +0800, Cheng-Wei Lee wrote:
> Signed-off-by: Quentin Lee <lee.rhapsody@gmail.com>
> ---
>  drivers/staging/wlan-ng/hfa384x_usb.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c
> b/drivers/staging/wlan-ng/hfa384x_usb.c
> index 98343ff7..b87cd6b 100644
> --- a/drivers/staging/wlan-ng/hfa384x_usb.c
> +++ b/drivers/staging/wlan-ng/hfa384x_usb.c
> @@ -3533,7 +3533,6 @@ static void hfa384x_usbin_rx(wlandevice_t
> *wlandev, struct sk_buff *skb)
>  	}
> 
>  done:
> -	return;
>  }

That's a good thing to do, but it is not what you said you did up above
in the changelog entry.

Please make up 2 patches here, one to remove the unneeded return; lines,
and one to fix up the whitespace of variables.

thanks,

greg k-h
