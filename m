Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758423AbaGDKkZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 06:40:25 -0400
Received: from 8bytes.org ([85.214.48.195]:42314 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756804AbaGDKkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 06:40:23 -0400
Date: Fri, 4 Jul 2014 12:40:21 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH 1/1] drivers/iommu/omap-iovmm.c: use PAGE_ALIGNED instead
 of IS_ALIGNED(PAGE_SIZE
Message-ID: <20140704104020.GC13434@8bytes.org>
References: <1402783114-11261-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402783114-11261-1-git-send-email-fabf@skynet.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Fri Jul  4 12:40:22 2014
X-DSPAM-Confidence: 0.9991
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 53b6849620861991716918
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 14, 2014 at 11:58:34PM +0200, Fabian Frederick wrote:
> use mm.h definition
> 
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: iommu@lists.linux-foundation.org
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  drivers/iommu/omap-iovmm.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)

Applied to arm/omap, thanks.


