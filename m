Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221AbbAYQPo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 11:15:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54775 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140AbbAYQPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 11:15:40 -0500
Date: Sun, 25 Jan 2015 20:05:44 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Mohamed Lotfy Hammad <mohamed.lotfy.hammad@gmail.com>
Cc: devel@driverdev.osuosl.org, forest@alittletooquiet.net, tvboxspy@gmail.com,
        guido@vanguardiasur.com.ar, silvagustavosilva@gmail.com,
        gclement@baobob.org, joe@perches.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix space prohibited before that ','
Message-ID: <20150125120544.GA5848@kroah.com>
References: <20150119103805.GA24731@lotfy1893-Ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150119103805.GA24731@lotfy1893-Ubuntu>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 12:38:06PM +0200, Mohamed Lotfy Hammad wrote:
> This patch fixes the following checkpatch.pl error:
> fix space prohibited before that ','
> 
> Signed-off-by: Mohamed Lotfy Hammad <mohamed.lotfy.hammad@gmail.com>
> ---
>  drivers/staging/vt6655/mac.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/vt6655/mac.c b/drivers/staging/vt6655/mac.c
> index 63c9c7e..3653a2b 100644
> --- a/drivers/staging/vt6655/mac.c
> +++ b/drivers/staging/vt6655/mac.c
> @@ -789,7 +789,7 @@ bool MACbPSWakeup(void __iomem *dwIoBase)
>  
>  	// Check if SyncFlushOK
>  	for (ww = 0; ww < W_MAX_TIMEOUT; ww++) {
> -		VNSvInPortB(dwIoBase + MAC_REG_PSCTL , &byOrgValue);
> +		VNSvInPortB(dwIoBase + MAC_REG_PSCTL, &byOrgValue);
>  		if (byOrgValue & PSCTL_WAKEDONE)
>  			break;
>  	}
> -- 
> 2.1.0

Someone else already sent in this patch before you did, sorry :(

greg k-h
