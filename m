Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965130Ab3FTKA4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 06:00:56 -0400
Received: from 8bytes.org ([85.214.48.195]:34503 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754512Ab3FTKAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 06:00:55 -0400
Date: Thu, 20 Jun 2013 12:00:52 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: Re: [PATCH 08/11] iommu/msm: Move mach includes to iommu directory
Message-ID: <20130620100052.GL2575@8bytes.org>
References: <1371600281-6118-1-git-send-email-sboyd@codeaurora.org>
 <1371600281-6118-9-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371600281-6118-9-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu Jun 20 12:00:53 2013
X-DSPAM-Confidence: 0.9994
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 51c2d2d520861436824276
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 05:04:38PM -0700, Stephen Boyd wrote:
> Two header files exist in mach-msm's include/mach directory that
> are only used by the MSM iommu driver. Move these files to the
> iommu driver directory and prefix them with "msm_". This allows
> us to compile the MSM iommu driver on multi-platform kernels.
> 
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Stepan Moskovchenko <stepanm@codeaurora.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
> 
> Joerg, please ack so this can go through the MSM tree.

Sure thing.

Acked-by: Joerg Roedel <joro@8bytes.org>


