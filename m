Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbbAMRN6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 12:13:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49099 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbbAMRN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 12:13:57 -0500
Date: Tue, 13 Jan 2015 09:13:54 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Emrys Bayliss <emrys@paradise.net.nz>
Cc: forest@alittletooquiet.net, tvboxspy@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: vt6656: Code cleanup: remove unreachable return
Message-ID: <20150113171354.GB12822@kroah.com>
References: <1421168860-30054-1-git-send-email-emrys@paradise.net.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421168860-30054-1-git-send-email-emrys@paradise.net.nz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 04:07:40AM +1100, Emrys Bayliss wrote:
> This patch removes an unnecessary return statement that cannot be reached.
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
>  }
>  
>  static u16 vnt_rxtx_rts(struct vnt_usb_send_context *tx_context,
> -- 
> 2.2.1

You already sent this patch before and it was accepted, right?  If so,
please always tell me, I have no short term memory for patches as I get
1000 emails a day to deal with.  Always properly version your patches if
you need/want it to superseed a previous patch.

dropped from my queue due to confusion,

greg k-h
