Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388AbaGKWKV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 18:10:21 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:51300 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751029AbaGKWKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 18:10:20 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH] Documentation: Remove reference to acpi_platform_device_ids from acpi/enumeration
Date: Sat, 12 Jul 2014 00:28:28 +0200
Message-ID: <18045079.o48H7sblXe@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <96c9e6efdd200bb194bc99845a18015f8d19881d.1405076619.git.dvhart@linux.intel.com>
References: <96c9e6efdd200bb194bc99845a18015f8d19881d.1405076619.git.dvhart@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 11, 2014 11:03:39 AM Darren Hart wrote:
> As of:
> 
>     4845934 ACPI / scan: use platform bus type by default for _HID enumeration
> 
> ACPI uses the platform bus by default, changing the opt-in to an opt-out
> policy, eliminating the acpi_platform_device_ids table and replacing it
> with forbidden_id_list[].
> 
> Remove the qualifying paragraph from the acpi/enumeration documentation
> as it no longer applies.

Sure thing.  I was about to do that myself, but you beat me to it. :-)

Applied, thanks!

> Reported-by: Max Eliaser <max@meliaserlow.dyndns.tv>
> Signed-off-by: Darren Hart <dvhart@linux.intel.com>
> Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  Documentation/acpi/enumeration.txt | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/Documentation/acpi/enumeration.txt b/Documentation/acpi/enumeration.txt
> index fd786ea..e182be5 100644
> --- a/Documentation/acpi/enumeration.txt
> +++ b/Documentation/acpi/enumeration.txt
> @@ -60,12 +60,6 @@ If the driver needs to perform more complex initialization like getting and
>  configuring GPIOs it can get its ACPI handle and extract this information
>  from ACPI tables.
>  
> -Currently the kernel is not able to automatically determine from which ACPI
> -device it should make the corresponding platform device so we need to add
> -the ACPI device explicitly to acpi_platform_device_ids list defined in
> -drivers/acpi/acpi_platform.c. This limitation is only for the platform
> -devices, SPI and I2C devices are created automatically as described below.
> -
>  DMA support
>  ~~~~~~~~~~~
>  DMA controllers enumerated via ACPI should be registered in the system to
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
