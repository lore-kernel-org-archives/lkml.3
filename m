Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751411AbaKFNH6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 08:07:58 -0500
Received: from 8bytes.org ([81.169.241.247]:49311 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915AbaKFNHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 08:07:55 -0500
Date: Thu, 6 Nov 2014 14:07:53 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [Patch Part2 v4 00/31] Enable hierarchy irqdomian on x86
 platforms
Message-ID: <20141106130753.GN10744@8bytes.org>
References: <1415102525-9898-1-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415102525-9898-1-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 08:01:34PM +0800, Jiang Liu wrote:
> Patch 1-5 enhance irqdomain and irq core to support hierarchy irqdomain
> and stacked irqchip.
> Patch 6-12 implement an irqdomain to manange CPU interrupt vectors, and
> it's the root irqdomain for x86 platforms.
> Patch 13-16 converts Intel and AMD interrupt remapping drivers to
> support hierarchy irqdomain.
> Patch 17-23 converts HPET and MSI to support hierarchy irqdomain.
> Patch 24-27 cleans up unsued code in x86 arch and interrupt remapping
> drivers.
> Patch 28-31 converts DMAR, HTIRQ and UV to support hierarchy irqdomain.

Okay, I looked over the IOMMU changes and did some testing. With Jiangs
fix for the AMD Kaveri boot panic it looks good to me. So for the IOMMU
parts:

Acked-by: Joerg Roedel <jroedel@suse.de>

