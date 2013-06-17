Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab3FQTfR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 15:35:17 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:50204 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752915Ab3FQTfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 15:35:14 -0400
X-Sasl-enc: 6ItLSFE9V/lbOiuNRl8VGlti/GS7j31uqTtpa3CiaZqi 1371497706
Date: Mon, 17 Jun 2013 12:35:05 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Simon Horman <horms@verge.net.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jingchang Lu <b35083@freescale.com>,
        Ulrich Hecht <ulrich.hecht@gmail.com>
Subject: Re: linux-next: manual merge of the renesas tree with the tty tree
Message-ID: <20130617193505.GA20255@kroah.com>
References: <20130617171622.450bae1a5319f54004a18e2d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130617171622.450bae1a5319f54004a18e2d@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 05:16:22PM +1000, Stephen Rothwell wrote:
> Hi Simon,
> 
> Today's linux-next merge of the renesas tree got a conflict in
> include/uapi/linux/serial_core.h between commit c9e2e946fb0b ("tty:
> serial: add Freescale lpuart driver support") from the tty tree and
> commit 24610a30600b ("serial: sh-sci: HSCIF support") from the renesas
> tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc include/uapi/linux/serial_core.h
> index c8eaeb5,26eee07..0000000
> --- a/include/uapi/linux/serial_core.h
> +++ b/include/uapi/linux/serial_core.h
> @@@ -226,7 -226,7 +226,10 @@@
>   /* Rocketport EXPRESS/INFINITY */
>   #define PORT_RP2	102
>   
>  +/* Freescale lpuart */
>  +#define PORT_LPUART	103
>  +
> + /* SH-SCI */
>  -#define PORT_HSCIF	103
> ++#define PORT_HSCIF	104

Looks correct to me, thanks.

greg k-h
