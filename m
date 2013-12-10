Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667Ab3LJFyw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 00:54:52 -0500
Received: from [207.46.163.242] ([207.46.163.242]:3019 "EHLO
	na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750992Ab3LJFyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 00:54:50 -0500
From: "Bharat.Bhushan@freescale.com" <Bharat.Bhushan@freescale.com>
To: Alex Williamson <alex.williamson@redhat.com>,
        Scott Wood <scottwood@freescale.com>
CC: "Bharat.Bhushan@freescale.com" <Bharat.Bhushan@freescale.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "agraf@suse.de" <agraf@suse.de>,
        Stuart Yoder <stuart.yoder@freescale.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/9 v2] vfio-pci: add support for Freescale IOMMU (PAMU)
Thread-Topic: [PATCH 0/9 v2] vfio-pci: add support for Freescale IOMMU (PAMU)
Thread-Index: AQHO5OdyKeXB/EytyUeVGr+Ok97IOJoueBeAgAENqwCAAKUSgIAAARWAgAADyQCABUQ/0IAAu7eAgAMaEYCAAR6mUIAMACkAgAA/BTCAAPlVgIAACIkAgAVR/pA=
Date: Tue, 10 Dec 2013 05:37:11 +0000
Message-ID: <326a93628a9141a9abce97b7bb4e04fd@BN1PR03MB266.namprd03.prod.outlook.com>
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
In-Reply-To: <1386358226.25738.506.camel@ul30vt.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.169.1]
x-forefront-prvs: 005671E15D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(13464003)(377424004)(51704005)(24454002)(199002)(189002)(164054003)(377454003)(76576001)(74316001)(77096001)(49866001)(74366001)(33646001)(76786001)(76796001)(19580395003)(83322001)(81542001)(87266001)(90146001)(2656002)(87936001)(4396001)(85852003)(83072002)(19580405001)(69226001)(79102001)(47736001)(46102001)(80022001)(76482001)(74876001)(65816001)(66066001)(31966008)(54316002)(56776001)(53806001)(54356001)(47976001)(81686001)(51856001)(50986001)(59766001)(56816005)(80976001)(74706001)(81342001)(77982001)(81816001)(85306002)(74502001)(47446002)(74662001)(63696002)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR03MB266;H:BN1PR03MB266.namprd03.prod.outlook.com;CLIP:192.88.169.1;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBA5sv6T011478



> -----Original Message-----
> From: Alex Williamson [mailto:alex.williamson@redhat.com]
> Sent: Saturday, December 07, 2013 1:00 AM
> To: Wood Scott-B07421
> Cc: Bhushan Bharat-R65777; linux-pci@vger.kernel.org; agraf@suse.de; Yoder
> Stuart-B08248; iommu@lists.linux-foundation.org; bhelgaas@google.com; linuxppc-
> dev@lists.ozlabs.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 0/9 v2] vfio-pci: add support for Freescale IOMMU (PAMU)
> 
> On Fri, 2013-12-06 at 12:59 -0600, Scott Wood wrote:
> > On Thu, 2013-12-05 at 22:11 -0600, Bharat Bhushan wrote:
> > >
> > > > -----Original Message-----
> > > > From: Wood Scott-B07421
> > > > Sent: Friday, December 06, 2013 5:52 AM
> > > > To: Bhushan Bharat-R65777
> > > > Cc: Alex Williamson; linux-pci@vger.kernel.org; agraf@suse.de;
> > > > Yoder Stuart- B08248; iommu@lists.linux-foundation.org;
> > > > bhelgaas@google.com; linuxppc- dev@lists.ozlabs.org;
> > > > linux-kernel@vger.kernel.org
> > > > Subject: Re: [PATCH 0/9 v2] vfio-pci: add support for Freescale
> > > > IOMMU (PAMU)
> > > >
> > > > On Thu, 2013-11-28 at 03:19 -0600, Bharat Bhushan wrote:
> > > > >
> > > > > > -----Original Message-----
> > > > > > From: Bhushan Bharat-R65777
> > > > > > Sent: Wednesday, November 27, 2013 9:39 PM
> > > > > > To: 'Alex Williamson'
> > > > > > Cc: Wood Scott-B07421; linux-pci@vger.kernel.org;
> > > > > > agraf@suse.de; Yoder Stuart- B08248;
> > > > > > iommu@lists.linux-foundation.org; bhelgaas@google.com;
> > > > > > linuxppc- dev@lists.ozlabs.org; linux-kernel@vger.kernel.org
> > > > > > Subject: RE: [PATCH 0/9 v2] vfio-pci: add support for
> > > > > > Freescale IOMMU (PAMU)
> > > > > >
> > > > > > If we just provide the size of MSI bank to userspace then
> > > > > > userspace cannot do anything wrong.
> > > > >
> > > > > So userspace does not know address, so it cannot mmap and cause
> > > > > any
> > > > interference by directly reading/writing.
> > > >
> > > > That's security through obscurity...  Couldn't the malicious user
> > > > find out the address via other means, such as experimentation on
> > > > another system over which they have full control?  What would
> > > > happen if the user reads from their device's PCI config space?  Or
> > > > gets the information via some back door in the PCI device they
> > > > own?  Or pokes throughout the address space looking for something that
> generates an interrupt to its own device?
> > >
> > > So how to solve this problem, Any suggestion ?
> > >
> > > We have to map one window in PAMU for MSIs and a malicious user can
> > > ask its device to do DMA to MSI window region with any pair of
> > > address and data, which can lead to unexpected MSIs in system?
> >
> > I don't think there are any solutions other than to limit each bank to
> > one user, unless the admin turns some knob that says they're OK with
> > the partial loss of isolation.
> 
> Even if the admin does opt-in to an allow_unsafe_interrupts options, it should
> still be reasonably difficult for one guest to interfere with the other.  I
> don't think we want to rely on the blind luck of making the full MSI bank
> accessible to multiple guests and hoping they don't step on each other.

Not sure how to solve in this case (sharing MSI page)

>  That probably means that vfio needs to manage the space rather than the guest.

What you mean by " vfio needs to manage the space rather than the guest"?

Thanks
-Bharat

> Thanks,
> 
> Alex
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
