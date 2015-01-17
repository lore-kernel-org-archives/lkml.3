Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417AbbAQXgr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 18:36:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55960 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356AbbAQXgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 18:36:45 -0500
Date: Sat, 17 Jan 2015 15:03:55 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Simone Weiss <simone.weiss@fau.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@i4.cs.fau.de,
        lidza.louina@gmail.com, driverdev-devel@linuxdriverproject.org,
        helene.gsaenger@studium.fau.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] dgnc/dpacompat.h: checkpatch: fixed long lines bei
 moving comments
Message-ID: <20150117230355.GB9418@kroah.com>
References: <1419211054-3052-1-git-send-email-simone.weiss@fau.de>
 <1419211054-3052-4-git-send-email-simone.weiss@fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419211054-3052-4-git-send-email-simone.weiss@fau.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2014 at 02:17:31AM +0100, Simone Weiss wrote:
> 
> Signed-off-by: Simone Weiss <simone.weiss@fau.de>
> Signed-off-by: Helene Gsaenger <helene.gsaenger@studium.fau.de>
> ---
>  drivers/staging/dgnc/dpacompat.h | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/dgnc/dpacompat.h b/drivers/staging/dgnc/dpacompat.h
> index b2d2dc0..feb4f60 100644
> --- a/drivers/staging/dgnc/dpacompat.h
> +++ b/drivers/staging/dgnc/dpacompat.h
> @@ -111,5 +111,7 @@ struct ni_info {
>  #define DIGI_GET_NI_INFO ('d'<<8) | 250		/* nonintelligent state snfo */
>  
>  /* Other special ioctls */
> -#define DIGI_TIMERIRQ ('d'<<8) | 251		/* Enable/disable RS_TIMER use */
> -#define DIGI_LOOPBACK ('d'<<8) | 252		/* Enable/disable UART internal loopback */
> +#define DIGI_TIMERIRQ ('d'<<8) | 251		/* Enable/disable
> +						 * RS_TIMER use */
> +#define DIGI_LOOPBACK ('d'<<8) | 252		/* Enable/disable UART
> +						 * internal loopback */
> -- 
> 1.9.1

That really doesn't look better, does it?

Please resend a fixed up series, I'm too confused by all of the
different patches you have sent to figure out what to apply.

thanks,

greg k-h
