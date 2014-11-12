Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733AbaKLLAV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 06:00:21 -0500
Received: from mail-bn1on0135.outbound.protection.outlook.com ([157.56.110.135]:40349
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752322AbaKLLAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 06:00:18 -0500
From: "Bharat.Bhushan@freescale.com" <Bharat.Bhushan@freescale.com>
To: Hongbo Zhang <hongbo.zhang@linaro.org>
CC: Antonios Motakis <a.motakis@virtualopensystems.com>,
        "open list:VFIO DRIVER" <kvm@vger.kernel.org>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        open list <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "tech@virtualopensystems.com" <tech@virtualopensystems.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
Subject: RE: [PATCH v9 03/19] vfio: platform: add the VFIO PLATFORM module to
 Kconfig
Thread-Topic: [PATCH v9 03/19] vfio: platform: add the VFIO PLATFORM module to
 Kconfig
Thread-Index: AQHP/l72QXCJlfSnqUezRdYPZfhylpxcwwvggAAJ8QCAAAVl0A==
Date: Wed, 12 Nov 2014 11:00:16 +0000
Message-ID: <a3bfa6c9705d4dd8a345e4a2e5ff3cbb@BN3PR0301MB1265.namprd03.prod.outlook.com>
References: <1414433284-31719-1-git-send-email-a.motakis@virtualopensystems.com>
	<1414433284-31719-4-git-send-email-a.motakis@virtualopensystems.com>
	<CAOhR-w2N3SF=3DTgFr22JfAKDXxzz0PASznJaRjK3oBrRTVcsw@mail.gmail.com>
	<d3c4a63eaa294f1987a797a39eed4650@BN3PR0301MB1265.namprd03.prod.outlook.com>
 <CAOhR-w305sv-_D3QNCtifkzODTv0XoPKBEs6C2MRT1fPVKjZ8A@mail.gmail.com>
In-Reply-To: <CAOhR-w305sv-_D3QNCtifkzODTv0XoPKBEs6C2MRT1fPVKjZ8A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.169.1]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1267;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1267;
x-forefront-prvs: 03932714EB
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(377454003)(51704005)(13464003)(24454002)(120916001)(87936001)(2656002)(19580395003)(19580405001)(76576001)(64706001)(20776003)(66066001)(54356999)(50986999)(76176999)(15975445006)(33646002)(97736003)(99286002)(122556002)(110136001)(99396003)(95666004)(107046002)(106116001)(105586002)(106356001)(4396001)(46102003)(21056001)(77156002)(40100003)(77096003)(62966003)(101416001)(31966008)(93886004)(575784001)(86362001)(108616004)(92566001)(74316001)(15202345003)(24736002)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN3PR0301MB1267;H:BN3PR0301MB1265.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sACB0RkB016540



> -----Original Message-----
> From: Hongbo Zhang [mailto:hongbo.zhang@linaro.org]
> Sent: Wednesday, November 12, 2014 4:09 PM
> To: Bhushan Bharat-R65777
> Cc: Antonios Motakis; open list:VFIO DRIVER; will.deacon@arm.com;
> alex.williamson@redhat.com; open list; iommu@lists.linux-foundation.org;
> tech@virtualopensystems.com; kvmarm@lists.cs.columbia.edu
> Subject: Re: [PATCH v9 03/19] vfio: platform: add the VFIO PLATFORM module to
> Kconfig
> 
> On 12 November 2014 18:05, Bharat.Bhushan@freescale.com
> <Bharat.Bhushan@freescale.com> wrote:
> > Hi,
> >
> >
> >
> > This is not yet supported on Freescale PowerPC. I am still in process
> > of upstreaming the FSL PAMU specific patches for same.
> >
> > Initial plan is to test with PCIe devices and then with Platform devices.
> >
> 
> I see there is already driver/iommu/fsl_pamu.c, doesn't it work?

We need VFIO iommu driver for same.

> Could you explain briefly what is wrong? I've heard that the vfio pci works on
> powerpc platforms.

Yes, patches are in Freescale internal git repository. But those patches are yet to be upstreamed. I have started working on same.

Thanks
-Bharat

> 
> >
> >
> > Thanks
> >
> > -Bharat
> >
> >
> >
> > From: kvmarm-bounces@lists.cs.columbia.edu
> > [mailto:kvmarm-bounces@lists.cs.columbia.edu] On Behalf Of Hongbo
> > Zhang
> > Sent: Wednesday, November 12, 2014 3:08 PM
> > To: Antonios Motakis
> > Cc: open list:VFIO DRIVER; will.deacon@arm.com;
> > alex.williamson@redhat.com; open list;
> > iommu@lists.linux-foundation.org; tech@virtualopensystems.com;
> > kvmarm@lists.cs.columbia.edu
> > Subject: Re: [PATCH v9 03/19] vfio: platform: add the VFIO PLATFORM
> > module to Kconfig
> >
> >
> >
> >
> >
> >
> >
> > On 28 October 2014 02:07, Antonios Motakis
> > <a.motakis@virtualopensystems.com> wrote:
> >
> > Enable building the VFIO PLATFORM driver that allows to use Linux
> > platform devices with VFIO.
> >
> > Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> > ---
> >  drivers/vfio/Kconfig           | 1 +
> >  drivers/vfio/Makefile          | 1 +
> >  drivers/vfio/platform/Kconfig  | 9 +++++++++
> > drivers/vfio/platform/Makefile | 4 ++++
> >  4 files changed, 15 insertions(+)
> >  create mode 100644 drivers/vfio/platform/Kconfig  create mode 100644
> > drivers/vfio/platform/Makefile
> >
> > diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig index
> > a0abe04..962fb80 100644
> > --- a/drivers/vfio/Kconfig
> > +++ b/drivers/vfio/Kconfig
> > @@ -27,3 +27,4 @@ menuconfig VFIO
> >           If you don't know what to do here, say N.
> >
> >  source "drivers/vfio/pci/Kconfig"
> > +source "drivers/vfio/platform/Kconfig"
> > diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile index
> > 0b035b1..dadf0ca 100644
> > --- a/drivers/vfio/Makefile
> > +++ b/drivers/vfio/Makefile
> > @@ -3,3 +3,4 @@ obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
> >  obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
> >  obj-$(CONFIG_VFIO_SPAPR_EEH) += vfio_spapr_eeh.o
> >  obj-$(CONFIG_VFIO_PCI) += pci/
> > +obj-$(CONFIG_VFIO_PLATFORM) += platform/
> > diff --git a/drivers/vfio/platform/Kconfig
> > b/drivers/vfio/platform/Kconfig new file mode 100644 index
> > 0000000..c51af17
> > --- /dev/null
> > +++ b/drivers/vfio/platform/Kconfig
> > @@ -0,0 +1,9 @@
> > +config VFIO_PLATFORM
> > +       tristate "VFIO support for platform devices"
> > +       depends on VFIO && EVENTFD && ARM
> >
> >
> >
> > Hi Antonios,
> >
> > Is this only for ARM? how about X86 and PowerPC?
> >
> > On Freescale's PowerPC platform, the IOMMU is called PAMU (Peripheral
> > Access Management Unit), and I am trying to use this VFIO framework on it.
> >
> >
> >
> > +       help
> > +         Support for platform devices with VFIO. This is required to make
> > +         use of platform devices present on the system using the VFIO
> > +         framework.
> > +
> > +         If you don't know what to do here, say N.
> > diff --git a/drivers/vfio/platform/Makefile
> > b/drivers/vfio/platform/Makefile new file mode 100644 index
> > 0000000..279862b
> > --- /dev/null
> > +++ b/drivers/vfio/platform/Makefile
> > @@ -0,0 +1,4 @@
> > +
> > +vfio-platform-y := vfio_platform.o vfio_platform_common.o
> > +
> > +obj-$(CONFIG_VFIO_PLATFORM) += vfio-platform.o
> > --
> > 2.1.1
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-kernel" in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> >
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
