Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964915AbaGPNvb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 09:51:31 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:48481 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933687AbaGPNv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 09:51:27 -0400
Date: Wed, 16 Jul 2014 15:46:34 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, Andrew Lunn <andrew@lunn.ch>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] power/reset: Fix GPL v2 license string typo
Message-ID: <20140716134634.GD9858@lunn.ch>
References: <20140715232450.24076.25543.stgit@bhelgaas-glaptop.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140715232450.24076.25543.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 05:24:50PM -0600, Bjorn Helgaas wrote:
> Per license_is_gpl_compatible(), the MODULE_LICENSE() string for GPL v2 is
> "GPL v2", not "GPLv2".  Use "GPL v2" so this module doesn't taint the
> kernel.
> 
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

Acked-by: Andrew Lunn <andrew@lunn.ch>

	  Andrew

> ---
>  drivers/power/reset/restart-poweroff.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/power/reset/restart-poweroff.c b/drivers/power/reset/restart-poweroff.c
> index 5758033e0c16..3e51f8d29bfe 100644
> --- a/drivers/power/reset/restart-poweroff.c
> +++ b/drivers/power/reset/restart-poweroff.c
> @@ -62,5 +62,5 @@ module_platform_driver(restart_poweroff_driver);
>  
>  MODULE_AUTHOR("Andrew Lunn <andrew@lunn.ch");
>  MODULE_DESCRIPTION("restart poweroff driver");
> -MODULE_LICENSE("GPLv2");
> +MODULE_LICENSE("GPL v2");
>  MODULE_ALIAS("platform:poweroff-restart");
> 
