Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302AbaLWP5L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 10:57:11 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:33042 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaLWP5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 10:57:10 -0500
Date: Tue, 23 Dec 2014 07:57:03 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Kroderia <kroderia@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] staging: skein: Delete a useless white space line
Message-ID: <20141223155703.GA13718@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Kroderia <kroderia@gmail.com>, gregkh@linuxfoundation.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1419349073-6308-1-git-send-email-kroderia@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419349073-6308-1-git-send-email-kroderia@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23, 2014 at 03:37:53PM +0000, Kroderia wrote:
> Signed-off-by: Ben Chan <kroderia@gmail.com>

Your Signed-off-by doesn't match your From: line.

> ---
>  drivers/staging/skein/skein_generic.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/staging/skein/skein_generic.c b/drivers/staging/skein/skein_generic.c
> index 85bd7d0..899078f 100644
> --- a/drivers/staging/skein/skein_generic.c
> +++ b/drivers/staging/skein/skein_generic.c
> @@ -191,7 +191,6 @@ static int __init skein_generic_init(void)
>  
>  	return 0;
>  
> -		
>  unreg512:
>  	crypto_unregister_shash(&alg512);
>  unreg256:
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
- Jeremiah Mahler
