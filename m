Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759252AbaGRBDn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 21:03:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37207 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbaGRBDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 21:03:42 -0400
Date: Thu, 17 Jul 2014 18:03:41 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sam Asadi <asadi.samuel@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Staging: adl_pci9118: a style issue fixed
Message-ID: <20140718010341.GA23072@kroah.com>
References: <1405549583-11415-1-git-send-email-asadi.samuel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405549583-11415-1-git-send-email-asadi.samuel@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 01:26:23AM +0300, Sam Asadi wrote:
> a 'quoted string split across lines' fixed while better use of
> English applied to the text.
> 
> Signed-off-by: Sam Asadi <asadi.samuel@gmail.com>
> ---
>  drivers/staging/comedi/drivers/adl_pci9118.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/adl_pci9118.c b/drivers/staging/comedi/drivers/adl_pci9118.c
> index 93bd9ee..7365f31 100644
> --- a/drivers/staging/comedi/drivers/adl_pci9118.c
> +++ b/drivers/staging/comedi/drivers/adl_pci9118.c
> @@ -418,8 +418,7 @@ static int check_channel_list(struct comedi_device *dev,
>  			if ((CR_RANGE(chanlist[i]) < PCI9118_BIPOLAR_RANGES) !=
>  			    (bipolar)) {
>  				comedi_error(dev,
> -					     "Bipolar and unipolar ranges "
> -							"can't be mixtured!");
> +					     "Bipolar and unipolar ranges can't be mixed!");
>  				return 0;
>  			}
>  			if (!devpriv->usemux && differencial &&
> -- 
> 1.7.10.4

This patch doesn't apply to my tree due to other changes in this same
file.  Can you please refresh it and resend?

thanks,

greg k-h
