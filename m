Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657AbaAGORA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 09:17:00 -0500
Received: from 8bytes.org ([85.214.48.195]:36149 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974AbaAGOQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 09:16:51 -0500
Date: Tue, 7 Jan 2014 15:16:48 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Brian Norris <computersforpeace@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        iommu@lists.linux-foundation.org, Hiroshi DOYU <hdoyu@nvidia.com>
Subject: Re: [PATCH] iommu: add missing include
Message-ID: <20140107141646.GB2742@8bytes.org>
References: <1386206573-16158-1-git-send-email-computersforpeace@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386206573-16158-1-git-send-email-computersforpeace@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Jan  7 15:16:50 2014
X-DSPAM-Confidence: 0.9991
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 52cc0c5220864868522277
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 05:22:53PM -0800, Brian Norris wrote:
> Fix a warning in of_iommu.c:
> 
> drivers/iommu/of_iommu.c:38:5: warning: no previous prototype for 'of_get_dma_window' [-Wmissing-prototypes]
> 
> Signed-off-by: Brian Norris <computersforpeace@gmail.com>
> Cc: Hiroshi DOYU <hdoyu@nvidia.com>

Applied, thanks.


