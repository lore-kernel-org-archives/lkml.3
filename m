Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbaIKIY1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 04:24:27 -0400
Received: from www.linutronix.de ([62.245.132.108]:37980 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767AbaIKIYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 04:24:23 -0400
Date: Thu, 11 Sep 2014 10:23:36 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jiang Liu <jiang.liu@linux.intel.com>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [Patch v5 04/15] ACPI: Add interfaces to parse IOAPIC ID for
 IOAPIC hotplug
In-Reply-To: <1410422758-24942-5-git-send-email-jiang.liu@linux.intel.com>
Message-ID: <alpine.DEB.2.10.1409111021110.4178@nanos>
References: <1410422758-24942-1-git-send-email-jiang.liu@linux.intel.com> <1410422758-24942-5-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Sep 2014, Jiang Liu wrote:
> +
> +#ifdef CONFIG_ACPI_HOTPLUG_IOAPIC
> +static int map_ioapic_id(struct acpi_subtable_header *entry, u32 gsi_base,
> +			 u64 *phys_addr, int *ioapic_id)

I find these function names map_* quite confusing. All they do is a
lookup, right?

> +/**
> + * acpi_get_ioapic_id() - Get IOAPIC ID and physical address matching @gsi_base
> + * @handle ACPI object for IOAPIC device

Proper docbook formatting is:

 * acpi_get_ioapic_id - Get ....
 * @handle:	 ACPI object     

Thanks,

	tglx
