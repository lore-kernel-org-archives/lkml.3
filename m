Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273AbbAEG5v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 01:57:51 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:33799 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbbAEG5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 01:57:36 -0500
Date: Mon, 5 Jan 2015 12:27:25 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: jitendra kumar khasdev <jkhasdev@gmail.com>
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] Staging: comedi: Fix over 80 character line limit
Message-ID: <20150105065725.GA20220@sudip-PC>
References: <1420439200-3537-1-git-send-email-jkhasdev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420439200-3537-1-git-send-email-jkhasdev@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2015 at 11:56:40AM +0530, jitendra kumar khasdev wrote:
> This is patch to pcl812.c that fix 80 character line limit which is found
> by checkpatch.pl tool.
> I have already sent this patch earlier but it was in 5 different patches,
> this time I have make it into one patch.

this (your comment) should not come in the commit message.
It should be placed below the ---

sudip

> 
> Signed-off-by: Jitendra Kumar Khasdev <jkhasdev@gmail.com>
> ---
>  drivers/staging/comedi/drivers/pcl812.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/pcl812.c b/drivers/staging/comedi/drivers/pcl812.c
> index ac243ca..fe9496a 100644
> --- a/drivers/staging/comedi/drivers/pcl812.c
> +++ b/drivers/staging/comedi/drivers/pcl812.c
> @@ -510,7 +510,8 @@ struct pcl812_private {
>  	unsigned char dma;	/*  >0 use dma ( usedDMA channel) */
>  	unsigned char range_correction;	/*  =1 we must add 1 to range number */
>  	unsigned int last_ai_chanspec;
> -	unsigned char mode_reg_int;	/*  there is stored INT number for some card */
> +	unsigned char mode_reg_int;	/*  there is stored INT number for
> +					 *  some card */
>  	unsigned int ai_poll_ptr;	/*  how many sampes transfer poll */
>  	unsigned int dmapages;
>  	unsigned int hwdmasize;
> @@ -518,9 +519,11 @@ struct pcl812_private {
>  	unsigned int hwdmaptr[2];	/*  HW PTR to DMA buf */
>  	unsigned int dmabytestomove[2];	/*  how many bytes DMA transfer */
>  	int next_dma_buf;	/*  which buffer is next to use */
> -	unsigned int dma_runs_to_end;	/*  how many times we must switch DMA buffers */
> -	unsigned int last_dma_run;	/*  how many bytes to transfer on last DMA buffer */
> -	unsigned int max_812_ai_mode0_rangewait;	/*  setling time for gain */
> +	unsigned int dma_runs_to_end;	/*  how many times we must switch
> +					 *  DMA buffers */
> +	unsigned int last_dma_run;	/*  how many bytes to transfer on
> +					 *  last DMA buffer */
> +	unsigned int max_812_ai_mode0_rangewait;    /* setling time for gain */
>  	unsigned int divisor1;
>  	unsigned int divisor2;
>  	unsigned int use_diff:1;
> @@ -1235,7 +1238,7 @@ static int pcl812_attach(struct comedi_device *dev, struct comedi_devconfig *it)
>  		for (i = 0; i < 2; i++) {
>  			unsigned long dmabuf;
>  
> -			dmabuf =  __get_dma_pages(GFP_KERNEL, devpriv->dmapages);
> +			dmabuf = __get_dma_pages(GFP_KERNEL, devpriv->dmapages);
>  			if (!dmabuf)
>  				return -ENOMEM;
>  
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
