Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbaBZPqe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 10:46:34 -0500
Received: from na01-by1-obe.ptr.o365filtering.com ([64.4.22.89]:13366 "EHLO
	na01-by1-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752982AbaBZPqb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 10:46:31 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Gerd Hoffmann <kraxel@redhat.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        KY Srinivasan <kys@microsoft.com>,
        "Abhishek Gupta (LIS)" <abgupta@microsoft.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "tomi.valkeinen@ti.com" <tomi.valkeinen@ti.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Subject: RE: [PATCH v5 1/2] hyperv-fb: add support for generation 2 virtual
 machines.
Thread-Topic: [PATCH v5 1/2] hyperv-fb: add support for generation 2 virtual
 machines.
Thread-Index: AQHPMuDW6+GagTqrDk+TzIZhfZym05rHrXIw
Date: Wed, 26 Feb 2014 15:46:13 +0000
Message-ID: <bea2fdf0ef1a40949bd5c6c5065547ce@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1393411885-14895-1-git-send-email-kraxel@redhat.com>
 <1393411885-14895-2-git-send-email-kraxel@redhat.com>
In-Reply-To: <1393411885-14895-2-git-send-email-kraxel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.59.235.233]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.159.99;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(377454003)(189002)(199002)(13464003)(51704005)(69226001)(76482001)(81686001)(93516002)(80022001)(85306002)(47976001)(94316002)(54356001)(74876001)(50466002)(47736001)(65816001)(66066001)(31966008)(74662001)(20776003)(63696002)(80976001)(47776003)(4396001)(79102001)(84676001)(74502001)(44976005)(47446002)(83322001)(53806001)(19580405001)(19580395003)(6806004)(74706001)(77982001)(2656002)(87266001)(59766001)(46102001)(56776001)(76786001)(93136001)(83072002)(85852003)(95666003)(81542001)(81342001)(87936001)(76796001)(46406003)(86612001)(95416001)(74366001)(23726002)(94946001)(50986001)(51856001)(90146001)(49866001)(81816001)(56816005)(33646001)(54316002)(92566001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUSR01MB589;H:hybrid.exchange.microsoft.com;FPR:2CFE79AE.ABD3D58A.F9E13F83.C2ABC812.201F9;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 0134AD334F
X-OriginatorOrg: msft.ccsctp.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linux-fbdev-owner@vger.kernel.org [mailto:linux-fbdev-
> owner@vger.kernel.org] On Behalf Of Gerd Hoffmann
> Sent: Wednesday, February 26, 2014 5:51 AM
> To: linux-fbdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org; gregkh@linuxfoundation.org; KY Srinivasan;
> Abhishek Gupta (LIS); Haiyang Zhang; jasowang@redhat.com;
> tomi.valkeinen@ti.com; devel@linuxdriverproject.org; Gerd Hoffmann; Jean-
> Christophe Plagniol-Villard
> Subject: [PATCH v5 1/2] hyperv-fb: add support for generation 2 virtual
> machines.
> 
> UEFI-based generation 2 virtual machines support vmbus devices only.
> There is no pci bus.  Thus they use a different mechanism for the
> graphics framebuffer:  Instead of using the vga pci bar a chunk of
> memory muct be allocated from the hyperv mmio region declared using
> APCI.  This patch implements support for it.
> 
> Based on a patch by Haiyang Zhang <haiyangz@microsoft.com>
> 
> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>

Thank you!

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

