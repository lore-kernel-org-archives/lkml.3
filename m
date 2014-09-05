Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932682AbaIEOET (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 10:04:19 -0400
Received: from 8bytes.org ([81.169.241.247]:39024 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932147AbaIEOES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 10:04:18 -0400
Date: Fri, 5 Sep 2014 16:04:15 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Varun Sethi <Varun.Sethi@freescale.com>
Cc: iommu@lists.linux-foundation.org, alex.williamson@redhat.com,
        Emilian.Medve@freescale.com, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] iommu/fsl: Fix warning resulting from adding PCI
 device twice
Message-ID: <20140905140414.GA11931@8bytes.org>
References: <1409830725-4469-1-git-send-email-Varun.Sethi@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409830725-4469-1-git-send-email-Varun.Sethi@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 05:08:45PM +0530, Varun Sethi wrote:
> iommu_group_get_for_dev determines the iommu group for the PCI device and adds
> the device to the group.
> 
> In the PAMU driver we were again adding the device to the same group without checking
> if the device already had an iommu group. This resulted in the following warning.
>
> [...]
> 
> Signed-off-by: Varun Sethi <Varun.Sethi@freescale.com>
> ---
> v2 changes
> - directly check for the device iommu_group
> 
>  drivers/iommu/fsl_pamu_domain.c |   10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)

Applied to iommu/fixes and added stable tag, thanks.

