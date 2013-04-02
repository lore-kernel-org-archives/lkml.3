Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932469Ab3DBOur (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 10:50:47 -0400
Received: from 8bytes.org ([85.214.48.195]:53778 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761234Ab3DBOup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 10:50:45 -0400
Date: Tue, 2 Apr 2013 16:50:42 +0200
From: Joerg Roedel <joro@8bytes.org>
To: suravee.suthikulpanit@amd.com
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] iommu/amd: Re-enable IOMMU event log interrupt after
 handling.
Message-ID: <20130402145041.GD15687@8bytes.org>
References: <1364428312-2611-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364428312-2611-1-git-send-email-suravee.suthikulpanit@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Apr  2 16:50:44 2013
X-DSPAM-Confidence: 0.9990
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 515af04423671361714805
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 06:51:52PM -0500, suravee.suthikulpanit@amd.com wrote:
> From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> 
> Current driver does not clear the IOMMU event log interrupt bit
> in the IOMMU status register after processing an interrupt.
> This causes the IOMMU hardware to generate event log interrupt only once.
> This has been observed in both IOMMU v1 and V2 hardware.
> This patch clears the bit by writing 1 to bit 1 of the IOMMU
> status register (MMIO Offset 2020h)
> 
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

Applied to x86/amd, thanks.


