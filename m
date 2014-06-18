Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966487AbaFRNHf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 09:07:35 -0400
Received: from gate.crashing.org ([63.228.1.57]:48197 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966317AbaFRNHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 09:07:34 -0400
Message-ID: <1403096820.7661.210.camel@pasglop>
Subject: Re: [PATCH 0/6] powerpc/powernv: Applying it_page_shift to platform
 code
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: linuxppc-dev@lists.ozlabs.org, Paul Mackerras <paulus@samba.org>,
        Alistair Popple <alistair@popple.id.au>, linux-kernel@vger.kernel.org
Date: Wed, 18 Jun 2014 23:07:00 +1000
In-Reply-To: <53A14623.4080900@ozlabs.ru>
References: <1402044246-13650-1-git-send-email-aik@ozlabs.ru>
	 <53A14623.4080900@ozlabs.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-18 at 17:56 +1000, Alexey Kardashevskiy wrote:
> On 06/06/2014 06:44 PM, Alexey Kardashevskiy wrote:
> > Here is what I got for powernv in order to support variable page size
> > in iommu_table.
> > 
> > I am very uncertain about Patch #4 "Add @it_owner to iommu_table struct"
> > and wonder if there any better way to get PE from iommu_table.
> > 
> > Please comment. Thanks.
> 
> 
> Ben, these patches are really simple :)

Sure, they also arrived in the middle of the merge window, so they
can surely wait a bit longer.

Cheers,
Ben.

> 
> > 
> > 
> > Alexey Kardashevskiy (6):
> >   powerpc/powernv: use it_page_shift for TCE invalidation
> >   powerpc/powernv: use it_page_shift in TCE build
> >   powerpc/powernv: Add a page size parameter to
> >     pnv_pci_setup_iommu_table()
> >   powerpc/powernv: Add @it_owner to iommu_table struct
> >   powerpc/powernv: Make set_bypass() callback a type
> >   powerpc/powernv: Make invalidate() callback an iommu_table callback
> > 
> >  arch/powerpc/include/asm/iommu.h            | 13 ++++++-
> >  arch/powerpc/platforms/powernv/pci-ioda.c   | 55 ++++++++++++++---------------
> >  arch/powerpc/platforms/powernv/pci-p5ioc2.c |  3 +-
> >  arch/powerpc/platforms/powernv/pci.c        | 43 +++++++++++++++-------
> >  arch/powerpc/platforms/powernv/pci.h        |  7 ++--
> >  5 files changed, 74 insertions(+), 47 deletions(-)
> > 
> 
> 


