Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934032AbaFRH4m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 03:56:42 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:54992 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933338AbaFRH4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 03:56:25 -0400
Message-ID: <53A14623.4080900@ozlabs.ru>
Date: Wed, 18 Jun 2014 17:56:19 +1000
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: linuxppc-dev@lists.ozlabs.org, Paul Mackerras <paulus@samba.org>,
        Alistair Popple <alistair@popple.id.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] powerpc/powernv: Applying it_page_shift to platform
 code
References: <1402044246-13650-1-git-send-email-aik@ozlabs.ru>
In-Reply-To: <1402044246-13650-1-git-send-email-aik@ozlabs.ru>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2014 06:44 PM, Alexey Kardashevskiy wrote:
> Here is what I got for powernv in order to support variable page size
> in iommu_table.
> 
> I am very uncertain about Patch #4 "Add @it_owner to iommu_table struct"
> and wonder if there any better way to get PE from iommu_table.
> 
> Please comment. Thanks.


Ben, these patches are really simple :)


> 
> 
> Alexey Kardashevskiy (6):
>   powerpc/powernv: use it_page_shift for TCE invalidation
>   powerpc/powernv: use it_page_shift in TCE build
>   powerpc/powernv: Add a page size parameter to
>     pnv_pci_setup_iommu_table()
>   powerpc/powernv: Add @it_owner to iommu_table struct
>   powerpc/powernv: Make set_bypass() callback a type
>   powerpc/powernv: Make invalidate() callback an iommu_table callback
> 
>  arch/powerpc/include/asm/iommu.h            | 13 ++++++-
>  arch/powerpc/platforms/powernv/pci-ioda.c   | 55 ++++++++++++++---------------
>  arch/powerpc/platforms/powernv/pci-p5ioc2.c |  3 +-
>  arch/powerpc/platforms/powernv/pci.c        | 43 +++++++++++++++-------
>  arch/powerpc/platforms/powernv/pci.h        |  7 ++--
>  5 files changed, 74 insertions(+), 47 deletions(-)
> 


-- 
Alexey
