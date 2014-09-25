Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784AbaIYABj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 20:01:39 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:38525 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaIYABh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 20:01:37 -0400
Date: Wed, 24 Sep 2014 17:01:31 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Cc: linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Tom Gundersen <teg@jklm.no>,
        Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] input/serio/i8042-x86ia64io.h: Fix Asus X450LCP touchpad
 detection
Message-ID: <20140925000131.GA38891@core.coreip.homeip.net>
References: <1411485873-4245-1-git-send-email-marcos.souza.org@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411485873-4245-1-git-send-email-marcos.souza.org@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 12:24:33PM -0300, Marcos Paulo de Souza wrote:
> From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
> 
> Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: Hans de Goede <hdegoede@redhat.com>
> Cc: Jiri Kosina <jkosina@suse.cz>
> Cc: Tom Gundersen <teg@jklm.no>
> Cc: Peter Hutterer <peter.hutterer@who-t.net>
> Cc: linux-input@vger.kernel.org
> Cc: stable@vger.kernel.org

Applied, thank you.

> ---
>  drivers/input/serio/i8042-x86ia64io.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
> index 136b7b20..ec6cb72 100644
> --- a/drivers/input/serio/i8042-x86ia64io.h
> +++ b/drivers/input/serio/i8042-x86ia64io.h
> @@ -465,6 +465,15 @@ static const struct dmi_system_id __initconst i8042_dmi_nomux_table[] = {
>  			DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion dv4 Notebook PC"),
>  		},
>  	},
> +	{
> +		/* Asus X450LCP */
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "X450LCP"),
> +		},
> +	},
> +
> +
>  	{ }
>  };
>  
> -- 
> 1.9.3
> 

-- 
Dmitry
