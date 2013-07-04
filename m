Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634Ab3GDMlO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 08:41:14 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:58237 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167Ab3GDMlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 08:41:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Haicheng Li <haicheng.li@linux.intel.com>
Cc: linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org, Haicheng Li <haicheng.lee@gmail.com>
Subject: Re: [PATCH] acpi: remove unused LIST_HEAD(acpi_device_list)
Date: Thu, 04 Jul 2013 14:50:53 +0200
Message-ID: <41636089.XPqKizzent@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1372910831-19721-1-git-send-email-haicheng.li@linux.intel.com>
References: <20130704022730.GB3244@hli22-desktop> <1372910831-19721-1-git-send-email-haicheng.li@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 04, 2013 12:07:11 PM Haicheng Li wrote:
> acpi_device_list is not used by acpi code anymore, could be removed.
> 
> Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>

OK, applied.

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
