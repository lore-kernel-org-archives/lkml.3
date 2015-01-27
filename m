Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601AbbA0HOZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 02:14:25 -0500
Received: from galahad.ideasonboard.com ([185.26.127.97]:37009 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbbA0HOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 02:14:21 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: iommu@lists.linux-foundation.org, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will.deacon@arm.com>, Thierry Reding <treding@nvidia.com>,
        Varun Sethi <Varun.Sethi@freescale.com>, linux-kernel@vger.kernel.org,
        jroedel@suse.de
Subject: Re: [PATCH 0/4] iommu: Small fixes and cleanups
Date: Tue, 27 Jan 2015 09:14:59 +0200
Message-ID: <3395052.hcL4E8rFcL@avalon>
User-Agent: KMail/4.14.3 (Linux/3.17.7-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <1422316230-18893-1-git-send-email-joro@8bytes.org>
References: <1422316230-18893-1-git-send-email-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joerg,

Thank you for the patches.

On Tuesday 27 January 2015 00:50:26 Joerg Roedel wrote:
> Hi,
> 
> here are a couple of iommu fixes and cleanups to fix compile
> errors and some warnings on ARM and PPC.

For the whole series,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> Regards,
> 
> 	Joerg
> 
> Joerg Roedel (4):
>   iommu: Make more drivers depend on COMPILE_TEST
>   iommu/exynos: Make driver depend on REGULATOR
>   iommu/omap: Print phys_addr_t using %pa
>   iommu/fsl: Use %pa to print phys_addr_t
> 
>  drivers/iommu/Kconfig      | 11 +++++++----
>  drivers/iommu/fsl_pamu.c   |  4 ++--
>  drivers/iommu/omap-iommu.c |  2 +-
>  3 files changed, 10 insertions(+), 7 deletions(-)

-- 
Regards,

Laurent Pinchart

