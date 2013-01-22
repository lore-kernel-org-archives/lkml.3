Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab3AVWYp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 17:24:45 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:43618 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab3AVWYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 17:24:43 -0500
Message-ID: <1358892886.14145.355.camel@misato.fc.hp.com>
Subject: Re: [PATCH] ACPI: Drop device start operation that is not used
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Yinghai Lu <yinghai@kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 22 Jan 2013 15:14:46 -0700
In-Reply-To: <1726547.g8rCOVpa6k@vostro.rjw.lan>
References: <1518653.CUpDmbmCI3@vostro.rjw.lan>
	 <CAE9FiQV1N0hrUui1rGrs1=kFJFiuOhZ6tT-wGfK-B25it5feLQ@mail.gmail.com>
	 <4046863.eHD8RPonGC@vostro.rjw.lan> <1726547.g8rCOVpa6k@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-22 at 23:25 +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> The ACPI device start operation, acpi_op_start, is never used, so
> drop it.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Acked-by: Toshi Kani <toshi.kani@hp.com>

Thanks,
-Toshi

> ---
>  include/acpi/acpi_bus.h |    2 --
>  1 file changed, 2 deletions(-)
> 
> Index: linux-pm/include/acpi/acpi_bus.h
> ===================================================================
> --- linux-pm.orig/include/acpi/acpi_bus.h
> +++ linux-pm/include/acpi/acpi_bus.h
> @@ -90,13 +90,11 @@ struct acpi_device;
>  
>  typedef int (*acpi_op_add) (struct acpi_device * device);
>  typedef int (*acpi_op_remove) (struct acpi_device * device);
> -typedef int (*acpi_op_start) (struct acpi_device * device);
>  typedef void (*acpi_op_notify) (struct acpi_device * device, u32 event);
>  
>  struct acpi_device_ops {
>  	acpi_op_add add;
>  	acpi_op_remove remove;
> -	acpi_op_start start;
>  	acpi_op_notify notify;
>  };
>  
> 


