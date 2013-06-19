Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933392Ab3FSEo2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 00:44:28 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35130 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab3FSEo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 00:44:26 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <51C13703.8040909@jp.fujitsu.com>
Date: Wed, 19 Jun 2013 13:43:47 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: <rjw@sisk.pl>, <linux-acpi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ACPI: Remove the use of CONFIG_ACPI_HOTPLUG_MEMORY_MODULE
References: <1371589605-15638-1-git-send-email-toshi.kani@hp.com>
In-Reply-To: <1371589605-15638-1-git-send-email-toshi.kani@hp.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/06/19 6:06, Toshi Kani wrote:
> config ACPI_HOTPLUG_MEMORY has been changed to bool (y/n), and
> its module option is no longer valid.  So, remove the use of
> CONFIG_ACPI_HOTPLUG_MEMORY_MODULE.
> 
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> ---
>   include/linux/acpi.h |    3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/include/linux/acpi.h b/include/linux/acpi.h
> index 17b5b59..353ba25 100644
> --- a/include/linux/acpi.h
> +++ b/include/linux/acpi.h
> @@ -352,8 +352,7 @@ extern acpi_status acpi_pci_osc_control_set(acpi_handle handle,
>   
>   /* Enable _OST when all relevant hotplug operations are enabled */
>   #if defined(CONFIG_ACPI_HOTPLUG_CPU) &&			\
> -	(defined(CONFIG_ACPI_HOTPLUG_MEMORY) ||		\
> -	 defined(CONFIG_ACPI_HOTPLUG_MEMORY_MODULE)) &&	\
> +	defined(CONFIG_ACPI_HOTPLUG_MEMORY) &&		\
>   	defined(CONFIG_ACPI_CONTAINER)
>   #define ACPI_HOTPLUG_OST
>   #endif
> --
Good catch!!

Acked-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Thanks,
Yasuaki Ishimatsu

> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


