Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340Ab3GEMIi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 08:08:38 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:59407 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756596Ab3GEMIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 08:08:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI / power: add missing newline to debug messages
Date: Fri, 05 Jul 2013 14:18:14 +0200
Message-ID: <2462906.A69BgWcTke@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1373015756-29635-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1373015756-29635-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 05, 2013 12:15:56 PM Mika Westerberg wrote:
> There are few places in power.c where debug messages have no newline at the
> end. Reading such debug messages from dmesg is not fun so fix this by
> adding the missing newlines.
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Applied, thanks!

Rafael


> ---
>  drivers/acpi/power.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
> index 288bb27..5c28c89 100644
> --- a/drivers/acpi/power.c
> +++ b/drivers/acpi/power.c
> @@ -279,7 +279,7 @@ static int acpi_power_on_unlocked(struct acpi_power_resource *resource)
>  
>  	if (resource->ref_count++) {
>  		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
> -				  "Power resource [%s] already on",
> +				  "Power resource [%s] already on\n",
>  				  resource->name));
>  	} else {
>  		result = __acpi_power_on(resource);
> @@ -325,7 +325,7 @@ static int acpi_power_off_unlocked(struct acpi_power_resource *resource)
>  
>  	if (!resource->ref_count) {
>  		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
> -				  "Power resource [%s] already off",
> +				  "Power resource [%s] already off\n",
>  				  resource->name));
>  		return 0;
>  	}
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
