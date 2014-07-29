Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbaG2PoX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 11:44:23 -0400
Received: from 8bytes.org ([81.169.241.247]:52144 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248AbaG2PoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 11:44:20 -0400
Date: Tue, 29 Jul 2014 17:44:17 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: iommu@lists.linux-foundation.org, dwmw2@infradead.org, chegu_vinod@hp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH v2] iommu/intel: Exclude devices using RMRRs from
 IOMMU API domains
Message-ID: <20140729154417.GB27589@8bytes.org>
References: <20140703155435.8419.72901.stgit@gimli.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140703155435.8419.72901.stgit@gimli.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2014 at 09:57:02AM -0600, Alex Williamson wrote:
> The user of the IOMMU API domain expects to have full control of
> the IOVA space for the domain.  RMRRs are fundamentally incompatible
> with that idea.  We can neither map the RMRR into the IOMMU API
> domain, nor can we guarantee that the device won't continue DMA with
> the area described by the RMRR as part of the new domain.  Therefore
> we must prevent such devices from being used by the IOMMU API.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: stable@vger.kernel.org

Applied, thanks Alex.
