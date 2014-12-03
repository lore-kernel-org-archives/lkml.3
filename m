Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751442AbaLCReo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 12:34:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55155 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbaLCRen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 12:34:43 -0500
Date: Wed, 3 Dec 2014 09:34:41 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Sean Cleator <seancleator@hotmail.co.uk>
Cc: lidza.louina@gmail.com, markh@compro.net,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: dgnc: Fix long line coding style issues in
 dgnc_cls.h
Message-ID: <20141203173441.GA12889@kroah.com>
References: <BLU437-SMTP66508C574F65742CE8FCDEE97B0@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BLU437-SMTP66508C574F65742CE8FCDEE97B0@phx.gbl>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 05:07:28PM +0000, Sean Cleator wrote:
> A patch to fix the rest of the long line warnings in the dgnc_cls.h file
> found by the checkpatch.pl tool
> 
> Signed-off-by: Sean Cleator <seancleator@hotmail.co.uk>
> 
> ---
>  drivers/staging/dgnc/dgnc_cls.h | 22 +++++++++++++++++-----
>  1 file changed, 17 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/dgnc/dgnc_cls.h b/drivers/staging/dgnc/dgnc_cls.h
> index 465d79a..32034e4 100644
> --- a/drivers/staging/dgnc/dgnc_cls.h
> +++ b/drivers/staging/dgnc/dgnc_cls.h
> @@ -38,7 +38,10 @@
>  struct cls_uart_struct {
>  	u8 txrx;		/* WR  RHR/THR - Holding Reg */
>  	u8 ier;		/* WR  IER - Interrupt Enable Reg */
> -	u8 isr_fcr;		/* WR  ISR/FCR - Interrupt Status Reg/Fifo Control Reg */
> +	u8 isr_fcr;		/*
> +				 * WR  ISR/FCR - Interrupt Status Reg/Fifo
> +				 * Control Reg
> +				 */
>  	u8 lcr;		/* WR  LCR - Line Control Reg */
>  	u8 mcr;		/* WR  MCR - Modem Control Reg */
>  	u8 lsr;		/* WR  LSR - Line Status Reg */
> @@ -61,8 +64,11 @@ struct cls_uart_struct {
>  #define UART_16654_FCR_RXTRIGGER_56	0x80
>  #define UART_16654_FCR_RXTRIGGER_60     0xC0
>  
> -#define UART_IIR_CTSRTS			0x20	/* Received CTS/RTS change of state */
> -#define UART_IIR_RDI_TIMEOUT		0x0C    /* Receiver data TIMEOUT */
> +#define UART_IIR_CTSRTS			0x20	/*
> +						 *  Received CTS/RTS change of
> +						 *  state
> +						 */

That's pretty ugly, don't you think?  How about putting the comments on
the line before the #define, instead of at the end?  That would make
things much nicer to read.

thanks,

greg k-h
