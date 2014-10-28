Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbaJ1XIq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 19:08:46 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:37777 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbaJ1XIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 19:08:45 -0400
Date: Tue, 28 Oct 2014 16:08:41 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Input: i8042 - add mux quirk for HP EliteBook
Message-ID: <20141028230841.GB19675@dtor-ws>
References: <1414535232-4780-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414535232-4780-1-git-send-email-luis.henriques@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 10:27:12PM +0000, Luis Henriques wrote:
> This laptop requires active multiplexing to be enabled in order to be able
> to separate the PS/2 mouse and the touchpad.
> 
> Signed-off-by: Luis Henriques <luis.henriques@canonical.com>

Applied, thank you.

> ---
>  drivers/input/serio/i8042-x86ia64io.h | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
> index a0bcbb64d06d..2bd486e83b43 100644
> --- a/drivers/input/serio/i8042-x86ia64io.h
> +++ b/drivers/input/serio/i8042-x86ia64io.h
> @@ -220,6 +220,13 @@ static const struct dmi_system_id __initconst i8042_dmi_mux_table[] = {
>  			DMI_MATCH(DMI_PRODUCT_NAME, "CF-18"),
>  		},
>  	},
> +	{
> +		/* HP EliteBook */
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "HP EliteBook"),
> +		},
> +	},
>  	{ }
>  };
>  
> -- 
> 2.1.0

-- 
Dmitry
