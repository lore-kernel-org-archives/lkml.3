Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980AbaJVOaZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 10:30:25 -0400
Received: from 8bytes.org ([81.169.241.247]:36662 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386AbaJVOaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 10:30:23 -0400
Date: Wed, 22 Oct 2014 16:30:21 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Kiran Padwal <kiran.padwal@smartplayin.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] iommu: use dev_get_platdata()
Message-ID: <20141022143021.GI10074@8bytes.org>
References: <1412947870-10033-1-git-send-email-kiran.padwal@smartplayin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412947870-10033-1-git-send-email-kiran.padwal@smartplayin.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 07:01:10PM +0530, Kiran Padwal wrote:
> Use the wrapper function for retrieving the platform data instead of
> accessing dev->platform_data directly.
> 
> Signed-off-by: Kiran Padwal <kiran.padwal@smartplayin.com>
> ---
>  drivers/iommu/msm_iommu_dev.c |    4 ++--
>  drivers/iommu/omap-iommu.c    |    6 +++---
>  2 files changed, 5 insertions(+), 5 deletions(-)

This touches 2 drivers, can you please split it up into per-driver
patches?

Thanks,

	Joerg

