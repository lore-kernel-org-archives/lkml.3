Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873AbaHOP1k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 11:27:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40571 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbaHOP0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 11:26:42 -0400
Date: Fri, 15 Aug 2014 14:27:40 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Avinash kumar <avi.kp.137@gmail.com>
Cc: forest@alittletooquiet.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: staging: vt6655: wpactl.c  checkpatch clean-up
Message-ID: <20140815062740.GA19324@kroah.com>
References: <1407736978-15814-1-git-send-email-avi.kp.137@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407736978-15814-1-git-send-email-avi.kp.137@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 11:32:58AM +0530, Avinash kumar wrote:
> Cleaned all C99 comments related warnings
> 
> Signed-off-by: Avinash kumar <avi.kp.137@gmail.com>
> 
> ---
>  drivers/staging/vt6655/wpactl.c |   40 +++++++++++++++++++--------------------
>  1 file changed, 20 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/staging/vt6655/wpactl.c b/drivers/staging/vt6655/wpactl.c
> index 8392d4d..96d2562 100644
> --- a/drivers/staging/vt6655/wpactl.c
> +++ b/drivers/staging/vt6655/wpactl.c
> @@ -299,7 +299,7 @@ int wpa_set_keys(PSDevice pDevice, void *ctx,
>  	else
>  		byKeyDecMode = KEY_CTL_WEP;
>  
> -	// Fix HCT test that set 256 bits KEY and Ndis802_11Encryption3Enabled
> +	/* Fix HCT test that set 256 bits KEY and Ndis802_11Encryption3Enabled*/

Why not a ' ' at the end of this line, before the '*/' part?  Yes, it
pushes you over the 80 character limit, but that's ok, it's something to
fix up later.


>  	if (pDevice->eEncryptionStatus == Ndis802_11Encryption3Enabled) {
>  		if (param->u.wpa_key.key_len == MAX_KEY_LEN)
>  			byKeyDecMode = KEY_CTL_TKIP;
> @@ -314,23 +314,23 @@ int wpa_set_keys(PSDevice pDevice, void *ctx,
>  			byKeyDecMode = KEY_CTL_WEP;
>  	}
>  
> -	// Check TKIP key length
> +	/* Check TKIP key length*/

Ok, no excuse this time :)

Please fix this all up and resend.

thanks,

greg k-h
