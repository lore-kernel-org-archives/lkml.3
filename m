Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241AbaCEWrj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 17:47:39 -0500
Received: from 8bytes.org ([85.214.48.195]:33494 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752970AbaCEWri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 17:47:38 -0500
Date: Wed, 5 Mar 2014 23:47:35 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Zhouyi Zhou <zhouzhouyi@gmail.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Zhouyi Zhou <yizhouzhou@ict.ac.cn>
Subject: Re: [PATCH v2] IOMMU: iopte free should check wether input argument
 is NULL
Message-ID: <20140305224735.GG27471@8bytes.org>
References: <1394014820-1249-1-git-send-email-yizhouzhou@ict.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394014820-1249-1-git-send-email-yizhouzhou@ict.ac.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Mar  5 23:47:36 2014
X-DSPAM-Confidence: 0.9994
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5317a98820864616435945
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 06:20:19PM +0800, Zhouyi Zhou wrote:
> From: Zhouyi Zhou <zhouzhouyi@gmail.com>
> 
> iopte free should check wether input argument is NULL because kmem_cache_free
> will panic on NULL argument 
> 
> Signed-off-by: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
> Signed-off-by: Joerg Roedel <joro@8bytes.org>
> 
> ---
>  drivers/iommu/omap-iommu.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)

Applied, thanks.


