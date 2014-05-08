Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814AbaEHP6R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 11:58:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:11519 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776AbaEHP6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 11:58:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1010,1389772800"; 
   d="scan'208";a="508465390"
Message-ID: <536BA96F.1030203@intel.com>
Date: Thu, 08 May 2014 08:57:35 -0700
From: Alexander Duyck <alexander.h.duyck@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jet Chen <jet.chen@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        Dave Jiang <dave.jiang@intel.com>
CC: fengguang.wu@intel.com, wei.w.lin@intel.com, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org
Subject: Re: [PATCH] DCA: fix over-warning in ioat3_dca_init
References: <1399542166-42985-1-git-send-email-jet.chen@intel.com> <536B9CF6.9000907@intel.com> <536BA2A3.50506@intel.com>
In-Reply-To: <536BA2A3.50506@intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2014 08:28 AM, Jet Chen wrote:
> I agree with your option that it is a real BIOS bug and it puts pressure on the BIOS guys to get this fixed. However, this warning message interferes with our kernel booting tests and kernel performance tests. We have to disable CONFIG_INTEL_IOATDMA in kconfig until this issue gets fixed. Before that, code of CONFIG_INTEL_IOATDMA will not be validated in our testing system :(.
> Hope this issue could get fixed soon.
> 
> Thanks,
> Jet
> 

First I would recommend updating your BIOS.  If the updated BIOS also
has the issue I would recommend taking this feedback to whoever provided
the BIOS for your platform so that they can implement the fix.

If I am not mistaken some BIOSes have the option to disable DCA and/or
IOATDMA.  You might want to check yours to see if you can just disable
DCA on your platform until the issue can be resolved.

Thanks,

Alex

