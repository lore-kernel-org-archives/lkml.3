Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936834Ab3DJQGF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 12:06:05 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:49121 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756368Ab3DJQGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 12:06:04 -0400
MIME-Version: 1.0
In-Reply-To: <1365538384-12426-1-git-send-email-joro@8bytes.org>
References: <1365538384-12426-1-git-send-email-joro@8bytes.org>
Date: Wed, 10 Apr 2013 10:06:02 -0600
Message-ID: <CAKocOOP5tMsDLS8Wotu0kMNjSVJpN+pPhE9zj+n9ZKS9EcVR+A@mail.gmail.com>
Subject: Re: [PATCH 0/9] AMD IOMMU cleanups, fixes and IVRS bug workarounds
From: Shuah Khan <shuahkhan@gmail.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 9, 2013 at 2:12 PM, Joerg Roedel <joro@8bytes.org> wrote:
> Hi,
>
> this patch-set contains some cleanups and patches for the
> AMD IOMM driver. The most important part is a workaround
> that can be used to get interrupt remapping working even the
> the IVRS table provided by the BIOS is broken.
>
>
>         Joerg
>
> Joerg Roedel (9):
>   iommu/amd: Remove map_sg_no_iommu()
>   iommu/amd: Use AMD specific data structure for irq remapping
>   iommu/amd: Properly initialize irq-table lock
>   iommu/amd: Move add_special_device() to __init
>   iommu/amd: Extend IVRS special device data structure
>   iommu/amd: Add early maps for ioapic and hpet
>   iommu/amd: Add ioapic and hpet ivrs override
>   iommu/amd: Don't report firmware bugs with cmd-line ivrs overrides
>   iommu/amd: Document ivrs_ioapic and ivrs_hpet parameters
>
>  Documentation/kernel-parameters.txt |   14 ++++
>  drivers/iommu/amd_iommu.c           |   79 +++++++-----------
>  drivers/iommu/amd_iommu_init.c      |  151 +++++++++++++++++++++++++++++++----
>  drivers/iommu/amd_iommu_types.h     |    1 +
>  4 files changed, 182 insertions(+), 63 deletions(-)
>

Joerg,

Reviewed all the patches in this set. No longer have access to test machine. :(

Reviewed-by: Shuah Khan <shuahkhan@gmail.com>

-- Shuah
