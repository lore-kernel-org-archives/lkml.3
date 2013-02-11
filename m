Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760395Ab3BKXPx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 18:15:53 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:37319 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760090Ab3BKXPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 18:15:52 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toshi Kani <toshi.kani@hp.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI: Remove the use of CONFIG_ACPI_CONTAINER_MODULE
Date: Tue, 12 Feb 2013 00:22:17 +0100
Message-ID: <2134502.Uo3joRHVj1@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc7; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1360622000-22140-1-git-send-email-toshi.kani@hp.com>
References: <1360622000-22140-1-git-send-email-toshi.kani@hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 11, 2013 03:33:20 PM Toshi Kani wrote:
> config ACPI_CONTAINER has been changed to bool (y/n), and its
> module option is no longer valid.  So, remove the use of
> CONFIG_ACPI_CONTAINER_MODULE.
> 
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>

I'm going to take it.

Thanks,
Rafael


> ---
>  include/linux/acpi.h |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/include/linux/acpi.h b/include/linux/acpi.h
> index c6ccd9f..bcbdd74 100644
> --- a/include/linux/acpi.h
> +++ b/include/linux/acpi.h
> @@ -363,8 +363,7 @@ extern acpi_status acpi_pci_osc_control_set(acpi_handle handle,
>  #if defined(CONFIG_ACPI_HOTPLUG_CPU) &&			\
>  	(defined(CONFIG_ACPI_HOTPLUG_MEMORY) ||		\
>  	 defined(CONFIG_ACPI_HOTPLUG_MEMORY_MODULE)) &&	\
> -	(defined(CONFIG_ACPI_CONTAINER) ||		\
> -	 defined(CONFIG_ACPI_CONTAINER_MODULE))
> +	defined(CONFIG_ACPI_CONTAINER)
>  #define ACPI_HOTPLUG_OST
>  #endif
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
