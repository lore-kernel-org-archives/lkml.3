Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106AbaHJMLv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 08:11:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42791 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058AbaHJMLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 08:11:48 -0400
Date: Sat, 9 Aug 2014 21:42:04 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Christoph Jaeger <email@christophjaeger.info>
Cc: shigekatsu.tateno@atmel.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/10] staging: ozwpan: Fix typo in typedef
Message-ID: <20140810044204.GA27046@kroah.com>
References: <1407156896-3246-1-git-send-email-email@christophjaeger.info>
 <1407156896-3246-3-git-send-email-email@christophjaeger.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407156896-3246-3-git-send-email-email@christophjaeger.info>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2014 at 02:54:48PM +0200, Christoph Jaeger wrote:
> Signed-off-by: Christoph Jaeger <email@christophjaeger.info>
> ---
>  drivers/staging/ozwpan/ozproto.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/ozwpan/ozproto.h b/drivers/staging/ozwpan/ozproto.h
> index cb38e02..378b737 100644
> --- a/drivers/staging/ozwpan/ozproto.h
> +++ b/drivers/staging/ozwpan/ozproto.h
> @@ -34,7 +34,7 @@ typedef void (*oz_app_term_fn_t)(void);
>  typedef int (*oz_app_start_fn_t)(struct oz_pd *pd, int resume);
>  typedef void (*oz_app_stop_fn_t)(struct oz_pd *pd, int pause);
>  typedef void (*oz_app_rx_fn_t)(struct oz_pd *pd, struct oz_elt *elt);
> -typedef int (*oz_app_hearbeat_fn_t)(struct oz_pd *pd);
> +typedef int (*oz_app_heartbeat_fn_t)(struct oz_pd *pd);
>  typedef void (*oz_app_farewell_fn_t)(struct oz_pd *pd, u8 ep_num,
>  			u8 *data, u8 len);
>  
> @@ -44,7 +44,7 @@ struct oz_app_if {
>  	oz_app_start_fn_t	start;
>  	oz_app_stop_fn_t	stop;
>  	oz_app_rx_fn_t		rx;
> -	oz_app_hearbeat_fn_t	heartbeat;
> +	oz_app_heartbeat_fn_t	heartbeat;
>  	oz_app_farewell_fn_t	farewell;
>  	int			app_id;
>  };

As these typedefs are only used in this one structure, there's no real
need for them, you can remove them in a later patch if you want.

thanks,

greg k-h
