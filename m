Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751346AbbAMFXY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 00:23:24 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:52422 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbbAMFXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 00:23:23 -0500
Date: Tue, 13 Jan 2015 10:53:12 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Emrys Bayliss <emrys@paradise.net.nz>
Cc: forest@alittletooquiet.net, gregkh@linuxfoundation.org, tvboxspy@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Staging: vt6656: Checkpatch fix: else after break or
 return
Message-ID: <20150113052312.GA3497@sudip-PC>
References: <1421081496-15772-1-git-send-email-emrys@paradise.net.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421081496-15772-1-git-send-email-emrys@paradise.net.nz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 03:51:36AM +1100, Emrys Bayliss wrote:
> This patch fixes the following checkpatch.pl error:
> rxtx.c:588: WARNING: else is not generally useful after a break or return

was the checkpatch error solved with this change? have you checked?

and the checkpatch is giving error at line 558 and not at 588.

> 
> Signed-off-by: Emrys Bayliss <emrys@paradise.net.nz>
> ---
>  drivers/staging/vt6656/rxtx.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
> index ea5140a..0cce140 100644
> --- a/drivers/staging/vt6656/rxtx.c
> +++ b/drivers/staging/vt6656/rxtx.c
> @@ -574,8 +574,6 @@ static u16 vnt_fill_cts_head(struct vnt_usb_send_context *tx_context,
>  
>  		return vnt_rxtx_datahead_g(tx_context, &buf->data_head);
>  	}
> -
> -	return 0;

any reason why this return was removed ?

sudip

>  }
>  
>  static u16 vnt_rxtx_rts(struct vnt_usb_send_context *tx_context,
> -- 
> 2.2.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
