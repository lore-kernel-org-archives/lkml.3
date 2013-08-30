Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940Ab3H3MyH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 08:54:07 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:41840 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754792Ab3H3MyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 08:54:06 -0400
Date: Fri, 30 Aug 2013 13:52:56 +0100
From: Mark Einon <mark.einon@gmail.com>
To: Rupesh Gujare <rupesh.gujare@atmel.com>
Cc: devel@linuxdriverproject.org, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] staging: ozwpan: change max. TX frame size supported.
Message-ID: <20130830125255.GA16484@laugharne.auvation.com>
References: <1377279213-17074-1-git-send-email-rupesh.gujare@atmel.com>
 <1377279213-17074-6-git-send-email-rupesh.gujare@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377279213-17074-6-git-send-email-rupesh.gujare@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 06:33:33PM +0100, Rupesh Gujare wrote:
> Max. TX frame size supported is changed to 760 bytes.

Hi Rupesh,

>From the comment, this looks like an arbitrary change for no reason.
Why are you changing the TX frame size to 760 - and can we add the
reason to the changelog?

Cheers,

Mark


> 
> Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
> ---
>  drivers/staging/ozwpan/ozproto.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/ozwpan/ozproto.h b/drivers/staging/ozwpan/ozproto.h
> index e532347..0c49c8a 100644
> --- a/drivers/staging/ozwpan/ozproto.h
> +++ b/drivers/staging/ozwpan/ozproto.h
> @@ -19,7 +19,7 @@
>  #define OZ_PRESLEEP_TOUT	11
>  
>  /* Maximun sizes of tx frames. */
> -#define OZ_MAX_TX_SIZE		1514
> +#define OZ_MAX_TX_SIZE		760
>  
>  /* Maximum number of uncompleted isoc frames that can be pending in network. */
>  #define OZ_MAX_SUBMITTED_ISOC	16
> -- 
> 1.7.9.5
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
