Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964AbaCPQfy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 12:35:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38541 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbaCPQfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 12:35:53 -0400
Date: Sun, 16 Mar 2014 16:37:00 +0000
From: Greg KH <gregkh@linuxfoundation.org>
To: Davide Berardi <berardi.dav@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fixing some coding style issues on line6 driver.c
Message-ID: <20140316163700.GA1781@kroah.com>
References: <20140316132016.388a3f69@White-Rabbit>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140316132016.388a3f69@White-Rabbit>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 16, 2014 at 01:20:16PM +0100, Davide Berardi wrote:
> Fixed some over-80 characters lines.
> (this is for eudyptula challenge task 10).
> 
> From: Davide Berardi <berardi.dav@gmail.com>
> 
> Signed-off-by: Davide Berardi <berardi.dav@gmail.com>
> ---
> diff --git a/drivers/staging/line6/driver.c b/drivers/staging/line6/driver.c
> index e7a9d8d..b3652e6 100644
> --- a/drivers/staging/line6/driver.c
> +++ b/drivers/staging/line6/driver.c
> @@ -59,26 +59,46 @@ MODULE_DEVICE_TABLE(usb, line6_id_table);
>  
>  /* *INDENT-OFF* */
>  static struct line6_properties line6_properties_table[] = {
> -	{ LINE6_BIT_BASSPODXT,     "BassPODxt",     "BassPODxt",        LINE6_BIT_CONTROL_PCM_HWMON },
> -	{ LINE6_BIT_BASSPODXTLIVE, "BassPODxtLive", "BassPODxt Live",   LINE6_BIT_CONTROL_PCM_HWMON },
> -	{ LINE6_BIT_BASSPODXTPRO,  "BassPODxtPro",  "BassPODxt Pro",    LINE6_BIT_CONTROL_PCM_HWMON },
> -	{ LINE6_BIT_GUITARPORT,    "GuitarPort",    "GuitarPort",       LINE6_BIT_PCM               },
> -	{ LINE6_BIT_POCKETPOD,     "PocketPOD",     "Pocket POD",       LINE6_BIT_CONTROL           },
> -	{ LINE6_BIT_PODHD300,      "PODHD300",      "POD HD300",        LINE6_BIT_CONTROL_PCM_HWMON },
> -	{ LINE6_BIT_PODHD400,      "PODHD400",      "POD HD400",        LINE6_BIT_CONTROL_PCM_HWMON },
> -	{ LINE6_BIT_PODHD500,      "PODHD500",      "POD HD500",        LINE6_BIT_CONTROL_PCM_HWMON },
> -	{ LINE6_BIT_PODSTUDIO_GX,  "PODStudioGX",   "POD Studio GX",    LINE6_BIT_PCM               },
> -	{ LINE6_BIT_PODSTUDIO_UX1, "PODStudioUX1",  "POD Studio UX1",   LINE6_BIT_PCM               },
> -	{ LINE6_BIT_PODSTUDIO_UX2, "PODStudioUX2",  "POD Studio UX2",   LINE6_BIT_PCM               },
> -	{ LINE6_BIT_PODX3,         "PODX3",         "POD X3",           LINE6_BIT_PCM               },
> -	{ LINE6_BIT_PODX3LIVE,     "PODX3Live",     "POD X3 Live",      LINE6_BIT_PCM               },
> -	{ LINE6_BIT_PODXT,         "PODxt",         "PODxt",            LINE6_BIT_CONTROL_PCM_HWMON },
> -	{ LINE6_BIT_PODXTLIVE,     "PODxtLive",     "PODxt Live",       LINE6_BIT_CONTROL_PCM_HWMON },
> -	{ LINE6_BIT_PODXTPRO,      "PODxtPro",      "PODxt Pro",        LINE6_BIT_CONTROL_PCM_HWMON },
> -	{ LINE6_BIT_TONEPORT_GX,   "TonePortGX",    "TonePort GX",      LINE6_BIT_PCM               },
> -	{ LINE6_BIT_TONEPORT_UX1,  "TonePortUX1",   "TonePort UX1",     LINE6_BIT_PCM               },
> -	{ LINE6_BIT_TONEPORT_UX2,  "TonePortUX2",   "TonePort UX2",     LINE6_BIT_PCM               },
> -	{ LINE6_BIT_VARIAX,        "Variax",        "Variax Workbench", LINE6_BIT_CONTROL           },
> +	{ LINE6_BIT_BASSPODXT,     "BassPODxt",
> +		"BassPODxt",        LINE6_BIT_CONTROL_PCM_HWMON },
> +	{ LINE6_BIT_BASSPODXTLIVE, "BassPODxtLive",
> +		"BassPODxt Live",   LINE6_BIT_CONTROL_PCM_HWMON },

That looks worse, sorry, I can't take this.

greg k-h
