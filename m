Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355AbaFZOAJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 10:00:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:44574 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756178AbaFZOAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 10:00:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="357577676"
Message-ID: <53AC275E.4090602@linux.intel.com>
Date: Thu, 26 Jun 2014 21:59:58 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, Yijing Wang <wangyijing@huawei.com>,
        Tony Luck <tony.luck@intel.com>,
        "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux-foundation.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux hotplug mailing <linux-hotplug@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dmaengine@vger.kernel.org
Subject: Re: [Patch Part3 V3 00/21] Enable support of Intel DMAR device hotplug
References: <1403686967-10887-1-git-send-email-jiang.liu@linux.intel.com> <CAErSpo5z9OH_u3f9L5qKoJsJ+mgRU5rba9mnQG0Y5XXn0zcEvg@mail.gmail.com>
In-Reply-To: <CAErSpo5z9OH_u3f9L5qKoJsJ+mgRU5rba9mnQG0Y5XXn0zcEvg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/6/26 2:00, Bjorn Helgaas wrote:
>>   iommu/vt-d: match segment number when searching for dev_iotlb capable
>>     devices
>>   iommu/vt-d: use correct domain id to flush virtual machine domains
>>   iommu/vt-d: introduce helper functions to improve code readability
>>   iommu/vt-d: introduce helper functions to make code symmetric for
>>     readability
>>   iommu/vt-d: only dynamically allocate domain id for virtual domains
>>   iommu/vt-d: fix possible invalid memory access caused by
>>     free_dmar_iommu()
>>   iommu/vt-d: avoid freeing virtual machine domain in free_dmar_iommu()
>>   iommu/VT-d: simplify include/linux/dmar.h
>>   iommu/vt-d: change iommu_enable/disable_translation to return void
>>   iommu/vt-d: simplify intel_unmap_sg() and kill duplicated code
>>   iommu/vt-d: introduce helper domain_pfn_within_range() to simplify
>>     code
>>   iommu/vt-d: introduce helper function iova_size() to improve code
>>     readability
>>   iommu/vt-d: fix bug in computing domain's iommu_snooping flag
>>   IOMMU/vt-d: introduce helper function dmar_walk_resources()
>>   iommu/vt-d: dynamically allocate and free seq_id for DMAR units
>>   iommu/vt-d: implement DMAR unit hotplug framework
>>   iommu/vt-d: search _DSM method for DMAR hotplug
>>   iommu/vt-d: enhance intel_irq_remapping driver to support DMAR unit
>>     hotplug
>>   iommu/vt-d: enhance error recovery in function
>>     intel_enable_irq_remapping()
>>   iommu/vt-d: enhance intel-iommu driver to support DMAR unit hotplug
>>   pci, ACPI, iommu: enhance pci_root to support DMAR device hotplug
> 
> This looks a little sloppy; you have three different ways of
> capitalizing the area:
> 
>   iommu/vt-d:
>   iommu/VT-d:
>   IOMMU/vt-d:
> 
> Also, "git log --oneline drivers/iommu" says that the convention for
> drivers/iommu is to capitalize the first word of the rest of the
> subject line.
Hi Bjorn,
	Really sorry about my careless. I just rebased the patch set
onto v3.16-rc1, I should do more careful check about the commit
messages. I will wait for more comments and resend a new version
to address the commit message issues.
	Thanks for your reminder again.
Regards!
Gerry
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
