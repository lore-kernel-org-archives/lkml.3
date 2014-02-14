Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbaBNV7I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 16:59:08 -0500
Received: from na01-sn2-obe.ptr.o365filtering.com ([157.55.158.24]:57403 "EHLO
	na01-sn2-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752599AbaBNV7G convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 16:59:06 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: "FlorianSchandinat@gmx.de" <FlorianSchandinat@gmx.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: KY Srinivasan <kys@microsoft.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
Subject: RE: [PATCH] hyperv_fb: Add screen refresh after pause/resume
 operation
Thread-Topic: [PATCH] hyperv_fb: Add screen refresh after pause/resume
 operation
Thread-Index: AQHPELevFwzIeA4Y7UO6r7w197ycAJq1fYIg
Date: Fri, 14 Feb 2014 21:58:22 +0000
Message-ID: <4e5f883e38f64a8d932d9047f787abaf@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1389658838-15765-1-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1389658838-15765-1-git-send-email-haiyangz@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.159.100;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(199002)(189002)(377454003)(51704005)(57704003)(13464003)(164054003)(87266001)(33646001)(74876001)(2656002)(31966008)(47446002)(74502001)(74662001)(46102001)(81342001)(47776003)(86612001)(69226001)(2201001)(92566001)(63696002)(66066001)(80022001)(65816001)(95666001)(51856001)(95416001)(80976001)(49866001)(50986001)(19580405001)(83322001)(47736001)(47976001)(20776003)(87936001)(53806001)(85306002)(54356001)(76786001)(6806004)(76796001)(19580395003)(44976005)(79102001)(93136001)(83072002)(50466002)(81542001)(74366001)(85852003)(56816005)(76482001)(77982001)(90146001)(23726002)(81816001)(81686001)(93516002)(4396001)(74706001)(59766001)(54316002)(46406003)(94316002)(56776001)(94946001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2SR01MB597;H:hybrid.exchange.microsoft.com;CLIP:131.107.159.100;FPR:A49D355E.1C33BC4A.4BFB2D87.6D3B1D.2017F;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Forefront-PRVS: 01221E3973
X-OriginatorOrg: msft.ccsctp.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Haiyang Zhang [mailto:haiyangz@microsoft.com]
> Sent: Monday, January 13, 2014 7:21 PM
> To: FlorianSchandinat@gmx.de; akpm@linux-foundation.org; linux-
> fbdev@vger.kernel.org
> Cc: Haiyang Zhang; KY Srinivasan; olaf@aepfle.de; jasowang@redhat.com;
> linux-kernel@vger.kernel.org; driverdev-devel@linuxdriverproject.org
> Subject: [PATCH] hyperv_fb: Add screen refresh after pause/resume
> operation
> 
> This is necessary because after VM is pause/resumed, some portion of the
> screen may need refresh.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
> ---

Hi Tomi and Andrew,

This patch has been submitted for a while. Do I need to re-submit it, or make
any changes?

Thanks,
- Haiyang

