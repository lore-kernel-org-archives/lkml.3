Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751359AbaKVIbO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 03:31:14 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:53291 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbaKVIbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 03:31:13 -0500
Date: Sat, 22 Nov 2014 14:01:06 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Anjana Sasindran <anjanasasindran123@gmail.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH] drivers:staging:skein:skein_generic.c: Fixed a
 whitespace error
Message-ID: <20141122083106.GB6591@sudip-PC>
References: <1416642119-5827-1-git-send-email-anjanasasindran123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416642119-5827-1-git-send-email-anjanasasindran123@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 22, 2014 at 01:11:59PM +0530, Anjana Sasindran wrote:
>      This patch fixes the checkpatch.pl error:
> 
it still does not apply to next-20141121
>      ERROR: trailing whitespace

and i am not seeing any trailing whitespace at line 191 of this file.
if you base your patch on next-20141121 your patch should have been:

diff --git a/drivers/staging/skein/skein_generic.c b/drivers/staging/skein/skein_generic.c
index 60d16b6..8660509 100644
--- a/drivers/staging/skein/skein_generic.c
+++ b/drivers/staging/skein/skein_generic.c
@@ -191,7 +191,6 @@ static int __init skein_generic_init(void)

	 return 0;

-               
 unreg512:
	 crypto_unregister_shash(&alg512);
 unreg256:


thanks
sudip

> 
> Signed-off-by: Anjana Sasindran <anjanasasindran123@gmail.com>
> ---
>  drivers/staging/skein/skein_generic.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/staging/skein/skein_generic.c b/drivers/staging/skein/skein_generic.c
> index 7096d5a..268e4de 100644
> --- a/drivers/staging/skein/skein_generic.c
> +++ b/drivers/staging/skein/skein_generic.c
> @@ -188,7 +188,6 @@ static int __init skein_generic_init(void)
>  		goto unreg256;
>  	if (crypto_register_shash(&alg1024))
>  		goto unreg512;
> -
>  	return 0;
>  unreg512:
>  	crypto_unregister_shash(&alg512);
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
