Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230AbaIITCO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 15:02:14 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:47085 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbaIITCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 15:02:13 -0400
Date: Tue, 9 Sep 2014 22:02:00 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Nitin Kuppelur <nitinkuppelur@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: octeon-hcd: removed dummy label
Message-ID: <20140909190200.GT6600@mwanda>
References: <1410276139-7212-1-git-send-email-nitinkuppelur@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410276139-7212-1-git-send-email-nitinkuppelur@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 05:22:19PM +0200, Nitin Kuppelur wrote:
> This is a patch to the octeon-hcd.c file that
> removes dummy label i.e. label followed by return of
> void function
> 
> Signed-off-by: Nitin Kuppelur <nitinkuppelur@gmail.com>
> ---
>  drivers/staging/octeon-usb/octeon-hcd.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/octeon-usb/octeon-hcd.c b/drivers/staging/octeon-usb/octeon-hcd.c
> index 8a80982..5fffef2 100644
> --- a/drivers/staging/octeon-usb/octeon-hcd.c
> +++ b/drivers/staging/octeon-usb/octeon-hcd.c
> @@ -2253,9 +2253,8 @@ static void __cvmx_usb_perform_complete(
>  			/* Increment to the next location in our packet array */
>  			transaction->iso_packets++;
>  			transaction->stage = CVMX_USB_STAGE_NON_CONTROL;
> -			goto done;
> +			return;
>  		}
> -	}
>  

Wat?  Does this still compile without the curly brace?

regards,
dan carpenter

