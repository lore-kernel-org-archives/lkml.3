Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006AbaBNWBO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 17:01:14 -0500
Received: from na01-sn2-obe.ptr.o365filtering.com ([157.55.158.25]:17069 "EHLO
	na01-sn2-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752965AbaBNWBN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 17:01:13 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: "FlorianSchandinat@gmx.de" <FlorianSchandinat@gmx.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: KY Srinivasan <kys@microsoft.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
Subject: RE: [PATCH] hyperv_fb: Add support for Gen2 VM
Thread-Topic: [PATCH] hyperv_fb: Add support for Gen2 VM
Thread-Index: AQHPJOvCLgwWJBob2k6qDfpnl1kWP5q1Vhsg
Date: Fri, 14 Feb 2014 22:00:43 +0000
Message-ID: <f7618c3978634ca08d6cdbd5de450d56@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1391880342-10081-1-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1391880342-10081-1-git-send-email-haiyangz@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.159.99;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(377454003)(13464003)(199002)(51704005)(164054003)(189002)(57704003)(51856001)(65816001)(74706001)(95416001)(80022001)(94946001)(95666001)(94316002)(86612001)(76482001)(92566001)(2201001)(19580395003)(50466002)(46406003)(90146001)(56816005)(93516002)(93136001)(77982001)(59766001)(85306002)(56776001)(74366001)(54316002)(87266001)(4396001)(76786001)(76796001)(6806004)(20776003)(33646001)(47776003)(69226001)(81542001)(2656002)(23726002)(54356001)(83072002)(44976005)(53806001)(85852003)(81686001)(31966008)(79102001)(74662001)(63696002)(81342001)(19580405001)(83322001)(74876001)(47446002)(74502001)(47976001)(66066001)(81816001)(49866001)(47736001)(87936001)(50986001)(46102001)(80976001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2SR01MB592;H:hybrid.exchange.microsoft.com;CLIP:131.107.159.99;FPR:A8057552.2CB3AD02.C97B33C5.40E9891C.201EC;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Forefront-PRVS: 01221E3973
X-OriginatorOrg: msft.ccsctp.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linux-fbdev-owner@vger.kernel.org [mailto:linux-fbdev-
> owner@vger.kernel.org] On Behalf Of Haiyang Zhang
> Sent: Saturday, February 8, 2014 12:26 PM
> To: FlorianSchandinat@gmx.de; akpm@linux-foundation.org; linux-
> fbdev@vger.kernel.org
> Cc: Haiyang Zhang; KY Srinivasan; olaf@aepfle.de; jasowang@redhat.com;
> gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org; driverdev-
> devel@linuxdriverproject.org
> Subject: [PATCH] hyperv_fb: Add support for Gen2 VM
> 
> This patch enables Hyper-V FB driver to run on Gen2 VM.
> 
> The Gen2 VM provides MMIO area for synthetic video from ACPI module,
> which is exported by vmbus. The generic video is provided by UEFI. PCI video
> in Gen1 is no longer available.
> 
> To support synthetic video on Hyper-V Gen2 VM, this patch updated code
> related to the changes above.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
> ---

Hi Tomi and Andrew,

This patch has been submitted for a while. Do I need to re-submit it, or 
make any changes?

Thanks,
- Haiyang

