Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142AbaFQLVv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 07:21:51 -0400
Received: from mail-by2lp0240.outbound.protection.outlook.com ([207.46.163.240]:44280
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756042AbaFQLVs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 07:21:48 -0400
From: Varun Sethi <Varun.Sethi@freescale.com>
To: Will Deacon <will.deacon@arm.com>
CC: Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, "Pawel Moll" <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Grundler <grundler@chromium.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Stuart Yoder <stuart.yoder@freescale.com>,
        "Rob Herring" <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "Linux IOMMU" <iommu@lists.linux-foundation.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Kumar Gala <galak@codeaurora.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH v2] devicetree: Add generic IOMMU device tree bindings
Thread-Topic: [PATCH v2] devicetree: Add generic IOMMU device tree bindings
Thread-Index: AQHPdsaiUOp/jHgCJ0WWjZOTtpbJjZtZJRKAgABh1wCAAAcqgIAABQyAgAQdoQCAA2YSAIAAI08AgAG4pNCAEQ6xgIAAEv9AgAAIAACAAA57IIABBsywgAASjACAAAUA0A==
Date: Tue, 17 Jun 2014 11:21:43 +0000
Message-ID: <32165315f0b84be9948f489fd87bf6a9@BL2PR03MB468.namprd03.prod.outlook.com>
References: <5288123.eXagyPAxNq@wuerfel>
	<20140602104104.GD3855@e103592.cambridge.arm.com>
	<20140604143509.GF28484@ulmo> <20140604164132.GF6644@arm.com>
	<07321368d15d4ad9928ebb83af87e401@DM2PR03MB479.namprd03.prod.outlook.com>
	<20140616152739.GS16758@arm.com>
	<8b0492b4697943a0b1f276ef42cc8223@DM2PR03MB352.namprd03.prod.outlook.com>
	<20140616170416.GA16758@arm.com>
	<419e67f783524d208ab3be16bcd94bd9@DM2PR03MB352.namprd03.prod.outlook.com>
	<0587e1f4894546398be0798d2bc2c84f@BL2PR03MB468.namprd03.prod.outlook.com>
 <20140617104304.GD13808@arm.com>
In-Reply-To: <20140617104304.GD13808@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.169.1]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 0245702D7B
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(428001)(199002)(189002)(51704005)(24454002)(377454003)(13464003)(74502001)(80022001)(79102001)(83072002)(54356999)(92566001)(86362001)(76576001)(76482001)(31966008)(99396002)(101416001)(95666004)(99286002)(105586001)(33646001)(81342001)(19580395003)(21056001)(83322001)(76176999)(66066001)(77982001)(85306003)(81542001)(85852003)(20776003)(93886003)(64706001)(74316001)(19580405001)(2656002)(4396001)(46102001)(87936001)(50986999)(74662001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB340;H:BL2PR03MB468.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Varun.Sethi@freescale.com; 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: iommu-bounces@lists.linux-foundation.org [mailto:iommu-
> bounces@lists.linux-foundation.org] On Behalf Of Will Deacon
> Sent: Tuesday, June 17, 2014 4:13 PM
> To: Sethi Varun-B16395
> Cc: Mark Rutland; devicetree@vger.kernel.org; linux-samsung-
> soc@vger.kernel.org; Arnd Bergmann; Pawel Moll; Ian Campbell; Grant
> Grundler; Stephen Warren; Yoder Stuart-B08248; Rob Herring; linux-
> kernel@vger.kernel.org; Marc Zyngier; Linux IOMMU; Thierry Reding; Kumar
> Gala; linux-tegra@vger.kernel.org; Cho KyongHo; Dave P Martin; linux-arm-
> kernel@lists.infradead.org
> Subject: Re: [PATCH v2] devicetree: Add generic IOMMU device tree
> bindings
> 
> On Tue, Jun 17, 2014 at 11:26:48AM +0100, Varun Sethi wrote:
> > > The way we generally thought it would work was something like
> > > this:
> > >    -u-boot/bootloader makes any static streamID allocation if needed,
> > >     sets a default streamID  (e.g. 0x0) in device and expresses
> > >     that in the device tree
> > >    -device tree would express relationship between devices
> > >     (including bus controllers) and the SMMU through mmu-masters
> > >     property
> > >    -u-boot would express the range of unused (or used) streamIDs via
> > > a new
> > >     device tree property so the kernel SMMU driver knows what
> > > streamIDs are
> > >     free
> > >    -in the SMMU driver a different vendor specific 'add_device'
> callback
> > >     could be used to handle our special cases where we need to
> set/change
> > >     the stream ID for devices added to a domain
> >
> > Another possibility, could be to program the stream Id in the device
> > registers (reference for the stream ID register can be obtained from
> > the device tree) during device attach. This could be relevant in case
> > of VFIO, when we are assigning multiple devices to a single VM. All
> > the devices can share the same stream ID.
> 
> I think for simple masters (i.e. those that have all their StreamIDs
> under control of one driver), then setting something during attach (or
> add?) based on the DT could work pretty well. The other case is when we
> have masters behind a bridge (such as a PCI RC). In this case, it might
> actually be better to ask the bridge for the IDs and let it sort out the
> allocation itself. That would also move the RequesterID -> StreamID
> mapping out of the SMMU code.
> 
> What do you think?
The PCI bus iommu group creation code would be part of the SMMU driver (it is handled by other IOMMU drivers as well). My understanding is that there would be one is to one correspondence between the requestor ID and the iommu group. May be, we can have an API provided by the PCI bridge (architecture specific) for setting the stream ID.

-Varun
