Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947310Ab3BHXIJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 18:08:09 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:35524 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947233Ab3BHXIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 18:08:06 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH] Documentation / acpi: refer to correct file for acpi_platform_device_ids[] table
Date: Sat, 09 Feb 2013 00:14:27 +0100
Message-ID: <38872303.yk2lQjq1aC@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc6; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1360332421-32140-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1360332421-32140-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 08, 2013 04:07:01 PM Mika Westerberg wrote:
> When the ACPI platform device code was converted to the new ACPI scan
> handler facility, the the acpi_platform_device_ids[] was moved to
> drivers/acpi/acpi_platform.c. Update the documentation accordingly.
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Applied.

When you post any patches touching ACPI, please send CCs of them to
linux-acpi as well.

Thanks,
Rafael


> ---
>  Documentation/acpi/enumeration.txt |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/acpi/enumeration.txt b/Documentation/acpi/enumeration.txt
> index 54469bc..94a6561 100644
> --- a/Documentation/acpi/enumeration.txt
> +++ b/Documentation/acpi/enumeration.txt
> @@ -63,8 +63,8 @@ from ACPI tables.
>  Currently the kernel is not able to automatically determine from which ACPI
>  device it should make the corresponding platform device so we need to add
>  the ACPI device explicitly to acpi_platform_device_ids list defined in
> -drivers/acpi/scan.c. This limitation is only for the platform devices, SPI
> -and I2C devices are created automatically as described below.
> +drivers/acpi/acpi_platform.c. This limitation is only for the platform
> +devices, SPI and I2C devices are created automatically as described below.
>  
>  SPI serial bus support
>  ~~~~~~~~~~~~~~~~~~~~~~
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
