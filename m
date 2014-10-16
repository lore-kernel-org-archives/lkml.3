Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544AbaJPJOj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 05:14:39 -0400
Received: from 8bytes.org ([81.169.241.247]:34081 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476AbaJPJOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 05:14:35 -0400
Date: Thu, 16 Oct 2014 11:14:33 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Kallol Biswas <nucleodyne@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux-foundation.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Jay Cornwall <jay.cornwall@amd.com>
Subject: Re: PCIe PASID (Process Address Space ID) and iommu code
Message-ID: <20141016091433.GI28786@8bytes.org>
References: <CA+QbAV6-C9wxPttEx0uDn_K5Y1LaGt8pxDWc8RJmN4DqR+NHtQ@mail.gmail.com>
 <CAErSpo5YXZ8YRzhg0xvbHGCr22o+_+yi7HrCCBYBM9Ke42okJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo5YXZ8YRzhg0xvbHGCr22o+_+yi7HrCCBYBM9Ke42okJQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 09:50:58PM -0600, Bjorn Helgaas wrote:
> [+cc Joerg, Suravee, Jay, iommu list, linux-pci]
> 
> On Wed, Oct 15, 2014 at 5:44 PM, Kallol Biswas <nucleodyne@gmail.com> wrote:
> > Resending, as message got bounced for html content.
> > --------------------------------------------
> > Hi,
> >     PCIe has introduced PASID TLP Prefix.  There are two ECNs on this.
> >
> > It seems that AMD iommu code makes use of PASID. Is there a device that
> > utilizes this TLP prefix?

Yes, recent radeon GPUs can make use of the TLP prefix.

> > PASID allocation and management within a device is not clear to me. How
> > does device know which PASID to issue for which virtual address? Who makes
> > the association? Must be software/OS, but how? There is no table for this
> > like MSI-X table.

The setup of the PASIDs is device specific, so there is no standard for
setting up PASID address spaces on devices.


HTH,

	Joerg

