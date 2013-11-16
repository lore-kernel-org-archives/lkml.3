Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863Ab3KPBS3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 20:18:29 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:65129 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753773Ab3KPBSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 20:18:21 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI / LPSS: add ACPI IDs for newer Intel PCHs
Date: Sat, 16 Nov 2013 02:30:54 +0100
Message-ID: <1515846.jF908LkdoS@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1384249699-9493-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1384249699-9493-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 12, 2013 11:48:19 AM Mika Westerberg wrote:
> Some recent Intel PCHs with LPSS have different ACPI IDs for the LPSS
> devices, so add these to the list as well.
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Queued up for the next ACPI pull request, thanks!

> ---
>  drivers/acpi/acpi_lpss.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
> index fb78bb9ad8f6..242885715331 100644
> --- a/drivers/acpi/acpi_lpss.c
> +++ b/drivers/acpi/acpi_lpss.c
> @@ -157,6 +157,15 @@ static const struct acpi_device_id acpi_lpss_device_ids[] = {
>  	{ "80860F41", (unsigned long)&byt_i2c_dev_desc },
>  	{ "INT33B2", },
>  
> +	{ "INT3430", (unsigned long)&lpt_dev_desc },
> +	{ "INT3431", (unsigned long)&lpt_dev_desc },
> +	{ "INT3432", (unsigned long)&lpt_dev_desc },
> +	{ "INT3433", (unsigned long)&lpt_dev_desc },
> +	{ "INT3434", (unsigned long)&lpt_uart_dev_desc },
> +	{ "INT3435", (unsigned long)&lpt_uart_dev_desc },
> +	{ "INT3436", (unsigned long)&lpt_sdio_dev_desc },
> +	{ "INT3437", },
> +
>  	{ }
>  };
>  
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
