Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933279Ab3GCVO3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 17:14:29 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:57659 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752340Ab3GCVO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 17:14:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Haicheng Li <haicheng.li@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Haicheng Li <haicheng.lee@gmail.com>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 3/3] acpi: remove unused LIST_HEAD(acpi_device_list)
Date: Wed, 03 Jul 2013 23:24:03 +0200
Message-ID: <2729967.3EomeQlnR1@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1372864578-6925-3-git-send-email-haicheng.li@linux.intel.com>
References: <1372864578-6925-1-git-send-email-haicheng.li@linux.intel.com> <1372864578-6925-3-git-send-email-haicheng.li@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 03, 2013 11:16:18 PM Haicheng Li wrote:
> Cc: Len Brown <lenb@kernel.org>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Cc: linux-acpi@vger.kernel.org
> Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>

-ENOCHANGELOG

Apart from this, please send the *whole* patchset to linux-acpi.

Thanks,
Rafael


> ---
>  drivers/acpi/scan.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index 27da630..fcc0cdc 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -29,7 +29,6 @@ extern struct acpi_device *acpi_root;
>  
>  static const char *dummy_hid = "device";
>  
> -static LIST_HEAD(acpi_device_list);
>  static LIST_HEAD(acpi_bus_id_list);
>  static DEFINE_MUTEX(acpi_scan_lock);
>  static LIST_HEAD(acpi_scan_handlers_list);
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
