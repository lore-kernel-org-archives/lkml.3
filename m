Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724Ab3BEFoN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 00:44:13 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42934 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab3BEFoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 00:44:12 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <51109C13.80907@jp.fujitsu.com>
Date: Tue, 5 Feb 2013 14:43:47 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: liguang <lig.fnst@cn.fujitsu.com>
CC: <linux-kernel@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
        <x86@kernel.org>, <rientjes@google.com>
Subject: Re: [PATCH v2 4/4] remove include asm/acpi.h in process_driver.c
References: <1360031838-26898-1-git-send-email-lig.fnst@cn.fujitsu.com> <1360031838-26898-5-git-send-email-lig.fnst@cn.fujitsu.com>
In-Reply-To: <1360031838-26898-5-git-send-email-lig.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/02/05 11:37, liguang wrote:
> process_driver.c include linux/acpi.h which already
> include asm/acpi.h, so remove it.
> 
> Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
> ---

Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Thanks,
Yasuaki Ishimatsu

>   drivers/acpi/processor_driver.c |    1 -
>   1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
> index e83311b..752eedb 100644
> --- a/drivers/acpi/processor_driver.c
> +++ b/drivers/acpi/processor_driver.c
> @@ -52,7 +52,6 @@
>   #include <asm/uaccess.h>
>   #include <asm/processor.h>
>   #include <asm/smp.h>
> -#include <asm/acpi.h>
>   
>   #include <acpi/acpi_bus.h>
>   #include <acpi/acpi_drivers.h>
> 


