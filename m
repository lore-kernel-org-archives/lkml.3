Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422688AbaDJUDd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 16:03:33 -0400
Received: from mail-bl2lp0210.outbound.protection.outlook.com ([207.46.163.210]:17331
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030242AbaDJUDb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 16:03:31 -0400
From: Stuart Yoder <stuart.yoder@freescale.com>
To: Kim Phillips <Kim.Phillips@freescale.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "tech@virtualopensystems.com" <tech@virtualopensystems.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>
Subject: RE: [PATCH] driver core: platform: add device binding path
 'driver_override'
Thread-Topic: [PATCH] driver core: platform: add device binding path
 'driver_override'
Thread-Index: AQHPU5ZdossC2Idl3Ua/vt9niy2zM5sLSI/Q
Date: Thu, 10 Apr 2014 20:03:15 +0000
Message-ID: <52375b57e4b8493a8563aca98b7ba041@DM2PR03MB352.namprd03.prod.outlook.com>
References: <20140404201818.14389.86188.stgit@bling.home>
 <20140408204726.7a8f4cd6fbd05d0464720b30@freescale.com>
In-Reply-To: <20140408204726.7a8f4cd6fbd05d0464720b30@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.168.49]
x-forefront-prvs: 0177904E6B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(377454003)(199002)(13464003)(51704005)(189002)(4396001)(99286001)(74316001)(2656002)(92566001)(79102001)(86362001)(76176999)(50986999)(54356999)(77096999)(33646001)(76482001)(80976001)(15975445006)(83072002)(76576001)(74502001)(19580395003)(99396002)(87936001)(81542001)(74662001)(85852003)(46102001)(31966008)(19580405001)(20776003)(81342001)(83322001)(80022001)(77982001)(66066001)(15202345003)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB335;H:DM2PR03MB352.namprd03.prod.outlook.com;FPR:7C5E551E.172E8DCA.39DF9732.851CB961.2025D;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Kim Phillips [mailto:kim.phillips@freescale.com]
> Sent: Tuesday, April 08, 2014 8:47 PM
> To: Alex Williamson; gregkh@linuxfoundation.org
> Cc: bhelgaas@google.com; linux-pci@vger.kernel.org; kvm@vger.kernel.org;
> konrad.wilk@oracle.com; Yoder Stuart-B08248; libvir-list@redhat.com;
> iommu@lists.linux-foundation.org; tech@virtualopensystems.com;
> kvmarm@lists.cs.columbia.edu; linux-kernel@vger.kernel.org; Guenter
> Roeck; christoffer.dall@linaro.org
> Subject: [PATCH] driver core: platform: add device binding path
> 'driver_override'
> 
> Needed by platform device drivers, such as the vfio-platform driver [1],
> in order to bypass the existing OF, ACPI, id_table and name string
> matches,
> and successfully be able to be bound to any device, like so:
> 
> echo vfio-platform >
> /sys/bus/platform/devices/fff51000.ethernet/driver_override
> echo fff51000.ethernet >
> /sys/bus/platform/devices/fff51000.ethernet/driver/unbind
> echo fff51000.ethernet > /sys/bus/platform/drivers_probe
> 
> This mimics "PCI: Introduce new device binding path using
> pci_dev.driver_override" [2], which is an interface enhancement
> for more deterministic PCI device binding, e.g., when in the
> presence of hotplug.
> 
> [1] http://lkml.iu.edu/hypermail/linux/kernel/1402.1/00177.html
> [2] http://lists-archives.com/linux-kernel/28030441-pci-introduce-new-
> device-binding-path-using-pci_dev-driver_override.html
> 
> Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
> ---

Reviewed-by: Stuart Yoder <stuart.yoder@freescale.com>
