Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751371AbaKFMAU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 07:00:20 -0500
Received: from www.linutronix.de ([62.245.132.108]:42219 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbaKFMAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 07:00:16 -0500
Date: Thu, 6 Nov 2014 12:59:25 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jiang Liu <jiang.liu@linux.intel.com>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Alexander Gordeev <agordeev@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, LAK <linux-arm-kernel@lists.infradead.org>
Subject: Re: [Patch Part2 v4 21/31] PCI/MSI: enhance PCI MSI core to support
 hierarchy irqdomain
In-Reply-To: <545B5E5B.8090300@linux.intel.com>
Message-ID: <alpine.DEB.2.11.1411061258560.24960@nanos>
References: <1415102525-9898-1-git-send-email-jiang.liu@linux.intel.com> <1415102525-9898-22-git-send-email-jiang.liu@linux.intel.com> <alpine.DEB.2.11.1411061023400.24960@nanos> <545B5E5B.8090300@linux.intel.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Nov 2014, Jiang Liu wrote:
> On 2014/11/6 18:01, Thomas Gleixner wrote:
> Hi Thomas,
> 	Actually I'm working on a patch set to improve MSI support in
> the way you described above this afternoon. And I'm also trying to
> split MSI code into PCI dependent part and PCI independent part.
> I plan to add a file kernel/irq/msi.c to host PCI independent part,

kernel/irq/msi.c is fine.

Thanks,

	tglx
