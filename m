Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400AbbACMVK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 07:21:10 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:57990 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbbACMVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 07:21:07 -0500
Date: Sat, 3 Jan 2015 17:50:56 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: jitendra kumar khasdev <jkhasdev@gmail.com>
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, pankaj.saraf@nektech.in
Subject: Re: [PATCH 1/5] Staging: comedi: fix line over 80 characters warning
Message-ID: <20150103122056.GA4765@sudip-PC>
References: <1420274187-6779-1-git-send-email-jkhasdev@gmail.com>
 <1420274187-6779-2-git-send-email-jkhasdev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420274187-6779-2-git-send-email-jkhasdev@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 03, 2015 at 02:06:23PM +0530, jitendra kumar khasdev wrote:
> This is patch to file pcl812.c that fix up warning line
> over 80 character which is found by checkpatch tool.
> 
> Singed-off-by: Jitendra Kumar Khasdev <jkhasdev@gmail.com>

what is Singed-off ??? why you are doing Signed-off manually? let git do it..

thanks
sudip

> ---
>  drivers/staging/comedi/drivers/pcl812.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/comedi/drivers/pcl812.c b/drivers/staging/comedi/drivers/pcl812.c
> index ac243ca..24eb601 100644
> --- a/drivers/staging/comedi/drivers/pcl812.c
> +++ b/drivers/staging/comedi/drivers/pcl812.c
> @@ -510,7 +510,8 @@ struct pcl812_private {
>  	unsigned char dma;	/*  >0 use dma ( usedDMA channel) */
>  	unsigned char range_correction;	/*  =1 we must add 1 to range number */
>  	unsigned int last_ai_chanspec;
> -	unsigned char mode_reg_int;	/*  there is stored INT number for some card */
> +	unsigned char mode_reg_int;	/*  there is stored INT number
> +					    for some card */
>  	unsigned int ai_poll_ptr;	/*  how many sampes transfer poll */
>  	unsigned int dmapages;
>  	unsigned int hwdmasize;
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
