Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350AbaIYOBZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 10:01:25 -0400
Received: from 8bytes.org ([81.169.241.247]:57752 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872AbaIYOBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 10:01:24 -0400
Date: Thu, 25 Sep 2014 16:01:20 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Kiran Padwal <kiran.padwal@smartplayin.com>
Cc: will.deacon@arm.com, hdoyu@nvidia.com, swarren@wwwdotorg.org,
        thierry.reding@gmail.com, linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH] iommu: Make of_device_id array const
Message-ID: <20140925140120.GA8306@8bytes.org>
References: <1410442656-21112-1-git-send-email-kiran.padwal@smartplayin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410442656-21112-1-git-send-email-kiran.padwal@smartplayin.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 07:07:36PM +0530, Kiran Padwal wrote:
> Make of_device_id array const, because all OF functions handle it as const.
> 
> Signed-off-by: Kiran Padwal <kiran.padwal@smartplayin.com>
> ---
>  drivers/iommu/arm-smmu.c   |    2 +-
>  drivers/iommu/omap-iommu.c |    2 +-
>  drivers/iommu/tegra-gart.c |    2 +-
>  drivers/iommu/tegra-smmu.c |    2 +-
>  4 files changed, 4 insertions(+), 4 deletions(-)

Applied, thanks.

