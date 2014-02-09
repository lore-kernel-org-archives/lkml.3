Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100AbaBIUdz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 15:33:55 -0500
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:51426 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751786AbaBIUdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 15:33:54 -0500
Message-ID: <1391977683.25855.27.camel@x220>
Subject: Re: [PATCH 06/28] Remove PICOXCELL_PC3X3
From: Paul Bolle <pebolle@tiscali.nl>
To: Richard Weinberger <richard@nod.at>
Cc: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        open list <linux-kernel@vger.kernel.org>
Date: Sun, 09 Feb 2014 21:28:03 +0100
In-Reply-To: <1391971686-9517-7-git-send-email-richard@nod.at>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
	 <1391971686-9517-7-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Feb 2014 20:28:04.0663 (UTC) FILETIME=[6F8A4C70:01CF25D5]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-02-09 at 19:47 +0100, Richard Weinberger wrote:
> The symbol is an orphan, get rid of it.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  drivers/char/hw_random/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
> index 2f2b084..eab6056 100644
> --- a/drivers/char/hw_random/Kconfig
> +++ b/drivers/char/hw_random/Kconfig
> @@ -253,7 +253,7 @@ config HW_RANDOM_NOMADIK
>  
>  config HW_RANDOM_PICOXCELL
>  	tristate "Picochip picoXcell true random number generator support"
> -	depends on HW_RANDOM && ARCH_PICOXCELL && PICOXCELL_PC3X3
> +	depends on HW_RANDOM && ARCH_PICOXCELL
>  	---help---
>  	  This driver provides kernel-side support for the Random Number
>  	  Generator hardware found on Picochip PC3x3 and later devices.

So that random number generator is now unbuildable. For the record: this
was already an issue in May 2013:
http://lists.infradead.org/pipermail/linux-arm-kernel/2013-May/168283.html . Perhaps the picoxcell-rng could be removed (an merged again if PICOXCELL_PC3X3 gets added).


Paul Bolle

