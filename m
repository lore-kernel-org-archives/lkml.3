Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982AbaGaAF5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 20:05:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43041 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362AbaGaAF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 20:05:56 -0400
Date: Wed, 30 Jul 2014 17:05:28 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: fernando.apesteguia@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: rtl8192u: Staticfy debug method.
Message-ID: <20140731000528.GA18924@kroah.com>
References: <1406756021-3578-1-git-send-email-fernando.apesteguia@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406756021-3578-1-git-send-email-fernando.apesteguia@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 11:33:41PM +0200, fernando.apesteguia@gmail.com wrote:
> From: Fernando Apesteguia <fernando.apesteguia@gmail.com>
> 
> Add static to debug method.
> 
> Signed-off-by: Fernando Apesteguia <fernando.apesteguia@gmail.com>
> ---
>  drivers/staging/rtl8192u/r8192U_core.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
> index 7640386..c732a67 100644
> --- a/drivers/staging/rtl8192u/r8192U_core.c
> +++ b/drivers/staging/rtl8192u/r8192U_core.c
> @@ -667,7 +667,7 @@ static void tx_timeout(struct net_device *dev)
>  
>  
>  /* this is only for debug */
> -void dump_eprom(struct net_device *dev)
> +static void dump_eprom(struct net_device *dev)
>  {
>  	int i;
>  	for (i = 0; i < 63; i++)

Someone sent this patch just before you :(

