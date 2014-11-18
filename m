Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854AbaKRPVQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:21:16 -0500
Received: from 8bytes.org ([81.169.241.247]:33244 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754881AbaKRPVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 10:21:12 -0500
Date: Tue, 18 Nov 2014 16:21:09 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, Yijing Wang <wangyijing@huawei.com>,
        Tony Luck <tony.luck@intel.com>, iommu@lists.linux-foundation.org,
        linux-pci@vger.kernel.org, linux-hotplug@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
Subject: Re: [Patch Part3 V7 0/8] Enable support of Intel DMAR device hotplug
Message-ID: <20141118152109.GE3762@8bytes.org>
References: <1415544483-27990-1-git-send-email-jiang.liu@linux.intel.com>
 <20141118102537.GB3762@8bytes.org>
 <546B4249.7050502@linux.intel.com>
 <20141118142815.GD3762@8bytes.org>
 <546B5D8D.8050601@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546B5D8D.8050601@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 10:54:05PM +0800, Jiang Liu wrote:
> 	Could you please help to make the branch immutable
> so we could pull it into tip/x86/apic to solve some conflicts
> between IOMMU hotplug and hierarchy irqdomain patch sets?

Yes, the patches are in my x86/vt-d branch and that branch will not be
rebased. So this can be pulled into tip/x86/apic.


	Joerg

