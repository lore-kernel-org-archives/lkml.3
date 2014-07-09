Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234AbaGIOEr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 10:04:47 -0400
Received: from 8bytes.org ([85.214.48.195]:49623 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778AbaGIOEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 10:04:46 -0400
Date: Wed, 9 Jul 2014 16:04:43 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Oded Gabbay <oded.gabbay@amd.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Alexey Skidanov <Alexey.Skidanov@amd.com>
Subject: Re: [PATCH 1/2] iommu/amd: Fix for pasid initialization
Message-ID: <20140709140442.GK1958@8bytes.org>
References: <1404829817-19584-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404829817-19584-1-git-send-email-oded.gabbay@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Jul  9 16:04:44 2014
X-DSPAM-Confidence: 0.9992
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 53bd4bfc20864214418479
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 05:30:16PM +0300, Oded Gabbay wrote:
> From: Alexey Skidanov <Alexey.Skidanov@amd.com>
> 
> The pasid wasn't properly initialized before caling to invalid PPR calback
> 
> Signed-off-by: Alexey Skidanov <Alexey.Skidanov@amd.com>
> Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
> ---
>  drivers/iommu/amd_iommu_v2.c | 1 +
>  1 file changed, 1 insertion(+)

Applied both, thanks Oded.


