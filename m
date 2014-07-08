Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986AbaGHK2i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 06:28:38 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:20447 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753AbaGHK2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 06:28:37 -0400
Date: Tue, 8 Jul 2014 13:28:30 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Cheng-Wei Lee <lee.rhapsody@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>,
        Avinash Kumar <avi.kp.137@gmail.com>,
        Peter Senna Tschudin <peter.senna@gmail.com>,
        devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] staging: wlan-ng/hfa384x_usb.c: add blank line after
 declarations
Message-ID: <20140708102830.GK25880@mwanda>
References: <CAJKoSVTzYbuzmh6NOpXZ8hd5B_X3fWoik_w9AQJ=0RaCo40rBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJKoSVTzYbuzmh6NOpXZ8hd5B_X3fWoik_w9AQJ=0RaCo40rBA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 11:25:33PM +0800, Cheng-Wei Lee wrote:
> This patch fixes the following checkpatch.pl issues in hfa384x_usb.c:
> WARNING: Missing a blank line after declarations
> 
> Signed-off-by: Quentin Lee <lee.rhapsody@gmail.com>
> ---
>  drivers/staging/wlan-ng/hfa384x_usb.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c
> b/drivers/staging/wlan-ng/hfa384x_usb.c
> index 07cee56..99e2f2d 100644
> --- a/drivers/staging/wlan-ng/hfa384x_usb.c
> +++ b/drivers/staging/wlan-ng/hfa384x_usb.c
> @@ -3533,7 +3533,7 @@ static void hfa384x_usbin_rx(wlandevice_t
> *wlandev, struct sk_buff *skb)
>  	}
> 
>  done:
> -	return;
> +	pr_debug("hfa384x_usbin_rx: done\n");

Don't add this stuff.  Just delete the useless label.

regards,
dan carpenter

