Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759227Ab3LGAXR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 19:23:17 -0500
Received: from mail-db9lp0251.outbound.messaging.microsoft.com ([213.199.154.251]:20678
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753653Ab3LGAXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 19:23:15 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -6
X-BigFish: VS-6(zz98dI9371I936eI542I1432I4015Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275dh1de097hz2dh2a8h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h1155h)
Message-ID: <1386375778.7375.203.camel@snotra.buserror.net>
Subject: Re: [PATCH 0/9 v2] vfio-pci: add support for Freescale IOMMU (PAMU)
From: Scott Wood <scottwood@freescale.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "agraf@suse.de" <agraf@suse.de>,
        Yoder Stuart-B08248 <stuart.yoder@freescale.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 6 Dec 2013 18:22:58 -0600
In-Reply-To: <1386358226.25738.506.camel@ul30vt.home>
References: <1384838233-24847-1-git-send-email-Bharat.Bhushan@freescale.com>
	 <1384973243.2879.361.camel@ul30vt.home>
	 <6A3DF150A5B70D4F9B66A25E3F7C888D0721D9AC@039-SN2MPN1-012.039d.mgd.msft.net>
	 <1385066603.2879.414.camel@ul30vt.home>
	 <1385066835.1403.489.camel@snotra.buserror.net>
	 <1385067648.2879.421.camel@ul30vt.home>
	 <6A3DF150A5B70D4F9B66A25E3F7C888D0722C180@039-SN2MPN1-012.039d.mgd.msft.net>
	 <1385397493.2879.557.camel@ul30vt.home>
	 <6A3DF150A5B70D4F9B66A25E3F7C888D0723624C@039-SN2MPN1-012.039d.mgd.msft.net>
	 <1386289316.7375.107.camel@snotra.buserror.net>
	 <6A3DF150A5B70D4F9B66A25E3F7C888D07251EE4@039-SN2MPN1-012.039d.mgd.msft.net>
	 <1386356393.7375.118.camel@snotra.buserror.net>
	 <1386358226.25738.506.camel@ul30vt.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-12-06 at 12:30 -0700, Alex Williamson wrote:
> On Fri, 2013-12-06 at 12:59 -0600, Scott Wood wrote:
> > On Thu, 2013-12-05 at 22:11 -0600, Bharat Bhushan wrote:
> > > 
> > > > -----Original Message-----
> > > > From: Wood Scott-B07421
> > > > Sent: Friday, December 06, 2013 5:52 AM
> > > > To: Bhushan Bharat-R65777
> > > > Cc: Alex Williamson; linux-pci@vger.kernel.org; agraf@suse.de; Yoder Stuart-
> > > > B08248; iommu@lists.linux-foundation.org; bhelgaas@google.com; linuxppc-
> > > > dev@lists.ozlabs.org; linux-kernel@vger.kernel.org
> > > > Subject: Re: [PATCH 0/9 v2] vfio-pci: add support for Freescale IOMMU (PAMU)
> > > >
> > > > On Thu, 2013-11-28 at 03:19 -0600, Bharat Bhushan wrote:
> > > > >
> > > > > > -----Original Message-----
> > > > > > From: Bhushan Bharat-R65777
> > > > > > Sent: Wednesday, November 27, 2013 9:39 PM
> > > > > > To: 'Alex Williamson'
> > > > > > Cc: Wood Scott-B07421; linux-pci@vger.kernel.org; agraf@suse.de;
> > > > > > Yoder Stuart- B08248; iommu@lists.linux-foundation.org;
> > > > > > bhelgaas@google.com; linuxppc- dev@lists.ozlabs.org;
> > > > > > linux-kernel@vger.kernel.org
> > > > > > Subject: RE: [PATCH 0/9 v2] vfio-pci: add support for Freescale
> > > > > > IOMMU (PAMU)
> > > > > >
> > > > > > If we just provide the size of MSI bank to userspace then userspace
> > > > > > cannot do anything wrong.
> > > > >
> > > > > So userspace does not know address, so it cannot mmap and cause any
> > > > interference by directly reading/writing.
> > > >
> > > > That's security through obscurity...  Couldn't the malicious user find out the
> > > > address via other means, such as experimentation on another system over which
> > > > they have full control?  What would happen if the user reads from their device's
> > > > PCI config space?  Or gets the information via some back door in the PCI device
> > > > they own?  Or pokes throughout the address space looking for something that
> > > > generates an interrupt to its own device?
> > > 
> > > So how to solve this problem, Any suggestion ?
> > > 
> > > We have to map one window in PAMU for MSIs and a malicious user can ask
> > > its device to do DMA to MSI window region with any pair of address and
> > > data, which can lead to unexpected MSIs in system?
> > 
> > I don't think there are any solutions other than to limit each bank to
> > one user, unless the admin turns some knob that says they're OK with the
> > partial loss of isolation.
> 
> Even if the admin does opt-in to an allow_unsafe_interrupts options, it
> should still be reasonably difficult for one guest to interfere with the
> other.  I don't think we want to rely on the blind luck of making the
> full MSI bank accessible to multiple guests and hoping they don't step
> on each other.  That probably means that vfio needs to manage the space
> rather than the guest.  Thanks,

Yes, the MSIs within a given bank would be allocated by the host kernel
in any case (presumably by the MSI driver, not VFIO itself).  This is
just about what happens if the MSI page is written to outside of the
normal mechanism.

-Scott



