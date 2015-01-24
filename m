Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121AbbAXJaF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 04:30:05 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:25098 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbbAXJaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 04:30:02 -0500
Date: Sat, 24 Jan 2015 12:29:47 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Sakshi Bansal <sakshi.april5@gmail.com>
Cc: lidza.louina@gmail.com, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: dgnc: dgnc_cls.h: fixed four coding style
 warnings
Message-ID: <20150124092947.GO6456@mwanda>
References: <1422076748-5927-1-git-send-email-sakshi.april5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422076748-5927-1-git-send-email-sakshi.april5@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 24, 2015 at 10:49:08AM +0530, Sakshi Bansal wrote:
> Fixed 80 line warning in the code comments.
> 
> Signed-off-by: Sakshi Bansal <sakshi.april5@gmail.com>
> ---
>  drivers/staging/dgnc/dgnc_cls.h | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/dgnc/dgnc_cls.h b/drivers/staging/dgnc/dgnc_cls.h
> index 465d79a..7444b00 100644
> --- a/drivers/staging/dgnc/dgnc_cls.h
> +++ b/drivers/staging/dgnc/dgnc_cls.h
> @@ -38,7 +38,8 @@
>  struct cls_uart_struct {
>  	u8 txrx;		/* WR  RHR/THR - Holding Reg */
>  	u8 ier;		/* WR  IER - Interrupt Enable Reg */
> -	u8 isr_fcr;		/* WR  ISR/FCR - Interrupt Status Reg/Fifo Control Reg */
> +	u8 isr_fcr;		/* WR  ISR/FCR - Interrupt Status Reg/Fifo
> +				   Control Reg */

These aren't correct kernel style.  To be honest the original looks fine
with me.  (No one cares about checkpatch except if it makes the code
better for human beings).

regards,
dan carpenter

