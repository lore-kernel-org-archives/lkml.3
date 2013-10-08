Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745Ab3JHQsN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 12:48:13 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:63166 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755385Ab3JHQsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 12:48:10 -0400
MIME-Version: 1.0
In-Reply-To: <6A3DF150A5B70D4F9B66A25E3F7C888D0718FA58@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1379575763-2091-1-git-send-email-Bharat.Bhushan@freescale.com>
 <1379575763-2091-2-git-send-email-Bharat.Bhushan@freescale.com>
 <20130924235812.GD9302@google.com> <6A3DF150A5B70D4F9B66A25E3F7C888D0718FA58@039-SN2MPN1-011.039d.mgd.msft.net>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 8 Oct 2013 10:47:49 -0600
Message-ID: <CAErSpo742BOxzxRaFQn+UnsNday4_8LM6+3G6=cfp9DHecPxDg@mail.gmail.com>
Subject: Re: [PATCH 1/7] powerpc: Add interface to get msi region information
To: Bhushan Bharat-R65777 <R65777@freescale.com>
Cc: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "agraf@suse.de" <agraf@suse.de>,
        Wood Scott-B07421 <B07421@freescale.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 3, 2013 at 11:19 PM, Bhushan Bharat-R65777
<R65777@freescale.com> wrote:

>> I don't know enough about VFIO to understand why these new interfaces are
>> needed.  Is this the first VFIO IOMMU driver?  I see vfio_iommu_spapr_tce.c and
>> vfio_iommu_type1.c but I don't know if they're comparable to the Freescale PAMU.
>> Do other VFIO IOMMU implementations support MSI?  If so, do they handle the
>> problem of mapping the MSI regions in a different way?
>
> PAMU is an aperture type of IOMMU while other are paging type, So they are completely different from what PAMU is and handle that differently.

This is not an explanation or a justification for adding new
interfaces.  I still have no idea what an "aperture type IOMMU" is,
other than that it is "different."  But I see that Alex is working on
this issue with you in a different thread, so I'm sure you guys will
sort it out.

Bjorn
