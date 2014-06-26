Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751346AbaFZSlZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 14:41:25 -0400
Received: from mail-bl2lp0209.outbound.protection.outlook.com ([207.46.163.209]:45447
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751175AbaFZSlX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 14:41:23 -0400
From: "Chalamarla, Tirumalesh" <Tirumalesh.Chalamarla@caviumnetworks.com>
To: Joerg Roedel <joro@8bytes.org>, Will Deacon <will.deacon@arm.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "stuart.yoder@freescale.com" <stuart.yoder@freescale.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "tech@virtualopensystems.com" <tech@virtualopensystems.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "moderated list:ARM SMMU DRIVER" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [RFC PATCH v6 04/20] iommu/arm-smmu: add capability
 IOMMU_CAP_INTR_REMAP
Thread-Topic: [RFC PATCH v6 04/20] iommu/arm-smmu: add capability
 IOMMU_CAP_INTR_REMAP
Thread-Index: AQHPgOBbNdL1uGTtt0GgwoLMBshUy5tnB9yAgAzb7QCAAAWEgIAAAl8AgAAA+ACAAAOpAIAP3+jggAAC4JCAAAc+EA==
Date: Thu, 26 Jun 2014 18:41:07 +0000
Message-ID: <b085e02e72dc424d9624c3e810951087@BY2PR07MB203.namprd07.prod.outlook.com>
References: <1401987808-23596-1-git-send-email-a.motakis@virtualopensystems.com>
 <1401987808-23596-5-git-send-email-a.motakis@virtualopensystems.com>
 <20140608103129.GC3279@lvm> <20140616145344.GD18986@8bytes.org>
 <20140616151329.GQ16758@arm.com> <20140616152157.GB31771@8bytes.org>
 <20140616152526.GR16758@arm.com> <20140616153832.GC31771@8bytes.org>
 <9353770066894e85809e1e443b71d1cd@BY2PR07MB203.namprd07.prod.outlook.com>
 <748dccbbd3284521af4659ccbbb11453@BY2PR07MB203.namprd07.prod.outlook.com>
In-Reply-To: <748dccbbd3284521af4659ccbbb11453@BY2PR07MB203.namprd07.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [64.2.3.195]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(24454002)(13464003)(199002)(189002)(377454003)(85306003)(64706001)(20776003)(99396002)(33646001)(92566001)(76482001)(50986999)(80022001)(81542001)(79102001)(77096002)(81342001)(66066001)(86362001)(4396001)(105586002)(83322001)(76576001)(15975445006)(106116001)(19580405001)(106356001)(19580395003)(54356999)(74662001)(31966008)(74502001)(107046002)(21056001)(76176999)(74316001)(46102001)(93886003)(77982001)(2656002)(101416001)(95666004)(83072002)(87936001)(85852003)(24736002)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR07MB203;H:BY2PR07MB203.namprd07.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry there was a type,

The question is:
 
            How is VFIO restricting software from writing to MSI/MSI-X vectors of the device. 

-----Original Message-----
From: Chalamarla, Tirumalesh 
Sent: Thursday, June 26, 2014 11:16 AM
To: Chalamarla, Tirumalesh; Joerg Roedel; Will Deacon
Cc: kvm@vger.kernel.org; open list; alex.williamson@redhat.com; stuart.yoder@freescale.com; iommu@lists.linux-foundation.org; tech@virtualopensystems.com; kvmarm@lists.cs.columbia.edu; moderated list:ARM SMMU DRIVER
Subject: RE: [RFC PATCH v6 04/20] iommu/arm-smmu: add capability IOMMU_CAP_INTR_REMAP

When I say emulating ITS, I mean translating guest ITS commands to physical ITS commands  and placing them in physical queue. 

Regards,
Tirumalesh.

-----Original Message-----
From: kvmarm-bounces@lists.cs.columbia.edu [mailto:kvmarm-bounces@lists.cs.columbia.edu] On Behalf Of Chalamarla, Tirumalesh
Sent: Thursday, June 26, 2014 11:08 AM
To: Joerg Roedel; Will Deacon
Cc: kvm@vger.kernel.org; open list; alex.williamson@redhat.com; stuart.yoder@freescale.com; iommu@lists.linux-foundation.org; tech@virtualopensystems.com; kvmarm@lists.cs.columbia.edu; moderated list:ARM SMMU DRIVER
Subject: RE: [RFC PATCH v6 04/20] iommu/arm-smmu: add capability IOMMU_CAP_INTR_REMAP

Forgive me if this discussion is not relative here, but I thought it is.  

How is VFIO restricting devices from writing  to MSI/MSI-X, Is all the vector area is mapped by VFIO to trap the accesses.  I am asking this because we might need to emulate ITS somewhere either in KVM or VFIO to provide direct access to devices.
And I don't see any mentions on that.   I think this flag needs to be set by ITS emulation.

Regards,
Tirumalesh.

-----Original Message-----
From: kvmarm-bounces@lists.cs.columbia.edu [mailto:kvmarm-bounces@lists.cs.columbia.edu] On Behalf Of Joerg Roedel
Sent: Monday, June 16, 2014 8:39 AM
To: Will Deacon
Cc: stuart.yoder@freescale.com; kvm@vger.kernel.org; open list; iommu@lists.linux-foundation.org; alex.williamson@redhat.com; moderated list:ARM SMMU DRIVER; tech@virtualopensystems.com; kvmarm@lists.cs.columbia.edu; Christoffer Dall
Subject: Re: [RFC PATCH v6 04/20] iommu/arm-smmu: add capability IOMMU_CAP_INTR_REMAP

On Mon, Jun 16, 2014 at 04:25:26PM +0100, Will Deacon wrote:
> Ok, thanks. In which case, I think this is really a combined property 
> of the SMMU and the interrupt controller, so we might need some extra 
> code so that the SMMU can check that the interrupt controller for the 
> device is also capable of interrupt remapping.

Right, that this is part of IOMMU code has more or less historic reasons on x86. Interrupt remapping is purely implemented in the IOMMU there, so on ARM some clue-code between interrupt controler and smmu is needed.


	Joerg


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
