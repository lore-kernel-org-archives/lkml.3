Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219AbaGRXNm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 19:13:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46888 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaGRXNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 19:13:41 -0400
Date: Fri, 18 Jul 2014 16:13:40 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sam Asadi <asadi.samuel@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Staging: comedi: adl_pci9118: commenting style issue
 fixed
Message-ID: <20140718231340.GA24825@kroah.com>
References: <1405714388-13375-1-git-send-email-asadi.samuel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405714388-13375-1-git-send-email-asadi.samuel@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 11:13:07PM +0300, Sam Asadi wrote:
> A 'quoted string split across lines' issue fixed, while a better use of
> language applied to the comment.
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

What tree did you refresh this against?  My staging-next branch of
staging.git on git.kernel.org does not have comedi_error() anymore in it
:(

thanks,

greg k-h
