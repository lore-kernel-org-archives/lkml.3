Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbaL2Wg7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 17:36:59 -0500
Received: from mail-oi0-f51.google.com ([209.85.218.51]:48134 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbaL2Wg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 17:36:58 -0500
Date: Mon, 29 Dec 2014 14:36:55 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Jonas Lundqvist <jonas@gannon.se>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Staging: line6: remove spaces before commas.
Message-ID: <20141229223655.GA2210@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Jonas Lundqvist <jonas@gannon.se>, gregkh@linuxfoundation.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1419887520-8332-1-git-send-email-jonas@gannon.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419887520-8332-1-git-send-email-jonas@gannon.se>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonas,

On Mon, Dec 29, 2014 at 10:12:00PM +0100, Jonas Lundqvist wrote:
> Fix three space prohibited errors in pcm.h found by checkpatch.pl.
> 
That is a nice log message.  Clean and simple. :-)

> Signed-off-by: Jonas Lundqvist <jonas@gannon.se>
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
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Looks good to me.

Reviewed-by: Jeremiah Mahler <jmmahler@gmail.com>

-- 
- Jeremiah Mahler
