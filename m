Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518AbaHKStD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 14:49:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58103 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452AbaHKStA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 14:49:00 -0400
Date: Tue, 12 Aug 2014 02:48:22 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Avinash kumar <avi.kp.137@gmail.com>
Cc: forest@alittletooquiet.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: staging: vt6655: wpactl.h: corrected comment
 format
Message-ID: <20140811184822.GA947@kroah.com>
References: <1407779792-7926-1-git-send-email-avi.kp.137@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407779792-7926-1-git-send-email-avi.kp.137@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 11:26:32PM +0530, Avinash kumar wrote:
> corrected C99 style comment format related error
> 
> Signed-off-by: Avinash Kumar <avi.kp.137@gmail.com>
> ---
>  drivers/staging/vt6655/wpactl.h |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/vt6655/wpactl.h b/drivers/staging/vt6655/wpactl.h
> index f7638ba..2ff42c5 100644
> --- a/drivers/staging/vt6655/wpactl.h
> +++ b/drivers/staging/vt6655/wpactl.h
> @@ -36,7 +36,7 @@
>  
>  /*---------------------  Export Definitions -------------------------*/
>  
> -//WPA related
> +/*WPA related*/

Shouldn't you use 2 extra ' ' characters here?

>  enum wpa_alg { WPA_ALG_NONE, WPA_ALG_WEP, WPA_ALG_TKIP, WPA_ALG_CCMP };
>  enum wpa_cipher { CIPHER_NONE, CIPHER_WEP40, CIPHER_TKIP, CIPHER_CCMP,
> @@ -61,4 +61,4 @@ int wpa_set_wpadev(PSDevice pDevice, int val);
>  int wpa_ioctl(PSDevice pDevice, struct iw_point *p);
>  int wpa_set_keys(PSDevice pDevice, void *ctx, bool fcpfkernel);
>  
> -#endif // __WPACL_H__
> +#endif /* __WPACL_H__*/

And one extra ' ' here, right before the '*/' please.

thanks,

greg k-h
