Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968AbaIHGkN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 02:40:13 -0400
Received: from sym2.noone.org ([178.63.92.236]:58255 "EHLO sym2.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183AbaIHGkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 02:40:11 -0400
Date: Mon, 8 Sep 2014 08:40:08 +0200
From: Tobias Klauser <tklauser@distanz.ch>
To: anicoara <anicoara@uwaterloo.ca>
Cc: shigekatsu.tateno@atmel.com, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] staging: ozwpan: fix redundant return in void
 function
Message-ID: <20140908064008.GB3578@distanz.ch>
References: <20140907182535.GC2312@uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140907182535.GC2312@uwaterloo.ca>
X-Editor: Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Your From: line does not contain a real name and does not match your
Signed-off-by line, please check your e-mail client settings.

On 2014-09-07 at 20:25:35 +0200, anicoara <anicoara@uwaterloo.ca> wrote:
> Signed-off-by: Adrian Nicoara <anicoara@uwaterloo.ca>

No changelog text? Please add a short notice, describing why this change
is done.

> ---
> Patch submitted as part of the Eudyptula challenge.
> 
>  drivers/staging/ozwpan/ozproto.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/staging/ozwpan/ozproto.c b/drivers/staging/ozwpan/ozproto.c
> index cae0e6f..3d3a3a8 100644
> --- a/drivers/staging/ozwpan/ozproto.c
> +++ b/drivers/staging/ozwpan/ozproto.c
> @@ -112,7 +112,6 @@ static void oz_send_conn_rsp(struct oz_pd *pd, u8 status)
>  	}
>  	oz_dbg(ON, "TX: OZ_ELT_CONNECT_RSP %d", status);
>  	dev_queue_xmit(skb);
> -	return;
>  }
> 
>  /*
> --
> 2.0.1
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
> 
