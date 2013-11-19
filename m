Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab3KSRYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 12:24:20 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:38334 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909Ab3KSRYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 12:24:18 -0500
MIME-Version: 1.0
In-Reply-To: <1384870535-20532-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1384870535-20532-1-git-send-email-mika.westerberg@linux.intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 19 Nov 2013 10:23:57 -0700
Message-ID: <CAErSpo56wWzNpkcEmkRnaGR4uk=eHrDzt2k-4PiHk9Rb=qRr-w@mail.gmail.com>
Subject: Re: [PATCH] PCI / hotplug / ACPI: Drop unused acpiphp_debug declaration
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 7:15 AM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> Commit bd950799d951 (PCI: acpiphp: Convert to dynamic debug) removed users
> of acpiphp_debug variable and the variable itself but the declaration was
> left in the header file. Drop this unused declaration.
>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Rafael, if it makes sense for you to apply this, you can add my:

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

Otherwise I can pick it up.

> ---
>  drivers/pci/hotplug/acpiphp.h | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/pci/hotplug/acpiphp.h b/drivers/pci/hotplug/acpiphp.h
> index 26100f510b10..1592dbe4f904 100644
> --- a/drivers/pci/hotplug/acpiphp.h
> +++ b/drivers/pci/hotplug/acpiphp.h
> @@ -176,7 +176,6 @@ u8 acpiphp_get_latch_status(struct acpiphp_slot *slot);
>  u8 acpiphp_get_adapter_status(struct acpiphp_slot *slot);
>
>  /* variables */
> -extern bool acpiphp_debug;
>  extern bool acpiphp_disabled;
>
>  #endif /* _ACPIPHP_H */
> --
> 1.8.4.3
>
