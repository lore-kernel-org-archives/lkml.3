Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759770Ab3CZN1B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 09:27:01 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:43079 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758206Ab3CZN07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 09:26:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Paul Bolle <pebolle@tiscali.nl>, Lv Zheng <lv.zheng@intel.com>
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI: remove "config ACPI_DEBUG_FUNC_TRACE"
Date: Tue, 26 Mar 2013 14:34:25 +0100
Message-ID: <3588021.V98D5VToQr@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1363689661.1390.9.camel@x61.thuisdomein>
References: <1363689661.1390.9.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 19, 2013 11:41:01 AM Paul Bolle wrote:
> Kconfig symbol ACPI_DEBUG_FUNC_TRACE was only used (through its
> corresponding macro) in drivers/acpi/acpica/acmacros.h. That macro was
> removed from that header in v3.8, with commit
> 86ff0e508f88eda6e479a897476026055831d2d8 ("ACPICA: Fix unmerged
> acmacros.h divergences."). That commit did not explain why that macro
> was removed. But it seems that ACPI_DEBUG_FUNC_TRACE can now be removed
> too, as it is unused.

Lv, can you please comment here?

Rafael


> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Eyeball tested.
> 
>  drivers/acpi/Kconfig | 8 --------
>  1 file changed, 8 deletions(-)
> 
> diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
> index 92ed969..006b714 100644
> --- a/drivers/acpi/Kconfig
> +++ b/drivers/acpi/Kconfig
> @@ -298,14 +298,6 @@ config ACPI_DEBUG
>  	  Documentation/kernel-parameters.txt to control the type and
>  	  amount of debug output.
>  
> -config ACPI_DEBUG_FUNC_TRACE
> -	bool "Additionally enable ACPI function tracing"
> -	default n
> -	depends on ACPI_DEBUG
> -	help
> -	  ACPI Debug Statements slow down ACPI processing. Function trace
> -	  is about half of the penalty and is rarely useful.
> -
>  config ACPI_PCI_SLOT
>  	bool "PCI slot detection driver"
>  	depends on SYSFS
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
