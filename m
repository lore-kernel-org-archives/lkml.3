Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201AbbAUOCw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 09:02:52 -0500
Received: from sym2.noone.org ([178.63.92.236]:57912 "EHLO sym2.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031AbbAUOCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 09:02:31 -0500
Date: Wed, 21 Jan 2015 15:02:26 +0100
From: Tobias Klauser <tklauser@distanz.ch>
To: Ahmad Hassan <ahmad.hassan612@gmail.com>
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        damm+renesas@opensource.se, sachin.kamat@samsung.com, vinc94@gmail.com,
        roberta.dobrescu@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] staging: emxx_udc: remove macro ERR
Message-ID: <20150121140225.GA30253@distanz.ch>
References: <cover.1421880617.git.ahmad.hassan612@gmail.com>
 <00e55cbac49f87ee26b8e4c47aa2111582391ae8.1421880617.git.ahmad.hassan612@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00e55cbac49f87ee26b8e4c47aa2111582391ae8.1421880617.git.ahmad.hassan612@gmail.com>
X-Editor: Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015-01-21 at 23:56:06 +0100, Ahmad Hassan <ahmad.hassan612@gmail.com> wrote:
> Removed ERR macro since it is not used anymore in the emxx_udc.c file.
> 
> Signed-off-by: Ahmad Hassan <ahmad.hassan612@gmail.com>
> ---
>  drivers/staging/emxx_udc/emxx_udc.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/staging/emxx_udc/emxx_udc.h b/drivers/staging/emxx_udc/emxx_udc.h
> index ee1b80d..0758cd5 100644
> --- a/drivers/staging/emxx_udc/emxx_udc.h
> +++ b/drivers/staging/emxx_udc/emxx_udc.h
> @@ -644,6 +644,5 @@ typedef volatile union {
>  } USB_REG_ACCESS;
>  
>  /*-------------------------------------------------------------------------*/

While at it, you could also remove the line above.

> -#define ERR(stuff...)		printk(KERN_ERR "udc: " stuff)
>  
>  #endif  /* _LINUX_EMXX_H */
> -- 
> 2.2.1
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
> 
