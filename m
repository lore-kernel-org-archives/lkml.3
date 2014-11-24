Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbaKXHVG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 02:21:06 -0500
Received: from mga09.intel.com ([134.134.136.24]:36533 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243AbaKXHVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 02:21:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,447,1413270000"; 
   d="scan'208";a="642402254"
Message-ID: <5472DC59.5040407@linux.intel.com>
Date: Mon, 24 Nov 2014 15:20:57 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
CC: Bjorn Helgaas <bhelgaas@google.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Ingo Molnar <mingo@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: Hierarchical irqdomains - Status update
References: <alpine.DEB.2.11.1411231915010.6439@nanos>
In-Reply-To: <alpine.DEB.2.11.1411231915010.6439@nanos>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/24 3:03, Thomas Gleixner wrote:
> Folks,
> 
> I've rebased the hierarchical irqdomain code on top of Bjorns
> msi_controller rework.
> 
> Changes versus the previous version:
> 
>    - Bjorns new pci/mci branch. See also:
>         http://lkml.kernel.org/r/20141121172018.GA6578@google.com
> 
>      Thanks Bjorn for fixing that just before your vacation!
> 
>    - Rename of msi_mask/unmask_irq et al so it's clear that these
>      functions are PCI related and cannot be used for non PCI based
>      MSI functionality.
> 
>    - Folded back fixup patches
> 
>    - Added the missing parent check as reported by Suravee
> 
> The branch is now immutable and you can base your patches on it.
> 
> If you need to pull the branch into your tree, please let me know.
> 
> Patches which are mostly touching drivers/irqchip should go through
> Jason. Please post them against irq/irqdomain. We'll either create a
> seperate branch for them or merge irq/irqdomain into irq/core.
> 
> Thanks for the fruitful discussions, testing, rebasing and patience.
Thanks for your great support to enable hierarchy irqdomain.
Learned much about how to organize patches:)

> 
> Thanks,
> 
> 	tglx
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
