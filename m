Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860AbbAWAEC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 19:04:02 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:50096 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbbAWAD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 19:03:58 -0500
Date: Fri, 23 Jan 2015 02:03:53 +0200
From: Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>
To: Heba Aamer <heba93aamer@gmail.com>
Cc: devel@driverdev.osuosl.org, gclement@baobob.org, tvboxspy@gmail.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        forest@alittletooquiet.net, joe@perches.com,
        silvagustavosilva@gmail.com, fred.chou.nd@gmail.com
Subject: Re: [PATCH v2] staging: vt6655: fix space prohibited before that ','
Message-ID: <20150123000353.GA2332@localhost.localdomain>
References: <20150119101630.GA8264@mohammed-Inspiron-3537>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150119101630.GA8264@mohammed-Inspiron-3537>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 12:16:30PM +0200, Heba Aamer wrote:
> This patch fixes the following checkpatch.pl error:
> fix space prohibited before that ','
> 
> Signed-off-by: Heba Aamer <heba93aamer@gmail.com>
Reviewed-by: Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>

> ---
> v2: added Signed-off line 
> 
>  drivers/staging/vt6655/mac.c |    2 +-
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
> 1.7.9.5
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
