Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbaKLLRU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 06:17:20 -0500
Received: from mail-vc0-f169.google.com ([209.85.220.169]:58920 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbaKLLRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 06:17:18 -0500
MIME-Version: 1.0
In-Reply-To: <a3bfa6c9705d4dd8a345e4a2e5ff3cbb@BN3PR0301MB1265.namprd03.prod.outlook.com>
References: <1414433284-31719-1-git-send-email-a.motakis@virtualopensystems.com>
	<1414433284-31719-4-git-send-email-a.motakis@virtualopensystems.com>
	<CAOhR-w2N3SF=3DTgFr22JfAKDXxzz0PASznJaRjK3oBrRTVcsw@mail.gmail.com>
	<d3c4a63eaa294f1987a797a39eed4650@BN3PR0301MB1265.namprd03.prod.outlook.com>
	<CAOhR-w305sv-_D3QNCtifkzODTv0XoPKBEs6C2MRT1fPVKjZ8A@mail.gmail.com>
	<a3bfa6c9705d4dd8a345e4a2e5ff3cbb@BN3PR0301MB1265.namprd03.prod.outlook.com>
Date: Wed, 12 Nov 2014 19:17:17 +0800
Message-ID: <CAOhR-w2R-6zwqXULHeyx3v+CDBJX9LDDeySsfd4ix3f0hd1f=w@mail.gmail.com>
Subject: Re: [PATCH v9 03/19] vfio: platform: add the VFIO PLATFORM module to Kconfig
From: Hongbo Zhang <hongbo.zhang@linaro.org>
To: "Bharat.Bhushan@freescale.com" <Bharat.Bhushan@freescale.com>
Cc: Antonios Motakis <a.motakis@virtualopensystems.com>,
        "open list:VFIO DRIVER" <kvm@vger.kernel.org>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        open list <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "tech@virtualopensystems.com" <tech@virtualopensystems.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 November 2014 19:00, Bharat.Bhushan@freescale.com
<Bharat.Bhushan@freescale.com> wrote:
>
>
>> -----Original Message-----
>> From: Hongbo Zhang [mailto:hongbo.zhang@linaro.org]
>> Sent: Wednesday, November 12, 2014 4:09 PM
>> To: Bhushan Bharat-R65777
>> Cc: Antonios Motakis; open list:VFIO DRIVER; will.deacon@arm.com;
>> alex.williamson@redhat.com; open list; iommu@lists.linux-foundation.org;
>> tech@virtualopensystems.com; kvmarm@lists.cs.columbia.edu
>> Subject: Re: [PATCH v9 03/19] vfio: platform: add the VFIO PLATFORM module to
>> Kconfig
>>
>> On 12 November 2014 18:05, Bharat.Bhushan@freescale.com
>> <Bharat.Bhushan@freescale.com> wrote:
>> > Hi,
>> >
>> >
>> >
>> > This is not yet supported on Freescale PowerPC. I am still in process
>> > of upstreaming the FSL PAMU specific patches for same.
>> >
>> > Initial plan is to test with PCIe devices and then with Platform devices.
>> >
>>
>> I see there is already driver/iommu/fsl_pamu.c, doesn't it work?
>
> We need VFIO iommu driver for same.
>
>> Could you explain briefly what is wrong? I've heard that the vfio pci works on
>> powerpc platforms.
>
> Yes, patches are in Freescale internal git repository. But those patches are yet to be upstreamed. I have started working on same.

(I come from Freescale too, just currently assigned to Linaro)
Oh, yes I now see vfio iommu driver in the internal git repo, but not
in the community one.
It seems I have to select another platform within Linaro to work with.


>
> Thanks
> -Bharat
>
>>
>> >
>> >
>> > Thanks
>> >
>> > -Bharat
>> >
>> >
>> >
>> > From: kvmarm-bounces@lists.cs.columbia.edu
>> > [mailto:kvmarm-bounces@lists.cs.columbia.edu] On Behalf Of Hongbo
>> > Zhang
>> > Sent: Wednesday, November 12, 2014 3:08 PM
>> > To: Antonios Motakis
>> > Cc: open list:VFIO DRIVER; will.deacon@arm.com;
>> > alex.williamson@redhat.com; open list;
>> > iommu@lists.linux-foundation.org; tech@virtualopensystems.com;
>> > kvmarm@lists.cs.columbia.edu
>> > Subject: Re: [PATCH v9 03/19] vfio: platform: add the VFIO PLATFORM
>> > module to Kconfig
>> >
>> >
>> >
>> >
>> >
>> >
>> >
>> > On 28 October 2014 02:07, Antonios Motakis
>> > <a.motakis@virtualopensystems.com> wrote:
>> >
>> > Enable building the VFIO PLATFORM driver that allows to use Linux
>> > platform devices with VFIO.
>> >
>> > Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
>> > ---
>> >  drivers/vfio/Kconfig           | 1 +
>> >  drivers/vfio/Makefile          | 1 +
>> >  drivers/vfio/platform/Kconfig  | 9 +++++++++
>> > drivers/vfio/platform/Makefile | 4 ++++
>> >  4 files changed, 15 insertions(+)
>> >  create mode 100644 drivers/vfio/platform/Kconfig  create mode 100644
>> > drivers/vfio/platform/Makefile
>> >
>> > diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig index
>> > a0abe04..962fb80 100644
>> > --- a/drivers/vfio/Kconfig
>> > +++ b/drivers/vfio/Kconfig
>> > @@ -27,3 +27,4 @@ menuconfig VFIO
>> >           If you don't know what to do here, say N.
>> >
>> >  source "drivers/vfio/pci/Kconfig"
>> > +source "drivers/vfio/platform/Kconfig"
>> > diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile index
>> > 0b035b1..dadf0ca 100644
>> > --- a/drivers/vfio/Makefile
>> > +++ b/drivers/vfio/Makefile
>> > @@ -3,3 +3,4 @@ obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
>> >  obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
>> >  obj-$(CONFIG_VFIO_SPAPR_EEH) += vfio_spapr_eeh.o
>> >  obj-$(CONFIG_VFIO_PCI) += pci/
>> > +obj-$(CONFIG_VFIO_PLATFORM) += platform/
>> > diff --git a/drivers/vfio/platform/Kconfig
>> > b/drivers/vfio/platform/Kconfig new file mode 100644 index
>> > 0000000..c51af17
>> > --- /dev/null
>> > +++ b/drivers/vfio/platform/Kconfig
>> > @@ -0,0 +1,9 @@
>> > +config VFIO_PLATFORM
>> > +       tristate "VFIO support for platform devices"
>> > +       depends on VFIO && EVENTFD && ARM
>> >
>> >
>> >
>> > Hi Antonios,
>> >
>> > Is this only for ARM? how about X86 and PowerPC?
>> >
>> > On Freescale's PowerPC platform, the IOMMU is called PAMU (Peripheral
>> > Access Management Unit), and I am trying to use this VFIO framework on it.
>> >
>> >
>> >
>> > +       help
>> > +         Support for platform devices with VFIO. This is required to make
>> > +         use of platform devices present on the system using the VFIO
>> > +         framework.
>> > +
>> > +         If you don't know what to do here, say N.
>> > diff --git a/drivers/vfio/platform/Makefile
>> > b/drivers/vfio/platform/Makefile new file mode 100644 index
>> > 0000000..279862b
>> > --- /dev/null
>> > +++ b/drivers/vfio/platform/Makefile
>> > @@ -0,0 +1,4 @@
>> > +
>> > +vfio-platform-y := vfio_platform.o vfio_platform_common.o
>> > +
>> > +obj-$(CONFIG_VFIO_PLATFORM) += vfio-platform.o
>> > --
>> > 2.1.1
>> >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe
>> > linux-kernel" in the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> > Please read the FAQ at  http://www.tux.org/lkml/
>> >
>> >
