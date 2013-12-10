Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840Ab3LJJKA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 04:10:00 -0500
Received: from mail-bn1lp0155.outbound.protection.outlook.com ([207.46.163.155]:35395
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765Ab3LJJJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 04:09:54 -0500
From: "Bharat.Bhushan@freescale.com" <Bharat.Bhushan@freescale.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: Scott Wood <scottwood@freescale.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "agraf@suse.de" <agraf@suse.de>,
        Stuart Yoder <stuart.yoder@freescale.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/9 v2] vfio-pci: add support for Freescale IOMMU (PAMU)
Thread-Topic: [PATCH 0/9 v2] vfio-pci: add support for Freescale IOMMU (PAMU)
Thread-Index: AQHO5OdyKeXB/EytyUeVGr+Ok97IOJoueBeAgAENqwCAAKUSgIAAARWAgAADyQCABUQ/0IAAu7eAgAMaEYCAAR6mUIAMACkAgAA/BTCAAPlVgIAACIkAgAVR/pCAABMKAIAAF2Dw
Date: Tue, 10 Dec 2013 09:09:48 +0000
Message-ID: <182cddd6c4cd4d01a216d468e784fe5d@BN1PR03MB266.namprd03.prod.outlook.com>
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
	 <326a93628a9141a9abce97b7bb4e04fd@BN1PR03MB266.namprd03.prod.outlook.com>
 <1386654800.22974.2.camel@ul30vt.home>
In-Reply-To: <1386654800.22974.2.camel@ul30vt.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.169.1]
x-forefront-prvs: 005671E15D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(164054003)(13464003)(24454002)(199002)(189002)(377424004)(51704005)(377454003)(90146001)(74316001)(87266001)(2656002)(4396001)(69226001)(87936001)(80976001)(56776001)(65816001)(81816001)(66066001)(63696002)(56816005)(83072002)(85852003)(81686001)(80022001)(33646001)(49866001)(85306002)(47976001)(47446002)(76796001)(77096001)(74502001)(54356001)(74662001)(19580405001)(19580395003)(31966008)(74876001)(76786001)(83322001)(81542001)(53806001)(81342001)(76576001)(59766001)(54316002)(74706001)(77982001)(50986001)(79102001)(51856001)(47736001)(76482001)(46102001)(74366001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB347;H:BN1PR03MB266.namprd03.prod.outlook.com;CLIP:192.88.169.1;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBA9A8nm013704



> -----Original Message-----
> From: Alex Williamson [mailto:alex.williamson@redhat.com]
> Sent: Tuesday, December 10, 2013 11:23 AM
> To: Bhushan Bharat-R65777
> Cc: Wood Scott-B07421; linux-pci@vger.kernel.org; agraf@suse.de; Yoder Stuart-
> B08248; iommu@lists.linux-foundation.org; bhelgaas@google.com; linuxppc-
> dev@lists.ozlabs.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 0/9 v2] vfio-pci: add support for Freescale IOMMU (PAMU)
> 
> On Tue, 2013-12-10 at 05:37 +0000, Bharat.Bhushan@freescale.com wrote:
> >
> > > -----Original Message-----
> > > From: Alex Williamson [mailto:alex.williamson@redhat.com]
> > > Sent: Saturday, December 07, 2013 1:00 AM
> > > To: Wood Scott-B07421
> > > Cc: Bhushan Bharat-R65777; linux-pci@vger.kernel.org; agraf@suse.de;
> > > Yoder Stuart-B08248; iommu@lists.linux-foundation.org;
> > > bhelgaas@google.com; linuxppc- dev@lists.ozlabs.org;
> > > linux-kernel@vger.kernel.org
> > > Subject: Re: [PATCH 0/9 v2] vfio-pci: add support for Freescale
> > > IOMMU (PAMU)
> > >
> > > On Fri, 2013-12-06 at 12:59 -0600, Scott Wood wrote:
> > > > On Thu, 2013-12-05 at 22:11 -0600, Bharat Bhushan wrote:
> > > > >
> > > > > > -----Original Message-----
> > > > > > From: Wood Scott-B07421
> > > > > > Sent: Friday, December 06, 2013 5:52 AM
> > > > > > To: Bhushan Bharat-R65777
> > > > > > Cc: Alex Williamson; linux-pci@vger.kernel.org; agraf@suse.de;
> > > > > > Yoder Stuart- B08248; iommu@lists.linux-foundation.org;
> > > > > > bhelgaas@google.com; linuxppc- dev@lists.ozlabs.org;
> > > > > > linux-kernel@vger.kernel.org
> > > > > > Subject: Re: [PATCH 0/9 v2] vfio-pci: add support for
> > > > > > Freescale IOMMU (PAMU)
> > > > > >
> > > > > > On Thu, 2013-11-28 at 03:19 -0600, Bharat Bhushan wrote:
> > > > > > >
> > > > > > > > -----Original Message-----
> > > > > > > > From: Bhushan Bharat-R65777
> > > > > > > > Sent: Wednesday, November 27, 2013 9:39 PM
> > > > > > > > To: 'Alex Williamson'
> > > > > > > > Cc: Wood Scott-B07421; linux-pci@vger.kernel.org;
> > > > > > > > agraf@suse.de; Yoder Stuart- B08248;
> > > > > > > > iommu@lists.linux-foundation.org; bhelgaas@google.com;
> > > > > > > > linuxppc- dev@lists.ozlabs.org;
> > > > > > > > linux-kernel@vger.kernel.org
> > > > > > > > Subject: RE: [PATCH 0/9 v2] vfio-pci: add support for
> > > > > > > > Freescale IOMMU (PAMU)
> > > > > > > >
> > > > > > > > If we just provide the size of MSI bank to userspace then
> > > > > > > > userspace cannot do anything wrong.
> > > > > > >
> > > > > > > So userspace does not know address, so it cannot mmap and
> > > > > > > cause any
> > > > > > interference by directly reading/writing.
> > > > > >
> > > > > > That's security through obscurity...  Couldn't the malicious
> > > > > > user find out the address via other means, such as
> > > > > > experimentation on another system over which they have full
> > > > > > control?  What would happen if the user reads from their
> > > > > > device's PCI config space?  Or gets the information via some
> > > > > > back door in the PCI device they own?  Or pokes throughout the
> > > > > > address space looking for something that
> > > generates an interrupt to its own device?
> > > > >
> > > > > So how to solve this problem, Any suggestion ?
> > > > >
> > > > > We have to map one window in PAMU for MSIs and a malicious user
> > > > > can ask its device to do DMA to MSI window region with any pair
> > > > > of address and data, which can lead to unexpected MSIs in system?
> > > >
> > > > I don't think there are any solutions other than to limit each
> > > > bank to one user, unless the admin turns some knob that says
> > > > they're OK with the partial loss of isolation.
> > >
> > > Even if the admin does opt-in to an allow_unsafe_interrupts options,
> > > it should still be reasonably difficult for one guest to interfere
> > > with the other.  I don't think we want to rely on the blind luck of
> > > making the full MSI bank accessible to multiple guests and hoping they don't
> step on each other.
> >
> > Not sure how to solve in this case (sharing MSI page)
> >
> > >  That probably means that vfio needs to manage the space rather than the
> guest.
> >
> > What you mean by " vfio needs to manage the space rather than the guest"?
> 
> I mean there needs to be some kernel component managing the contents of the MSI
> page rather than just handing it out to the user and hoping for the best.  The
> user API also needs to remain the same whether the user has the MSI page
> exclusively or it's shared with others (kernel or users).  Thanks,

We have limited number of MSI banks, so we cannot provide explicit MSI bank to each VMs.
Below is the summary of msi allocation/ownership model I am thinking of:

Option-1: User-space aware of MSI banks
========= 
1 ) Userspace will make GET_MSI_REGION(request number of MSI banks)
	- VFIO will allocate requested number of MSI bank;
	- If allocation succeed then return number of banks
	- If allocation fails then check opt-in flag set by administrator (allow_unsafe_interrupts);
         allow_unsafe_interrupts  == 0; Not allowed to share; return FAIL (-ENODEV)
         else share MSI bank of another VM.

2) Userspace will adjust geometry size as per number of banks and calls SET_GEOMETRY

3) Userspace will do DMA_MAP for its memory

4) Userspace will do MSI_MAP for number of banks it have
	- MSI_MAP(iova, bank number);
	- Should iova be passed by userspace or not? I think we should pass iova as it does not know if userspace will call DMA_MAP for same iova later on.
	  VFIO can somehow find a magic IOVA within geometry but will assume that userspace will not make DMA_MAP later on.
	

Option-2: Userspace transparent MSI banks
========= 
1) Userspace setup geometry of its memory (say call as "userspace-geometry") (SET_GEOMETRY)
	- VFIO will allocate MSI bank/s; how many??.
	- Error out if not available (shared and/or exclusive, same as in option-1 above)
	- VFIO will adjust geometry accordingly (say called as "actual-geometry").

2) Userspace will do DMA_MAP for its memory.
	- VFIO allows only within "userspace-geometry".

3) Userspace will do MSI_MAP after all DMA_MAP complete
	- VFIO will find a magic IOVA after "userspace-geometry" but within "actual-geometry".
	- Allocated MSI bank/s in step-1 are mapped in IOMMU

=========

Note: Irrespective of which option we use, a malicious userspace can interfere with another userspace by programming device DMA wrongly.

Option-1 looks flexible and good to me but open for suggestions.

Thanks
-Bharat


> 
> Alex
> 
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
