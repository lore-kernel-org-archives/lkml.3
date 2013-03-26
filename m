Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934183Ab3CZNTw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 09:19:52 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:43023 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934116Ab3CZNTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 09:19:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] acpi: remove reference to ACPI_HOTPLUG_IO
Date: Tue, 26 Mar 2013 14:27:17 +0100
Message-ID: <1644989.VH5Ga70vPA@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1362999228.3137.55.camel@x61.thuisdomein>
References: <1362999228.3137.55.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, March 11, 2013 11:53:48 AM Paul Bolle wrote:
> The Kconfig entry for ACPI Container and Module Devices got
> added in v2.6.11. Its default value has always been set to
>     (ACPI_HOTPLUG_MEMORY || ACPI_HOTPLUG_CPU || ACPI_HOTPLUG_IO)
> 
> But the Kconfig symbol ACPI_HOTPLUG_IO has never existed. So it's
> pointless to use it to set this default value.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Applied to linux-pm.git/linux-next.

Thanks,
Rafael


> ---
> Untested, actually.
> 
>  drivers/acpi/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
> index 92ed969..b46f5e3 100644
> --- a/drivers/acpi/Kconfig
> +++ b/drivers/acpi/Kconfig
> @@ -334,7 +334,7 @@ config X86_PM_TIMER
>  
>  config ACPI_CONTAINER
>  	bool "Container and Module Devices"
> -	default (ACPI_HOTPLUG_MEMORY || ACPI_HOTPLUG_CPU || ACPI_HOTPLUG_IO)
> +	default (ACPI_HOTPLUG_MEMORY || ACPI_HOTPLUG_CPU)
>  	help
>  	  This driver supports ACPI Container and Module devices (IDs
>  	  ACPI0004, PNP0A05, and PNP0A06).
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
