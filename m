Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936Ab3CAQ1q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 11:27:46 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:48980 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367Ab3CAQ1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 11:27:43 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sander Eikelenboom <linux@eikelenboom.it>
Cc: aaron.lu@intel.com, jgarzik@pobox.com, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH] libata-acpi.c: fix copy and paste mistake in ata_acpi_register_power_resource
Date: Fri, 01 Mar 2013 17:34:32 +0100
Message-ID: <2944715.8ytIW0aehH@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1362136602-30327-1-git-send-email-linux@eikelenboom.it>
References: <2508494.4AbRYXD1du@vostro.rjw.lan> <1362136602-30327-1-git-send-email-linux@eikelenboom.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 01, 2013 12:16:42 PM Sander Eikelenboom wrote:
> Fix a copy and paste mistake introduced in:
> 
> commit bc9b6407bd6df3ab7189e5622816bbc11ae9d2d8
> "ACPI / PM: Rework the handling of devices depending on power resources"
> 
> Signed-off-by: Sander Eikelenboom <linux@eikelenboom.it>

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

> ---
>  drivers/ata/libata-acpi.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
> index 0ea1018..cb3eab6d 100644
> --- a/drivers/ata/libata-acpi.c
> +++ b/drivers/ata/libata-acpi.c
> @@ -1027,7 +1027,7 @@ static void ata_acpi_register_power_resource(struct ata_device *dev)
>  
>  	handle = ata_dev_acpi_handle(dev);
>  	if (handle)
> -		acpi_dev_pm_remove_dependent(handle, &sdev->sdev_gendev);
> +		acpi_dev_pm_add_dependent(handle, &sdev->sdev_gendev);
>  }
>  
>  static void ata_acpi_unregister_power_resource(struct ata_device *dev)
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
