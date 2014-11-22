Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750820AbaKVGXW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 01:23:22 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:58052 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbaKVGXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 01:23:21 -0500
Date: Sat, 22 Nov 2014 11:53:11 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Anjana Sasindran <anjanasasindran123@gmail.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH]  Staging:skein: Fix trailing  whitespace error
Message-ID: <20141122062311.GA4490@sudip-PC>
References: <1416636269-3030-1-git-send-email-anjanasasindran123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416636269-3030-1-git-send-email-anjanasasindran123@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 22, 2014 at 11:34:29AM +0530, Anjana Sasindran wrote:
>   This patch fixes the checkpatch.pl error:
this patch is not applying to next-20141121.
> 
>   ERROR: trailing whitespace
but your patch is adding a blank line in the code ?

thanks
sudip

> 
> Signed-off-by: Anjana Sasindran <anjanasasindran123@gmail.com>
> ---
>  drivers/staging/skein/skein_generic.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/staging/skein/skein_generic.c b/drivers/staging/skein/skein_generic.c
> index 7096d5a..8660509 100644
> --- a/drivers/staging/skein/skein_generic.c
> +++ b/drivers/staging/skein/skein_generic.c
> @@ -190,6 +190,7 @@ static int __init skein_generic_init(void)
>  		goto unreg512;
>  
>  	return 0;
> +
>  unreg512:
>  	crypto_unregister_shash(&alg512);
>  unreg256:
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
