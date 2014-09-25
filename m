Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110AbaIYTyA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 15:54:00 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:61826 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750843AbaIYTx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 15:53:58 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [Patch v6 00/15] Enable support of IOAPIC hotplug on x86 platforms
Date: Thu, 25 Sep 2014 22:13:48 +0200
Message-ID: <1820671.ppyU8YT1yY@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <alpine.DEB.2.10.1409251451040.4604@nanos>
References: <1411549176-30780-1-git-send-email-jiang.liu@linux.intel.com> <alpine.DEB.2.10.1409251451040.4604@nanos>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 25, 2014 03:33:13 PM Thomas Gleixner wrote:
> On Wed, 24 Sep 2014, Jiang Liu wrote:
> 
> > This patch set enhances IOAPIC core and ACPI drivers to support IOAPIC
> > hotplug on x86 platforms. It's based on latest mainstream kernel at
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> > 
> > You may pull it from 
> > https://github.com/jiangliu/linux.git ioapic/hotplug_v6
> > 
> > We have pick up several patches from Yinghai's original IOAPIC hotplug
> > patch set and reimplemented IOAPIC driver as an ACPI driver instead of
> > a PCI driver.
> > 
> > It has been tested on a 4-socket Intel SDV with socket hot-addition
> > capability. Any suggestions are welcomed!
> 
> This looks pretty good now.
> 
> Though I'd like to have the Acked-bys for the ACPI portion of the
> series from the ACPI maintainers before I queue it up in tip.

Honestly, I need some time to review this.  I'll try to do that next week
unless someone dupms an "interesting" bug report on me in the meantime.

> So this is going to be 3.19 material as we need some exposure in -next
> and other testing. I would also like to bring the other part of the
> rework (the hierarchical irqdomains) into testing ASAP.

Sounds good.

Rafael

