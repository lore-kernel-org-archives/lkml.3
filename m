Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462AbaLZSv1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 13:51:27 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:61020 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbaLZSv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 13:51:26 -0500
Date: Fri, 26 Dec 2014 19:51:09 +0100
From: Konrad Zapalowicz <bergo.torino@gmail.com>
To: Damon Swayn <damon.swayn@null.net>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: line6: pcm: Corrected checkpatch notices in
 pcm.h
Message-ID: <20141226185109.GA27831@t400>
References: <1419593406-18978-1-git-send-email-damon.swayn@null.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419593406-18978-1-git-send-email-damon.swayn@null.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/26, Damon Swayn wrote:
> Fixed a coding style issue

You need to be more specific here, describe what kind of issue this
patch is fixing. Keep in mind that this message, when formulated
properly, will end up as a comment to the Linux kernel source - it must,
therefore, contain valuable information.

thanks,
konrad

ps: the file name does not have to be mentioned in the subject as this
information is already in the diff.
 
> Signed-off-by: Damon Swayn <damon.swayn@null.net>
> ---
>  drivers/staging/line6/pcm.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/line6/pcm.h b/drivers/staging/line6/pcm.h
> index 6aa0d46..5d87934 100644
> --- a/drivers/staging/line6/pcm.h
> +++ b/drivers/staging/line6/pcm.h
> @@ -145,21 +145,21 @@ enum {
>  	    LINE6_BIT_PCM_IMPULSE_PLAYBACK_BUFFER |
>  #endif
>  	    LINE6_BIT_PCM_ALSA_PLAYBACK_BUFFER |
> -	    LINE6_BIT_PCM_MONITOR_PLAYBACK_BUFFER ,
> +	    LINE6_BIT_PCM_MONITOR_PLAYBACK_BUFFER,
>  
>  	LINE6_BITS_PLAYBACK_STREAM =
>  #ifdef CONFIG_LINE6_USB_IMPULSE_RESPONSE
>  	    LINE6_BIT_PCM_IMPULSE_PLAYBACK_STREAM |
>  #endif
>  	    LINE6_BIT_PCM_ALSA_PLAYBACK_STREAM |
> -	    LINE6_BIT_PCM_MONITOR_PLAYBACK_STREAM ,
> +	    LINE6_BIT_PCM_MONITOR_PLAYBACK_STREAM,
>  
>  	LINE6_BITS_CAPTURE_BUFFER =
>  #ifdef CONFIG_LINE6_USB_IMPULSE_RESPONSE
>  	    LINE6_BIT_PCM_IMPULSE_CAPTURE_BUFFER |
>  #endif
>  	    LINE6_BIT_PCM_ALSA_CAPTURE_BUFFER |
> -	    LINE6_BIT_PCM_MONITOR_CAPTURE_BUFFER ,
> +	    LINE6_BIT_PCM_MONITOR_CAPTURE_BUFFER,
>  
>  	LINE6_BITS_CAPTURE_STREAM =
>  #ifdef CONFIG_LINE6_USB_IMPULSE_RESPONSE
> -- 
> 2.1.0
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
