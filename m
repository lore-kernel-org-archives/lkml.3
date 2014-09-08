Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918AbaIHGi5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 02:38:57 -0400
Received: from sym2.noone.org ([178.63.92.236]:58104 "EHLO sym2.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424AbaIHGi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 02:38:56 -0400
Date: Mon, 8 Sep 2014 08:38:52 +0200
From: Tobias Klauser <tklauser@distanz.ch>
To: anicoara <anicoara@uwaterloo.ca>
Cc: shigekatsu.tateno@atmel.com, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] staging: ozwpan: use kmalloc_array over kmalloc with
 multiply
Message-ID: <20140908063852.GA3578@distanz.ch>
References: <20140907182825.GD2312@uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140907182825.GD2312@uwaterloo.ca>
X-Editor: Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Your From: line does not contain a real name and does not match your
Signed-off-by line, please check your e-mail client settings.

On 2014-09-07 at 20:28:25 +0200, anicoara <anicoara@uwaterloo.ca> wrote:

No changelog text? Please add a short notice, describing why this change
is done.

> Signed-off-by: Adrian Nicoara <anicoara@uwaterloo.ca>
> ---
> Patch submitted as part of the Eudyptula challenge.
> 
>  drivers/staging/ozwpan/ozhcd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
> index ba2168f..4cfe56e 100644
> --- a/drivers/staging/ozwpan/ozhcd.c
> +++ b/drivers/staging/ozwpan/ozhcd.c
> @@ -1315,7 +1315,7 @@ static int oz_build_endpoints_for_config(struct usb_hcd *hcd,
>  	if (num_iface) {
>  		struct oz_interface *iface;
> 
> -		iface = kmalloc(num_iface*sizeof(struct oz_interface),
> +		iface = kmalloc_array(num_iface, sizeof(struct oz_interface),
>  				mem_flags | __GFP_ZERO);

The line above should be adjusted to match the opening parenthesis.

>  		if (!iface)
>  			return -ENOMEM;
> --
> 2.0.1
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
> 
