Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbaEZJ2t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 05:28:49 -0400
Received: from 8bytes.org ([85.214.48.195]:34827 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751946AbaEZJ2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 05:28:48 -0400
Date: Mon, 26 May 2014 11:28:45 +0200
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org
Cc: Jay.Cornwall@amd.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] AMD IOMMUv2 Cleanups and Fixes
Message-ID: <20140526092843.GB11299@8bytes.org>
References: <1400620706-21031-1-git-send-email-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400620706-21031-1-git-send-email-joro@8bytes.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Mon May 26 11:28:46 2014
X-DSPAM-Confidence: 0.9986
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5383094e20862021459359
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 11:18:21PM +0200, Joerg Roedel wrote:
> Joerg Roedel (5):
>       iommu/amd: Don't access IOMMUv2 state_table directly
>       iommu/amd: Convert IOMMUv2 state_table into state_list
>       iommu/amd: Implement mmu_notifier_release call-back
>       iommu/amd: Remove IOMMUv2 pasid_state_list
>       iommu/amd: Handle parallel invalidate_range_start/end calls correctly

Applied.


