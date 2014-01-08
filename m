Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571AbaAHIoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 03:44:20 -0500
Received: from mga01.intel.com ([192.55.52.88]:13652 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755291AbaAHIoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 03:44:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,623,1384329600"; 
   d="scan'208";a="455306442"
Message-ID: <52CD0FD7.7040208@linux.intel.com>
Date: Wed, 08 Jan 2014 16:44:07 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: David Woodhouse <dwmw2@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, Ashok Raj <ashok.raj@intel.com>,
        Yijing Wang <wangyijing@huawei.com>, Tony Luck <tony.luck@intel.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
Subject: Re: [Patch Part1 V3 09/20] iommu/vt-d: mark internal functions as
 static
References: <1388989107-4795-1-git-send-email-jiang.liu@linux.intel.com> <1388989107-4795-10-git-send-email-jiang.liu@linux.intel.com> <20140107152523.GG2742@8bytes.org>
In-Reply-To: <20140107152523.GG2742@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joerg,
	Thanks for fix up this issue!
I forgot to test the changes against IA64 platform. There's another
issue related to IA64, I will send out the patch soon. I have setup
cross compilation environment for IA64 and verified all changes
passing compilation tests.

Thanks!
Gerry

On 2014/1/7 23:25, Joerg Roedel wrote:
> On Mon, Jan 06, 2014 at 02:18:16PM +0800, Jiang Liu wrote:
>> Function detect_intel_iommu()/alloc_iommu()/parse_ioapics_under_ir()
>> are only used internally, so mark them as static.
> 
> Doesn't seem to be true for detect_intel_iommu which is used in ia64
> setup code, no?
> 
> 
> 	Joerg
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
