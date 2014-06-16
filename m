Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683AbaFPSyA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 14:54:00 -0400
Received: from mail-bn1lp0144.outbound.protection.outlook.com ([207.46.163.144]:49257
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755333AbaFPSx4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 14:53:56 -0400
From: Stuart Yoder <stuart.yoder@freescale.com>
To: Will Deacon <will.deacon@arm.com>
CC: Varun Sethi <Varun.Sethi@freescale.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Grundler <grundler@chromium.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "Linux IOMMU" <iommu@lists.linux-foundation.org>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        "Dave P Martin" <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH v2] devicetree: Add generic IOMMU device tree bindings
Thread-Topic: [PATCH v2] devicetree: Add generic IOMMU device tree bindings
Thread-Index: AQHPdsaiUOp/jHgCJ0WWjZOTtpbJjZtZJRKAgABh1wCAAAcqgIAABQyAgAQdoQCAA2YSAIAAI08AgAG4pNCAEQ6xgIAAEv9AgAAIAACAAA57IA==
Date: Mon, 16 Jun 2014 18:53:52 +0000
Message-ID: <419e67f783524d208ab3be16bcd94bd9@DM2PR03MB352.namprd03.prod.outlook.com>
References: <1400877218-4113-1-git-send-email-thierry.reding@gmail.com>
 <4545972.cM7IP1qTXQ@wuerfel>
 <CAL_Jsq+tkFNpjSEZboT+o69B_Z3a8e-ZVKaYDmLwtkyYoPy6VQ@mail.gmail.com>
 <5288123.eXagyPAxNq@wuerfel>
 <20140602104104.GD3855@e103592.cambridge.arm.com>
 <20140604143509.GF28484@ulmo> <20140604164132.GF6644@arm.com>
 <07321368d15d4ad9928ebb83af87e401@DM2PR03MB479.namprd03.prod.outlook.com>
 <20140616152739.GS16758@arm.com>
 <8b0492b4697943a0b1f276ef42cc8223@DM2PR03MB352.namprd03.prod.outlook.com>
 <20140616170416.GA16758@arm.com>
In-Reply-To: <20140616170416.GA16758@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.168.49]
x-microsoft-antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
x-forefront-prvs: 0244637DEA
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(428001)(24454002)(189002)(199002)(164054003)(13464003)(51704005)(377454003)(81542001)(19580405001)(83322001)(19580395003)(76576001)(81342001)(76176999)(86362001)(101416001)(31966008)(74662001)(4396001)(93886003)(54356999)(50986999)(74502001)(85306003)(64706001)(79102001)(80022001)(76482001)(105586001)(77982001)(66066001)(92566001)(33646001)(46102001)(74316001)(99396002)(85852003)(83072002)(87936001)(21056001)(2656002)(95666004)(20776003)(99286002)(41533002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB478;H:DM2PR03MB352.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=stuart.yoder@freescale.com; 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Will Deacon [mailto:will.deacon@arm.com]
> Sent: Monday, June 16, 2014 12:04 PM
> To: Yoder Stuart-B08248
> Cc: Sethi Varun-B16395; Thierry Reding; Mark Rutland;
> devicetree@vger.kernel.org; linux-samsung-soc@vger.kernel.org; Pawel
> Moll; Arnd Bergmann; Ian Campbell; Grant Grundler; Stephen Warren; linux-
> kernel@vger.kernel.org; Marc Zyngier; Linux IOMMU; Rob Herring; Kumar
> Gala; linux-tegra@vger.kernel.org; Cho KyongHo; Dave P Martin; linux-arm-
> kernel@lists.infradead.org
> Subject: Re: [PATCH v2] devicetree: Add generic IOMMU device tree
> bindings
> 
> Hi Stuart,
> 
> On Mon, Jun 16, 2014 at 05:56:32PM +0100, Stuart Yoder wrote:
> > > Do you have use-cases where you really need to change these mappings
> > > dynamically?
> >
> > Yes.  In the case of a PCI bus-- you may not know in advance how many
> > PCI devices there are until you probe the bus.   We have another FSL
> > proprietary bus we call the "fsl-mc" bus that is similar.
> 
> For that case, though, you could still describe an algorithmic
> transformation from RequesterID to StreamID which corresponds to a fixed
> mapping.
> 
> > Another thing to consider-- starting with SMMUv2, as you know, there
> > is a new distributed architecture with multiple TBUs and a centralized
> > TCU that walks the SMMU page tables.  So instead of sprinkling multiple
> > SMMUs all over an SoC you now have the option a 1 central TCU and
> sprinkling
> > multiple TBUs around.   However, this means that the stream ID
> namespace
> > is now global and can be pretty limited.  In the SMMU implementation we
> > have there are only 64 stream ID total for our Soc.  But we have many
> more
> > masters than that.
> >
> > So we look at stream IDs as really corresponding to an 'isolation
> context'
> > and not to a bus master.  An isolation context is the domain you are
> > trying to isolate with the SMMU.  Devices that all belong to the same
> > 'isolation context' can share the same stream ID, since they share
> > the same domain and page tables.
> 
> Ok, this is more compelling.
> 
> > So, perhaps by default some/most SMMU masters may have a default stream
> ID
> > of 0x0 that is used by the host...and that could be represented
> > statically in the device tree.
> >
> > But, we absolutely will need to dynamically set new stream IDs
> > into masters when a new IOMMU 'domain' is created and devices
> > are added to it.   All the devices in a domain will share
> > the same stream ID.
> >
> > So whatever we do, let's please have an architecture flexible enough
> > to allow for this.
> 
> What is the software interface to the logic that assigns the StreamIDs?
> Is
> it part of the SMMU, or a separate device (or set of devices)?

For us at the hardware level there are a few different ways that the streamIDs
can be set.  It is not part of the SMMU.  In the cases where there is simply
1 device to 1 streamID (e.g. USB controller) there is an SoC register where
you just program the stream ID.   In the case of PCI, our PCI controller
has a RequesterID-to-streamID table that you set via some PCI controller
registers.

The way we generally thought it would work was something like
this:
   -u-boot/bootloader makes any static streamID allocation if needed,
    sets a default streamID  (e.g. 0x0) in device and expresses
    that in the device tree
   -device tree would express relationship between devices
    (including bus controllers) and the SMMU through mmu-masters
    property
   -u-boot would express the range of unused (or used) streamIDs via a new
    device tree property so the kernel SMMU driver knows what streamIDs are
    free
   -in the SMMU driver a different vendor specific 'add_device' callback
    could be used to handle our special cases where we need to set/change
    the stream ID for devices added to a domain

Thanks,
Stuart
