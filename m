Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757885Ab3FTOkW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 10:40:22 -0400
Received: from 8bytes.org ([85.214.48.195]:35185 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757720Ab3FTOkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 10:40:21 -0400
Date: Thu, 20 Jun 2013 16:40:17 +0200
From: Joerg Roedel <joro@8bytes.org>
To: "Li, Zhen-Hua" <zhen-hual@hp.com>
Cc: Ingo Molnar <mingo@kernel.org>, Donald Dutile <ddutile@redhat.com>,
        Linn Crosetto <linn@hp.com>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org
Subject: Re: [PATCH 1/1] iommu: DMAR reporting table needs at least one DRHD
Message-ID: <20130620144017.GA3589@8bytes.org>
References: <1369036652-20022-1-git-send-email-zhen-hual@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369036652-20022-1-git-send-email-zhen-hual@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu Jun 20 16:40:19 2013
X-DSPAM-Confidence: 0.9993
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 51c3145320861578718688
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 20, 2013 at 03:57:32PM +0800, Li, Zhen-Hua wrote:
> In intel vt-d spec , chapter 8.1 , DMA Remapping Reporting Structure.
> In the end of the table, it says:
> 
> Remapping Structures[]
> -
> A list of structures. The list will contain one or
> more DMA Remapping Hardware Unit Definition
> (DRHD) structures, and zero or more Reserved
> Memory Region Reporting (RMRR) and Root Port
> ATS Capability Reporting (ATSR) structures.
> These structures are described below.
> 
> So, there should be at least one DRHD structure in DMA Remapping
> reporting table. If there is no DRHD found, a warning is necessary.
> 
> Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>

Tweaked the error message a bit and applied to x86/vt-d, thanks.


