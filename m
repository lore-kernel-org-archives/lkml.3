Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417Ab3A3IAP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 03:00:15 -0500
Received: from mail.kernel.org ([198.145.19.201]:43591 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391Ab3A3IAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 03:00:12 -0500
Date: Tue, 29 Jan 2013 23:04:30 -0500
From: Greg KH <gregkh@linuxfoundation.org>
To: Jake Champlin <jake.champlin.27@gmail.com>
Cc: abbotti@mev.co.uk, devel@driverdev.osuosl.org,
        fmhess@users.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: Comedi: amplc_dio200: Fixed Bracing Issue
Message-ID: <20130130040430.GA17683@kroah.com>
References: <20130125185404.GA7672@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130125185404.GA7672@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 01:54:08PM -0500, Jake Champlin wrote:
> Fixed Bracing Issue flagged by checkpatch.pl
> 
> Signed-off-by: Jake Champlin <jake.champlin.27@gmail.com>
> ---
>  drivers/staging/comedi/drivers/amplc_dio200.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/amplc_dio200.c b/drivers/staging/comedi/drivers/amplc_dio200.c
> index 5f309ba..b09269d 100644
> --- a/drivers/staging/comedi/drivers/amplc_dio200.c
> +++ b/drivers/staging/comedi/drivers/amplc_dio200.c
> @@ -1977,8 +1977,7 @@ static int dio200_auto_attach(struct comedi_device *dev,
>  		devpriv->io.u.iobase = (unsigned long)base;
>  		devpriv->io.regtype = io_regtype;
>  	}
> -	switch (thisboard->model)
> -	{
> +	switch (thisboard->model) {
>  	case pcie215_model:
>  	case pcie236_model:
>  	case pcie296_model:

Why did you send me the same patch twice here?  You sent this back on
January 18th, and I already applied it to the tree, didn't you get an
email telling you so?

greg k-h
