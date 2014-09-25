Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbaIYNdz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 09:33:55 -0400
Received: from www.linutronix.de ([62.245.132.108]:33598 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbaIYNdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 09:33:54 -0400
Date: Thu, 25 Sep 2014 15:33:13 +0200 (CEST)
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
Subject: Re: [Patch v6 00/15] Enable support of IOAPIC hotplug on x86
 platforms
In-Reply-To: <1411549176-30780-1-git-send-email-jiang.liu@linux.intel.com>
Message-ID: <alpine.DEB.2.10.1409251451040.4604@nanos>
References: <1411549176-30780-1-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep 2014, Jiang Liu wrote:

> This patch set enhances IOAPIC core and ACPI drivers to support IOAPIC
> hotplug on x86 platforms. It's based on latest mainstream kernel at
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> 
> You may pull it from 
> https://github.com/jiangliu/linux.git ioapic/hotplug_v6
> 
> We have pick up several patches from Yinghai's original IOAPIC hotplug
> patch set and reimplemented IOAPIC driver as an ACPI driver instead of
> a PCI driver.
> 
> It has been tested on a 4-socket Intel SDV with socket hot-addition
> capability. Any suggestions are welcomed!

This looks pretty good now.

Though I'd like to have the Acked-bys for the ACPI portion of the
series from the ACPI maintainers before I queue it up in tip.

So this is going to be 3.19 material as we need some exposure in -next
and other testing. I would also like to bring the other part of the
rework (the hierarchical irqdomains) into testing ASAP.

Thanks,

	tglx




