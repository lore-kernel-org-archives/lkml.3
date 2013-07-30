Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757811Ab3G3S4y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 14:56:54 -0400
Received: from lunge.queued.net ([173.255.254.236]:37719 "EHLO
	lunge.queued.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757364Ab3G3S4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 14:56:52 -0400
X-Greylist: delayed 484 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Jul 2013 14:56:52 EDT
Date: Tue, 30 Jul 2013 11:48:45 -0700
From: Andres Salomon <dilinger@queued.net>
To: Jens Frederich <jfrederich@gmail.com>
Cc: gregkh@linuxfoundation.org, jon.nettleton@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: olpc_dcon: provide detailed FB_OLPC_DCON help
 section
Message-ID: <20130730114845.15ce0307@dev.queued.net>
In-Reply-To: <1375207894-6106-1-git-send-email-jfrederich@gmail.com>
References: <1375207894-6106-1-git-send-email-jfrederich@gmail.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Andres Salomon <dilinger@queued.net>

On Tue, 30 Jul 2013
20:11:34 +0200 Jens Frederich <jfrederich@gmail.com> wrote:

> The FB_OLPC_DCON help section is to short according to checkpatch.pl.
> We want more information about the controller type, its task, its
> video pipeline position and so on.
> 
> There are no style issues, remove checkpatch.pl TODO entry.
> 
> Signed-off-by: Jens Frederich <jfrederich@gmail.com>
> 
> diff --git a/drivers/staging/olpc_dcon/Kconfig
> b/drivers/staging/olpc_dcon/Kconfig index fe40e0b..2ff015d 100644
> --- a/drivers/staging/olpc_dcon/Kconfig
> +++ b/drivers/staging/olpc_dcon/Kconfig
> @@ -4,9 +4,14 @@ config FB_OLPC_DCON
>  	select I2C
>  	select BACKLIGHT_CLASS_DEVICE
>  	---help---
> -	  Add support for the OLPC XO DCON controller.  This
> controller is
> -	  only available on OLPC platforms.   Unless you have one of
> these
> -	  platforms, you will want to say 'N'.
> +	  In order to support very low power operation, the XO
> laptop uses a
> +	  secondary Display CONtroller, or DCON.  This secondary
> controller
> +	  is present in the video pipeline between the primary
> display
> +	  controller (integrate into the processor or chipset) and
> the LCD
> +	  panel.  It allows the main processor/display controller to
> be
> +	  completely powered off while still retaining an image on
> the display.
> +	  This controller is only available on OLPC platforms.
> Unless you have
> +	  one of these platforms, you will want to say 'N'.
>  
>  config FB_OLPC_DCON_1
>  	bool "OLPC XO-1 DCON support"
> diff --git a/drivers/staging/olpc_dcon/TODO
> b/drivers/staging/olpc_dcon/TODO index 35f9cda..f378e84 100644
> --- a/drivers/staging/olpc_dcon/TODO
> +++ b/drivers/staging/olpc_dcon/TODO
> @@ -1,5 +1,4 @@
>  TODO:
> -	- checkpatch.pl cleanups
>  	- see if vx855 gpio API can be made similar enough to cs5535
> so we can share more code
>  	- allow simultaneous XO-1 and XO-1.5 support
