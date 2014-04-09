Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933060AbaDIMB3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 08:01:29 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:22114 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932542AbaDIMB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 08:01:28 -0400
Date: Wed, 9 Apr 2014 15:01:08 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Richard Leitner <me@g0hl1n.net>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: comedi: adl_pci9118: fix whitespace issues
Message-ID: <20140409120108.GF4912@mwanda>
References: <8d54353f462d3d5bf51ad68b32bd88bb@webmail-alfa3028.alfahosting-server.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d54353f462d3d5bf51ad68b32bd88bb@webmail-alfa3028.alfahosting-server.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 01:35:37PM +0200, Richard Leitner wrote:
> Removed not needed spaces and fixed too long lines
> 
> PS: this is an exercise to get into the "patch submitting workflow"

Put the "PS" after the --- cut off.  Otherwise it's not a PS but a part
of the permanent changelog.

> 
> Signed-off-by: Richard Leitner <me@g0hl1n.net>
> ---
>  drivers/staging/comedi/drivers/adl_pci9118.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/adl_pci9118.c
> b/drivers/staging/comedi/drivers/adl_pci9118.c
> index 3cfa175..d028d6b 100644
> --- a/drivers/staging/comedi/drivers/adl_pci9118.c
> +++ b/drivers/staging/comedi/drivers/adl_pci9118.c
> @@ -96,7 +96,7 @@ Configuration options:
>  				 * correct channel number on every 12 bit sample
>  				 */
> 
> -#define IORANGE_9118		64	/* I hope */
> +#define IORANGE_9118	64	/* I hope */
>  #define PCI9118_CHANLEN	255	/*
>  				 * len of chanlist, some source say 256,
>  				 * but reality looks like 255 :-(
> @@ -356,7 +356,7 @@ struct pci9118_private {
>  	unsigned int ai_data_len;
>  	unsigned short ao_data[2];		/* data output buffer */
>  	unsigned int ai_scans;			/* number of scans to do */
> -	char dma_doublebuf;			/* we can use double buffering */
> +	char dma_doublebuf;			/* we can use double buffering*/

Just leave this one as-is.  The original was better for human beings.
Human beings are more important than checkpatch.pl.

>  	unsigned int dma_actbuf;		/* which buffer is used now */
>  	unsigned short *dmabuf_virt[2];		/*
>  						 * pointers to begin of
> @@ -383,7 +383,7 @@ struct pci9118_private {
>  						 * users(0-AI, 1-AO, 2-DI, 3-DO)
>  						 */
>  	unsigned int cnt0_divisor;		/* actual CNT0 divisor */
> -	void (*int_ai_func) (struct comedi_device *, struct
> comedi_subdevice *,
> +	void (*int_ai_func)(struct comedi_device *, struct comedi_subdevice *,

You're email is line wrapping patches so they won't apply.  Read
Documentation/email-clients.txt or use git send-email.

regards,
dan carpenter

