Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924AbaGXAzN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 20:55:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60337 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbaGXAzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 20:55:12 -0400
Date: Wed, 23 Jul 2014 17:55:11 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sam Asadi <asadi.samuel@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Staging: comedi: amplc_pc236: a blank line inserted
Message-ID: <20140724005511.GA7698@kroah.com>
References: <1406081188-7619-1-git-send-email-asadi.samuel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406081188-7619-1-git-send-email-asadi.samuel@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 05:06:28AM +0300, Sam Asadi wrote:
> A 'Missing a blank line after declarations' warning fixed by inserting
> a blank line after struct pointer declaration.
> 
> Signed-off-by: Sam Asadi <asadi.samuel@gmail.com>
> ---
>  drivers/staging/comedi/drivers/amplc_pc236.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/staging/comedi/drivers/amplc_pc236.c b/drivers/staging/comedi/drivers/amplc_pc236.c
> index c9a96ad..d0f81f8 100644
> --- a/drivers/staging/comedi/drivers/amplc_pc236.c
> +++ b/drivers/staging/comedi/drivers/amplc_pc236.c
> @@ -515,6 +515,7 @@ static void pc236_detach(struct comedi_device *dev)
>  		comedi_legacy_detach(dev);
>  	} else if (is_pci_board(thisboard)) {
>  		struct pci_dev *pcidev = comedi_to_pci_dev(dev);
> +
>  		if (dev->irq)
>  			free_irq(dev->irq, dev);
>  		comedi_pci_disable(dev);

This is already in my tree, sorry :(

greg k-h
