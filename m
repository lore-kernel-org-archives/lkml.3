Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbaCXPsM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 11:48:12 -0400
Received: from 8bytes.org ([85.214.48.195]:59807 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752675AbaCXPsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 11:48:10 -0400
Date: Mon, 24 Mar 2014 16:48:06 +0100
From: Joerg Roedel <joro@8bytes.org>
To: suravee.suthikulpanit@amd.com
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kim.naru@amd.com, jay.cornwall@amd.com
Subject: Re: [PATCH V2] iommu/amd: Fix logic to determine and checking max
 PASID
Message-ID: <20140324154806.GB2775@8bytes.org>
References: <1394067258-5968-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394067258-5968-1-git-send-email-suravee.suthikulpanit@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Mon Mar 24 16:48:08 2014
X-DSPAM-Confidence: 0.9989
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 533053b820863417519847
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 06:54:18PM -0600, suravee.suthikulpanit@amd.com wrote:
> From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> 
> In reality, the spec can only support 16-bit PASID since
> INVALIDATE_IOTLB_PAGES and COMPLETE_PPR_REQUEST commands only allow 16-bit
> PASID. So, we updated the PASID_MASK accordingly and invoke BUG_ON
> if the hardware is reporting PASmax more than 16-bit.
> 
> Besides, max PASID is defined as ((2^(PASmax+1)) - 1). The current does not
> determine this correctly.
> 
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> Tested-by: Jay Cornwall <Jay.Cornwall@amd.com>

Applied, thanks.

Btw, is there any publicly available driver/way/whatever for me to test the
AMD IOMMUv2 code paths?


	Joerg


