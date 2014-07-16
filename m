Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278AbaGPU3V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 16:29:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54298 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbaGPU3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 16:29:19 -0400
Date: Wed, 16 Jul 2014 13:28:52 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sam Asadi <asadi.samuel@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: comedi: adl_pci9118: a style issue fixed
Message-ID: <20140716202852.GA22789@kroah.com>
References: <1405513452-7628-1-git-send-email-asadi.samuel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405513452-7628-1-git-send-email-asadi.samuel@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 03:24:12PM +0300, Sam Asadi wrote:
> 'quoted string split across lines' warning in checkpatching fixed
> by group whole string in one line.
> 
> Signed-off-by: Sam Asadi <asadi.samuel@gmail.com>
> ---
>  drivers/staging/comedi/drivers/adl_pci9118.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/adl_pci9118.c b/drivers/staging/comedi/drivers/adl_pci9118.c
> index 59a65cb..b2d25f5 100644
> --- a/drivers/staging/comedi/drivers/adl_pci9118.c
> +++ b/drivers/staging/comedi/drivers/adl_pci9118.c
> @@ -412,8 +412,7 @@ static int check_channel_list(struct comedi_device *dev,
> 			if ((CR_AREF(chanlist[i]) == AREF_DIFF) !=
> 			    (differencial)) {
> 				comedi_error(dev,
> -					     "Differencial and single ended "
> -						"inputs can't be mixtured!");
> +					     "Differencial and single ended inputs can't be mixtured!");
> 				return 0;
> 			}
> 			if ((CR_RANGE(chanlist[i]) < PCI9118_BIPOLAR_RANGES) !=
> --

I get a very odd error when trying to apply this patch with git:

$ git am -s ../s1
Applying: Staging: comedi: adl_pci9118: a style issue fixed
fatal: corrupt patch at line 10
Patch failed at 0001 Staging: comedi: adl_pci9118: a style issue fixed
The copy of the patch that failed is found in:
   /home/gregkh/linux/work/staging/.git/rebase-apply/patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

Can you please fix this up and resend it in a format I can apply it in?

thanks,

greg k-h
