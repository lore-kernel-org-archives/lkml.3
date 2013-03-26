Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933931Ab3CZNP2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 09:15:28 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:42991 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933930Ab3CZNP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 09:15:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toshi Kani <toshi.kani@hp.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI: Remove acpi_pci_bind_root() definition
Date: Tue, 26 Mar 2013 14:22:52 +0100
Message-ID: <3209760.ZbIFq29Vqi@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1362770230-8734-1-git-send-email-toshi.kani@hp.com>
References: <1362770230-8734-1-git-send-email-toshi.kani@hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 08, 2013 12:17:10 PM Toshi Kani wrote:
> Noticed that acpi_pci_bind_root(), which has been deleted,
> is left defined in acpi_driver.h.  So delete this definition
> from the header as well.
> 
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>

Applied to linux-pm.git/linux-next.

Thanks,
Rafael


> ---
>  include/acpi/acpi_drivers.h |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/include/acpi/acpi_drivers.h b/include/acpi/acpi_drivers.h
> index 627749a..e6168a2 100644
> --- a/include/acpi/acpi_drivers.h
> +++ b/include/acpi/acpi_drivers.h
> @@ -95,7 +95,6 @@ int acpi_pci_link_free_irq(acpi_handle handle);
>  struct pci_bus;
>  
>  struct pci_dev *acpi_get_pci_dev(acpi_handle);
> -int acpi_pci_bind_root(struct acpi_device *device);
>  
>  /* Arch-defined function to add a bus to the system */
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
