Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097Ab3DWMfX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 08:35:23 -0400
Received: from 8bytes.org ([85.214.48.195]:54228 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755000Ab3DWMfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 08:35:22 -0400
Date: Tue, 23 Apr 2013 14:35:16 +0200
From: Joerg Roedel <joro@8bytes.org>
To: suravee.suthikulpanit@amd.com
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1 V2] iommu/AMD: Per-thread IOMMU Interrupt Handling
Message-ID: <20130423123515.GA2589@8bytes.org>
References: <1366666354-4399-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366666354-4399-1-git-send-email-suravee.suthikulpanit@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Apr 23 14:35:19 2013
X-DSPAM-Confidence: 0.9990
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5176800723671856117436
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 22, 2013 at 04:32:34PM -0500, suravee.suthikulpanit@amd.com wrote:
>  drivers/iommu/amd_iommu.c      |   82 ++++++++++++++++------------------------
>  drivers/iommu/amd_iommu_init.c |    2 +-
>  2 files changed, 34 insertions(+), 50 deletions(-)

Applied to x86/amd, thanks.


