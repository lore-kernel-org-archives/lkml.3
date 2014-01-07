Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbaAGPZk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 10:25:40 -0500
Received: from 8bytes.org ([85.214.48.195]:36386 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933AbaAGPZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 10:25:32 -0500
Date: Tue, 7 Jan 2014 16:25:27 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, Ashok Raj <ashok.raj@intel.com>,
        Yijing Wang <wangyijing@huawei.com>, Tony Luck <tony.luck@intel.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
Subject: Re: [Patch Part1 V3 09/20] iommu/vt-d: mark internal functions as
 static
Message-ID: <20140107152523.GG2742@8bytes.org>
References: <1388989107-4795-1-git-send-email-jiang.liu@linux.intel.com>
 <1388989107-4795-10-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388989107-4795-10-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Jan  7 16:25:31 2014
X-DSPAM-Confidence: 0.9994
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 52cc1c6b20861680619344
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 06, 2014 at 02:18:16PM +0800, Jiang Liu wrote:
> Function detect_intel_iommu()/alloc_iommu()/parse_ioapics_under_ir()
> are only used internally, so mark them as static.

Doesn't seem to be true for detect_intel_iommu which is used in ia64
setup code, no?


	Joerg


