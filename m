Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693AbaKRKvu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 05:51:50 -0500
Received: from 8bytes.org ([81.169.241.247]:59018 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753020AbaKRKvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 05:51:47 -0500
Date: Tue, 18 Nov 2014 11:51:45 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [Patch Part3 v3 00/38] Enable hierarchy irqdomian on x86
 platforms
Message-ID: <20141118105145.GC3762@8bytes.org>
References: <1415470418-10874-1-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415470418-10874-1-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiang,

On Sun, Nov 09, 2014 at 02:13:00AM +0800, Jiang Liu wrote:
> This is the last part to enable support of hierarchy domain on x86
> platforms.
> 
> It first converts IOAPIC to support hierarchy irqdomain, then cleans
> up all unused code and interfaces. It also introduces a kernel boot
> parameter to configure CPU vector allocation policies.
> 
> It's based on my previous patch set at:
> https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg760868.html
> And you may access it at:
> https://github.com/jiangliu/linux.git irqdomain/p3v3
> 
> It has been tested on Intel 64-bit server and 32-bit laptop. It also
> passes Fengguang's 0day tests. Helps are welcomed for testing:
> 1) Intel MID platform
> 2) Intel CE or OLPC platforms
> 
> Patch 1-3 kills pre_init_apic_IRQ0().
> Patch 4-9 convert IOAPIC to use hierarch irqdomain
> Patch 10-36 clean up code, unused interfaces etc.
> Patch 37-38 introduces a mechanism to configure CPU vector allocation
> 	policies.

Did some more testing on my machines and it looks good now, no more boot
panics or other anomalies. So feel free to add my

Tested-by: Joerg Roedel <jroedel@suse.de>

