Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513AbaKFNlU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 08:41:20 -0500
Received: from 8bytes.org ([81.169.241.247]:49596 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288AbaKFNlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 08:41:07 -0500
Date: Thu, 6 Nov 2014 14:41:05 +0100
From: Joerg Roedel <joro@8bytes.org>
To: "Li, Zhen-Hua" <zhen-hual@hp.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org
Subject: Re: [PATCH 1/1] x86/iommu: fix incorrect bit operations in setting
 values
Message-ID: <20141106134105.GQ10744@8bytes.org>
References: <1415172619-4801-1-git-send-email-zhen-hual@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415172619-4801-1-git-send-email-zhen-hual@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 03:30:19PM +0800, Li, Zhen-Hua wrote:
> Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>
> ---
>  drivers/iommu/intel-iommu.c | 2 ++
>  1 file changed, 2 insertions(+)

Applied, thanks Li.
