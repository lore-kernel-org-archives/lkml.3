Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758227AbaGDKiE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 06:38:04 -0400
Received: from 8bytes.org ([85.214.48.195]:42301 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757757AbaGDKiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 06:38:00 -0400
Date: Fri, 4 Jul 2014 12:37:57 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: iommu@lists.linux-foundation.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] iommu: Expose IOMMU information in sysfs
Message-ID: <20140704103757.GB13434@8bytes.org>
References: <20140612215954.2754.30263.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140612215954.2754.30263.stgit@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Fri Jul  4 12:37:58 2014
X-DSPAM-Confidence: 0.9985
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 53b6840620869759881464
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 04:12:18PM -0600, Alex Williamson wrote:
> Alex Williamson (3):
>       iommu: Add sysfs support for IOMMUs
>       iommu/intel: Make use of IOMMU sysfs support
>       iommu/amd: Add sysfs support
> 
> 
>  Documentation/ABI/testing/sysfs-class-iommu        |   17 +++
>  .../ABI/testing/sysfs-class-iommu-amd-iommu        |   14 ++
>  .../ABI/testing/sysfs-class-iommu-intel-iommu      |   32 +++++
>  drivers/iommu/Makefile                             |    1 
>  drivers/iommu/amd_iommu.c                          |    6 +
>  drivers/iommu/amd_iommu_init.c                     |   38 ++++++
>  drivers/iommu/amd_iommu_types.h                    |    3 
>  drivers/iommu/dmar.c                               |    9 +
>  drivers/iommu/intel-iommu.c                        |   77 +++++++++++-
>  drivers/iommu/iommu-sysfs.c                        |  133 ++++++++++++++++++++
>  include/linux/intel-iommu.h                        |    3 
>  include/linux/iommu.h                              |   26 ++++
>  12 files changed, 358 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-class-iommu
>  create mode 100644 Documentation/ABI/testing/sysfs-class-iommu-amd-iommu
>  create mode 100644 Documentation/ABI/testing/sysfs-class-iommu-intel-iommu
>  create mode 100644 drivers/iommu/iommu-sysfs.c

Also applied to the core branch, thanks Alex.


