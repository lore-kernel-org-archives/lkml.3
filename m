Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab3AVWUs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 17:20:48 -0500
Received: from mail-ia0-f172.google.com ([209.85.210.172]:58206 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812Ab3AVWUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 17:20:45 -0500
MIME-Version: 1.0
In-Reply-To: <1726547.g8rCOVpa6k@vostro.rjw.lan>
References: <1518653.CUpDmbmCI3@vostro.rjw.lan>
	<CAE9FiQV1N0hrUui1rGrs1=kFJFiuOhZ6tT-wGfK-B25it5feLQ@mail.gmail.com>
	<4046863.eHD8RPonGC@vostro.rjw.lan>
	<1726547.g8rCOVpa6k@vostro.rjw.lan>
Date: Tue, 22 Jan 2013 14:20:44 -0800
X-Google-Sender-Auth: Ej7JLRxBQ4TC0eYMgkVEc6yfqGg
Message-ID: <CAE9FiQVknKDc6WtNGB1C8eMYZQOKJD5ak5+hE1jvpaEaGGzULg@mail.gmail.com>
Subject: Re: [PATCH] ACPI: Drop device start operation that is not used
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Toshi Kani <toshi.kani@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 2:25 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> The ACPI device start operation, acpi_op_start, is never used, so
> drop it.
>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
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
>         acpi_op_add add;
>         acpi_op_remove remove;
> -       acpi_op_start start;
>         acpi_op_notify notify;
>  };
>
>

Acked-by: Yinghai Lu <yinghai@kernel.org>
