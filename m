Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751235AbaJPDvV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 23:51:21 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:34031 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbaJPDvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 23:51:19 -0400
MIME-Version: 1.0
In-Reply-To: <CA+QbAV6-C9wxPttEx0uDn_K5Y1LaGt8pxDWc8RJmN4DqR+NHtQ@mail.gmail.com>
References: <CA+QbAV6-C9wxPttEx0uDn_K5Y1LaGt8pxDWc8RJmN4DqR+NHtQ@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 15 Oct 2014 21:50:58 -0600
Message-ID: <CAErSpo5YXZ8YRzhg0xvbHGCr22o+_+yi7HrCCBYBM9Ke42okJQ@mail.gmail.com>
Subject: Re: PCIe PASID (Process Address Space ID) and iommu code
To: Kallol Biswas <nucleodyne@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux-foundation.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Jay Cornwall <jay.cornwall@amd.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Joerg, Suravee, Jay, iommu list, linux-pci]

On Wed, Oct 15, 2014 at 5:44 PM, Kallol Biswas <nucleodyne@gmail.com> wrote:
> Resending, as message got bounced for html content.
> --------------------------------------------
> Hi,
>     PCIe has introduced PASID TLP Prefix.  There are two ECNs on this.
>
> It seems that AMD iommu code makes use of PASID. Is there a device that
> utilizes this TLP prefix?
>
> PASID allocation and management within a device is not clear to me. How
> does device know which PASID to issue for which virtual address? Who makes
> the association? Must be software/OS, but how? There is no table for this
> like MSI-X table.
>
> Any pointer/documentation will be appreciated.
>
> Regards,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
