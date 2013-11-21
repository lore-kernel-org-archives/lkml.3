Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab3KUVUQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 16:20:16 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:52825 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab3KUVUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 16:20:11 -0500
Date: Thu, 21 Nov 2013 21:20:06 +0000
From: Mark Einon <mark.einon@gmail.com>
To: ZHAO Gang <gamerh2o@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH v3 5/5] staging: et131x: update TODO list
Message-ID: <20131121212005.GF10691@einon.net>
References: <cover.1384933520.git.gamerh2o@gmail.com>
 <0ae40b21f7594be59bd90fd3e4c9002ba2f319c0.1384933520.git.gamerh2o@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0ae40b21f7594be59bd90fd3e4c9002ba2f319c0.1384933520.git.gamerh2o@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 03:58:37PM +0800, ZHAO Gang wrote:
> remove items that have been done
> 
> Signed-off-by: ZHAO Gang <gamerh2o@gmail.com>

If the two small issues in patch 1/5 are fixed:

Acked-by: Mark Einon <mark.einon@gmail.com>

> ---
>  drivers/staging/et131x/README | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/drivers/staging/et131x/README b/drivers/staging/et131x/README
> index 8da96a6..00a34ea 100644
> --- a/drivers/staging/et131x/README
> +++ b/drivers/staging/et131x/README
> @@ -11,12 +11,7 @@ TODO:
>  	- Look at reducing the number of spinlocks
>  	- Simplify code in nic_rx_pkts(), when determining multicast_pkts_rcvd
>  	- Implement NAPI support
> -	- In et131x_tx(), don't return NETDEV_TX_BUSY, just drop the packet with kfree_skb().
>  	- Reduce the number of split lines by careful consideration of variable names etc.
> -	- Do this in et131x.c:
> -                struct fbr_lookup *fbr;
> -                fbr = rx_local->fbr[id];
> -	  Then replace all the instances of "rx_local->fbr[id]" with fbr.
>  
>  Please send patches to:
>  	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> -- 
> 1.8.3.1
> 
