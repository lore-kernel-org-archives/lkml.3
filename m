Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992Ab3LFAWG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 19:22:06 -0500
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:13442
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752003Ab3LFAWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 19:22:03 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -6
X-BigFish: VS-6(zz98dI9371I936eI542I1432Id799h4015Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275dh1de097hz2dh2a8h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h1155h)
Message-ID: <1386289316.7375.107.camel@snotra.buserror.net>
Subject: Re: [PATCH 0/9 v2] vfio-pci: add support for Freescale IOMMU (PAMU)
From: Scott Wood <scottwood@freescale.com>
To: Bharat Bhushan <Bharat.Bhushan@freescale.com>
CC: Alex Williamson <alex.williamson@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "agraf@suse.de" <agraf@suse.de>,
        Yoder Stuart-B08248 <stuart.yoder@freescale.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 5 Dec 2013 18:21:56 -0600
In-Reply-To: <6A3DF150A5B70D4F9B66A25E3F7C888D0723624C@039-SN2MPN1-012.039d.mgd.msft.net>
References: <1384838233-24847-1-git-send-email-Bharat.Bhushan@freescale.com>
	 <1384973243.2879.361.camel@ul30vt.home>
	 <6A3DF150A5B70D4F9B66A25E3F7C888D0721D9AC@039-SN2MPN1-012.039d.mgd.msft.net>
	 <1385066603.2879.414.camel@ul30vt.home>
	 <1385066835.1403.489.camel@snotra.buserror.net>
	 <1385067648.2879.421.camel@ul30vt.home>
	 <6A3DF150A5B70D4F9B66A25E3F7C888D0722C180@039-SN2MPN1-012.039d.mgd.msft.net>
	 <1385397493.2879.557.camel@ul30vt.home>
	  <6A3DF150A5B70D4F9B66A25E3F7C888D0723624C@039-SN2MPN1-012.039d.mgd.msft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-11-28 at 03:19 -0600, Bharat Bhushan wrote:
> 
> > -----Original Message-----
> > From: Bhushan Bharat-R65777
> > Sent: Wednesday, November 27, 2013 9:39 PM
> > To: 'Alex Williamson'
> > Cc: Wood Scott-B07421; linux-pci@vger.kernel.org; agraf@suse.de; Yoder Stuart-
> > B08248; iommu@lists.linux-foundation.org; bhelgaas@google.com; linuxppc-
> > dev@lists.ozlabs.org; linux-kernel@vger.kernel.org
> > Subject: RE: [PATCH 0/9 v2] vfio-pci: add support for Freescale IOMMU (PAMU)
> >
> >
> >
> > > -----Original Message-----
> > > From: Alex Williamson [mailto:alex.williamson@redhat.com]
> > > Sent: Monday, November 25, 2013 10:08 PM
> > > To: Bhushan Bharat-R65777
> > > Cc: Wood Scott-B07421; linux-pci@vger.kernel.org; agraf@suse.de; Yoder
> > > Stuart- B08248; iommu@lists.linux-foundation.org; bhelgaas@google.com;
> > > linuxppc- dev@lists.ozlabs.org; linux-kernel@vger.kernel.org
> > > Subject: Re: [PATCH 0/9 v2] vfio-pci: add support for Freescale IOMMU
> > > (PAMU)
> > >
> > > On Mon, 2013-11-25 at 05:33 +0000, Bharat Bhushan wrote:
> > > >
> > > > > -----Original Message-----
> > > > > From: Alex Williamson [mailto:alex.williamson@redhat.com]
> > > > > Sent: Friday, November 22, 2013 2:31 AM
> > > > > To: Wood Scott-B07421
> > > > > Cc: Bhushan Bharat-R65777; linux-pci@vger.kernel.org;
> > > > > agraf@suse.de; Yoder Stuart-B08248;
> > > > > iommu@lists.linux-foundation.org; bhelgaas@google.com; linuxppc-
> > > > > dev@lists.ozlabs.org; linux-kernel@vger.kernel.org
> > > > > Subject: Re: [PATCH 0/9 v2] vfio-pci: add support for Freescale
> > > > > IOMMU (PAMU)
> > > > >
> > > > > On Thu, 2013-11-21 at 14:47 -0600, Scott Wood wrote:
> > > > > > On Thu, 2013-11-21 at 13:43 -0700, Alex Williamson wrote:
> > > > > > > On Thu, 2013-11-21 at 11:20 +0000, Bharat Bhushan wrote:
> > > > > > > >
> > > > > > > > > -----Original Message-----
> > > > > > > > > From: Alex Williamson [mailto:alex.williamson@redhat.com]
> > > > > > > > > Sent: Thursday, November 21, 2013 12:17 AM
> > > > > > > > > To: Bhushan Bharat-R65777
> > > > > > > > > Cc: joro@8bytes.org; bhelgaas@google.com; agraf@suse.de;
> > > > > > > > > Wood Scott-B07421; Yoder Stuart-B08248;
> > > > > > > > > iommu@lists.linux-foundation.org; linux-
> > > > > > > > > pci@vger.kernel.org; linuxppc-dev@lists.ozlabs.org; linux-
> > > > > > > > > kernel@vger.kernel.org; Bhushan Bharat-R65777
> > > > > > > > > Subject: Re: [PATCH 0/9 v2] vfio-pci: add support for
> > > > > > > > > Freescale IOMMU (PAMU)
> > > > > > > > >
> > > > > > > > > Is VFIO_IOMMU_PAMU_GET_MSI_BANK_COUNT per aperture (ie.
> > > > > > > > > each vfio user has $COUNT regions at their disposal exclusively)?
> > > > > > > >
> > > > > > > > Number of msi-bank count is system wide and not per
> > > > > > > > aperture, But will be
> > > > > setting windows for banks in the device aperture.
> > > > > > > > So say if we are direct assigning 2 pci device (both have
> > > > > > > > different iommu
> > > > > group, so 2 aperture in iommu) to VM.
> > > > > > > > Now qemu can make only one call to know how many msi-banks
> > > > > > > > are there but
> > > > > it must set sub-windows for all banks for both pci device in its
> > > > > respective aperture.
> > > > > > >
> > > > > > > I'm still confused.  What I want to make sure of is that the
> > > > > > > banks are independent per aperture.  For instance, if we have
> > > > > > > two separate userspace processes operating independently and
> > > > > > > they both chose to use msi bank zero for their device, that's
> > > > > > > bank zero within each aperture and doesn't interfere.  Or
> > > > > > > another way to ask is can a malicious user interfere with
> > > > > > > other users by
> > > using the wrong bank.
> > > > > > > Thanks,
> > > > > >
> > > > > > They can interfere.
> > > >
> > > > Want to be sure of how they can interfere?
> > >
> > > What happens if more than one user selects the same MSI bank?
> > > Minimally, wouldn't that result in the IOMMU blocking transactions
> > > from the previous user once the new user activates their mapping?
> >
> > Yes and no; With current implementation yes but with a minor change no. Later in
> > this response I will explain how.
> >
> > >
> > > > >>  With this hardware, the only way to prevent that
> > > > > > is to make sure that a bank is not shared by multiple protection
> > contexts.
> > > > > > For some of our users, though, I believe preventing this is less
> > > > > > important than the performance benefit.
> > > >
> > > > So should we let this patch series in without protection?
> > >
> > > No.
> > >
> > > > >
> > > > > I think we need some sort of ownership model around the msi banks then.
> > > > > Otherwise there's nothing preventing another userspace from
> > > > > attempting an MSI based attack on other users, or perhaps even on
> > > > > the host.  VFIO can't allow that.  Thanks,
> > > >
> > > > We have very few (3 MSI bank on most of chips), so we can not assign
> > > > one to each userspace. What we can do is host and userspace does not
> > > > share a MSI bank while userspace will share a MSI bank.
> > >
> > > Then you probably need VFIO to "own" the MSI bank and program devices
> > > into it rather than exposing the MSI banks to userspace to let them have
> > direct access.
> >
> > Overall idea of exposing the details of msi regions to userspace are
> >  1) User space can define the aperture size to fit MSI mapping in IOMMU.
> >  2) setup iova for a MSI banks; which is just after guest memory.
> >
> > But currently we expose the "size" and "address" of MSI banks, passing address
> > is of no use and can be problematic.
> 
> I am sorry, above information is not correct. Currently neither we expose "address" nor "size" to user space. We only expose number of MSI BANK count and userspace adds one sub-window for each bank.
> 
> > If we just provide the size of MSI bank to userspace then userspace cannot do
> > anything wrong.
> 
> So userspace does not know address, so it cannot mmap and cause any interference by directly reading/writing.

That's security through obscurity...  Couldn't the malicious user find
out the address via other means, such as experimentation on another
system over which they have full control?  What would happen if the user
reads from their device's PCI config space?  Or gets the information via
some back door in the PCI device they own?  Or pokes throughout the
address space looking for something that generates an interrupt to its
own device?

-Scott



