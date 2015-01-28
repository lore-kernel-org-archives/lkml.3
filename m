Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933364AbbA1UrZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:47:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42634 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697AbbA1UrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:47:20 -0500
Date: Wed, 28 Jan 2015 11:28:21 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Heba Aamer <heba93aamer@gmail.com>
Cc: devel@driverdev.osuosl.org, noralf@tronnes.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] staging: fbtft: fix Macros with complex values
 should be enclosed in parentheses
Message-ID: <20150128192821.GA3213@kroah.com>
References: <cover.1422443132.git.heba93aamer@gmail.com>
 <8dfee4846d30defff32f46d4322979b33c2fa33b.1422443132.git.heba93aamer@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8dfee4846d30defff32f46d4322979b33c2fa33b.1422443132.git.heba93aamer@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 01:19:25PM +0200, Heba Aamer wrote:
> This patch fixes the following checkpatch.pl error:
> fix Macros with complex values should be enclosed in parentheses
> 
> Signed-off-by: Heba Aamer <heba93aamer@gmail.com>
> ---
>  drivers/staging/fbtft/fb_pcd8544.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/fbtft/fb_pcd8544.c b/drivers/staging/fbtft/fb_pcd8544.c
> index 678ab8e..87ca96e 100644
> --- a/drivers/staging/fbtft/fb_pcd8544.c
> +++ b/drivers/staging/fbtft/fb_pcd8544.c
> @@ -33,7 +33,7 @@
>  #define DRVNAME	       "fb_pcd8544"
>  #define WIDTH          84
>  #define HEIGHT         48
> -#define TXBUFLEN       84*6
> +#define TXBUFLEN       (84*6)
>  #define DEFAULT_GAMMA  "40" /* gamma is used to control contrast in this driver */
>  
>  static unsigned tc = 0;

This is already in my tree, did you redo this series and not say a 'v2'
in them?

confused,

greg k-h
