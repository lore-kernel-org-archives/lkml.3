Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751164AbaGTEKO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 00:10:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54820 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbaGTEKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 00:10:13 -0400
Date: Sat, 19 Jul 2014 21:09:49 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sam Asadi <asadi.samuel@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Staging: comedi: adv_pci1710.c line over 80 fixed
Message-ID: <20140720040949.GB5875@kroah.com>
References: <1405818950-9858-1-git-send-email-asadi.samuel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405818950-9858-1-git-send-email-asadi.samuel@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 20, 2014 at 04:15:50AM +0300, Sam Asadi wrote:
> A line over 80 issue fixed, which is a comment.
> 
> Signed-off-by: Sam Asadi <asadi.samuel@gmail.com>
> ---
>  drivers/staging/comedi/drivers/adv_pci1710.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/comedi/drivers/adv_pci1710.c b/drivers/staging/comedi/drivers/adv_pci1710.c
> index 602b7a1..13ff78c 100644
> --- a/drivers/staging/comedi/drivers/adv_pci1710.c
> +++ b/drivers/staging/comedi/drivers/adv_pci1710.c
> @@ -723,7 +723,8 @@ static int pci171x_ai_cancel(struct comedi_device *dev,
>  		devpriv->CntrlReg &= Control_CNT0;
>  		devpriv->CntrlReg |= Control_SW;
>  
> -		outw(devpriv->CntrlReg, dev->iobase + PCI171x_CONTROL);	/*  reset any operations */
> +		outw(devpriv->CntrlReg, dev->iobase + PCI171x_CONTROL);
> +						/* reset any operations */

That really doesn't make any sense now, does it?

Please put it _before_ the outw() call.

thanks,

greg k-h
