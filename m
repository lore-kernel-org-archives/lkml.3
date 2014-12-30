Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863AbaL3P1I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 10:27:08 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:56950 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750880AbaL3P1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 10:27:07 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18lkFO9TDtZNnZGPS03d3iusTawX87NkQ0=
X-DKIM: OpenDKIM Filter v2.0.1 titan CE0E963A18D
Date: Tue, 30 Dec 2014 10:26:55 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Andreas Siegling <andreas.siegling@fau.de>
Cc: devel@linuxdriverproject.org, gregkh@linuxfoundation.org,
        eric.rost@mybabylon.net, nks@flawful.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-kernel@i4.cs.fau.de,
        trivial@kernel.org, Zhutao Lu <lvzhutao@gmail.com>
Subject: Re: [PATCH] skein: checkpatch: trailing whitespace
Message-ID: <20141230152655.GM28117@titan.lakedaemon.net>
References: <1419896014-13334-1-git-send-email-andreas.siegling@fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419896014-13334-1-git-send-email-andreas.siegling@fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas,

On Tue, Dec 30, 2014 at 12:33:34AM +0100, Andreas Siegling wrote:
> This small patch will fix the trailing whitespace in
> drivers/staging/skein/skein_generic.c.
> 
> After applying the patch, there will only remain the checkpatch warning:
> 	WARNING: Single statement macros should not use a do {} while (0) loop
> in files which are in the directory drivers/staging/skein/
> 
> Signed-off-by: Andreas Siegling <andreas.siegling@fau.de>
> Signed-off-by: Zhutao Lu <lvzhutao@gmail.com>

Why do you have have two S-o-b's?

> ---
>  drivers/staging/skein/skein_generic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/skein/skein_generic.c b/drivers/staging/skein/skein_generic.c
> index 85bd7d0..4eaae1d 100644
> --- a/drivers/staging/skein/skein_generic.c
> +++ b/drivers/staging/skein/skein_generic.c
> @@ -191,7 +191,7 @@ static int __init skein_generic_init(void)
>  
>  	return 0;
>  
> -		
> +

Hmm, this extra line should just be deleted.

thx,

Jason.

>  unreg512:
>  	crypto_unregister_shash(&alg512);
>  unreg256:
> -- 
> 1.9.1
> 
