Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933388AbaKROyQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:54:16 -0500
Received: from mga03.intel.com ([134.134.136.65]:39756 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754800AbaKROyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:54:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="488413577"
Message-ID: <546B5D8D.8050601@linux.intel.com>
Date: Tue, 18 Nov 2014 22:54:05 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: David Woodhouse <dwmw2@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, Yijing Wang <wangyijing@huawei.com>,
        Tony Luck <tony.luck@intel.com>, iommu@lists.linux-foundation.org,
        linux-pci@vger.kernel.org, linux-hotplug@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
Subject: Re: [Patch Part3 V7 0/8] Enable support of Intel DMAR device hotplug
References: <1415544483-27990-1-git-send-email-jiang.liu@linux.intel.com> <20141118102537.GB3762@8bytes.org> <546B4249.7050502@linux.intel.com> <20141118142815.GD3762@8bytes.org>
In-Reply-To: <20141118142815.GD3762@8bytes.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/18 22:28, Joerg Roedel wrote:
> On Tue, Nov 18, 2014 at 08:57:45PM +0800, Jiang Liu wrote:
>> 	Bjorn has given his acked-by for v6 at
>> https://lkml.org/lkml/2014/9/24/975. But I forgot to carry this
>> acked-by, sorry:(
> 
> Okay, I see, applied the patch with the Acked-by, thanks.
Hi Joerg,
	Could you please help to make the branch immutable
so we could pull it into tip/x86/apic to solve some conflicts
between IOMMU hotplug and hierarchy irqdomain patch sets?
Regards!
Gerry
> 
> 
> 	Joerg
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
