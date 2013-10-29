Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab3J2Edb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 00:33:31 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33468 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750971Ab3J2Ed1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 00:33:27 -0400
Date: Tue, 29 Oct 2013 04:32:41 +0000
From: Will Deacon <will.deacon@arm.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Antonios Motakis <a.motakis@virtualopensystems.com>,
        Joerg Roedel <joro@8bytes.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:IOMMU DRIVERS" <iommu@lists.linux-foundation.org>,
        "tech@virtualopensystems.com" <tech@virtualopensystems.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "moderated list:ARM SMMU DRIVER" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2] ARM: SMMU: add devices attached to the SMMU to an
 IOMMU group
Message-ID: <20131029043240.GE22291@mudshark.cambridge.arm.com>
References: <1382108910-18049-1-git-send-email-a.motakis@virtualopensystems.com>
 <1382978662.4097.35.camel@ul30vt.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382978662.4097.35.camel@ul30vt.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 04:44:22PM +0000, Alex Williamson wrote:
> On Fri, 2013-10-18 at 17:08 +0200, Antonios Motakis wrote:
> > IOMMU groups are expected by certain users of the IOMMU API,
> > e.g. VFIO. Add new devices found by the SMMU driver to an IOMMU
> > group to satisfy those users.
> > 
> > Changes from v1:
> >  * Added check that dev->archdata.iommu has not been set already by an IOMMU
> >    driver. This way we can also skip checking for an existing IOMMU group.
> > 
> > Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> 
> 
> Looks ok to me.
> 
> Acked-by: Alex Williamson <alex.williamson@redhat.com>

Yup, looks fine to me too. I'm travelling until next week, so I'll start
picking things up then.

Cheers,

Will
