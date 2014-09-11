Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbaIKNwM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:52:12 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:52936 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751166AbaIKNwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 09:52:10 -0400
Date: Thu, 11 Sep 2014 14:51:19 +0100
From: Will Deacon <will.deacon@arm.com>
To: Kiran Padwal <kiran.padwal@smartplayin.com>
Cc: "joro@8bytes.org" <joro@8bytes.org>, "hdoyu@nvidia.com" <hdoyu@nvidia.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] iommu: Make of_device_id array const
Message-ID: <20140911135119.GH6158@arm.com>
References: <1410442656-21112-1-git-send-email-kiran.padwal@smartplayin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410442656-21112-1-git-send-email-kiran.padwal@smartplayin.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 02:37:36PM +0100, Kiran Padwal wrote:
> Make of_device_id array const, because all OF functions handle it as const.
> 
> Signed-off-by: Kiran Padwal <kiran.padwal@smartplayin.com>
> ---
>  drivers/iommu/arm-smmu.c   |    2 +-
>  drivers/iommu/omap-iommu.c |    2 +-
>  drivers/iommu/tegra-gart.c |    2 +-
>  drivers/iommu/tegra-smmu.c |    2 +-
>  4 files changed, 4 insertions(+), 4 deletions(-)

Ha, I've seen a few of these patches recently. Did some tool just get
support for detecting this?

Anyway, looks fine and should probably go via Joerg.

Will
