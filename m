Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065AbaKDPcK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 10:32:10 -0500
Received: from 8bytes.org ([81.169.241.247]:34725 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999AbaKDPcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 10:32:06 -0500
Date: Tue, 4 Nov 2014 16:32:03 +0100
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
Message-ID: <20141104153203.GE10744@8bytes.org>
References: <1415102525-9898-1-git-send-email-jiang.liu@linux.intel.com>
 <20141104144730.GE14512@8bytes.org>
 <5458ECF3.4040308@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5458ECF3.4040308@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 11:12:51PM +0800, Jiang Liu wrote:
> 	Do you have the call stack? I have changed the way to call
> irq_set_msi_desc_off() for MSI/MSIx interrupts, which may cause the
> panic. Patch 19-21 changes the PCI MSI code.

Unfortunatly I have no full call-stack yet, as the intersting parts
scrolled out of the screen. But the last interesting function seen there
was do_one_initcall(). I'll try to setup serial console on the machine
and let you know when I have a full call-stack.


	Joerg
