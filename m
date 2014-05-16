Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932515AbaEPO4M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 10:56:12 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:48284 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932289AbaEPO4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 10:56:09 -0400
Date: Fri, 16 May 2014 10:55:48 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>,
        kim.phillips@linaro.org, linux-pci@vger.kernel.org,
        stuart.yoder@freescale.com, agraf@suse.de, libvir-list@redhat.com,
        iommu@lists.linux-foundation.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>, tech@virtualopensystems.com,
        kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
Subject: Re: [PATCH v2] PCI: Introduce new device binding path using
 pci_dev.driver_override
Message-ID: <20140516145548.GA4199@phenom.dumpdata.com>
References: <20140509164326.12141.44591.stgit@bling.home>
 <CACJDEmp+whOkOZ5pVn4qqNBqXJc5Nb=1m-DmxPzFUZNxEyG6gQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACJDEmp+whOkOZ5pVn4qqNBqXJc5Nb=1m-DmxPzFUZNxEyG6gQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 10:48:00AM -0400, Konrad Rzeszutek Wilk wrote:
> On Fri, May 9, 2014 at 12:50 PM, Alex Williamson <alex.williamson@redhat.com
> > wrote:
> 
> > The driver_override field allows us to specify the driver for a device
> > ...
> >
> ...
> 
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >
> 
> Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

And somehow my emailer (Google) decided to add yucky HTML crud
to the end.

So here is an nice plain email so that it can go the the right
mailing lists - and sorry for the extra emails to those on the
'To' and 'CC'!
> _______________________________________________
> iommu mailing list
> iommu@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/iommu

