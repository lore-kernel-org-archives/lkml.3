Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010AbaG2PoD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 11:44:03 -0400
Received: from 8bytes.org ([81.169.241.247]:52133 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbaG2PoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 11:44:01 -0400
Date: Tue, 29 Jul 2014 17:43:55 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Tushar Behera <tushar.b@samsung.com>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        trblinux@gmail.com, pullip.cho@samsung.com, shaik.ameer@samsung.com
Subject: Re: [PATCH] iommu/exynos: Select ARM_DMA_USE_IOMMU
Message-ID: <20140729154354.GA27589@8bytes.org>
References: <1404466268-9512-1-git-send-email-tushar.b@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404466268-9512-1-git-send-email-tushar.b@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2014 at 03:01:08PM +0530, Tushar Behera wrote:
> For IOMMU to use on Exynos platforms, we need to enable ARM_DMA_USE_IOMMU. It
> would be better to select it by default when EXYNOS_IOMMU is enabled.
> 
> Signed-off-by: Tushar Behera <tushar.b@samsung.com>

Applied, thanks. Please always Cc me directly on IOMMU patches.

