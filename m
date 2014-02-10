Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820AbaBJUYO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 15:24:14 -0500
Received: from na01-sn2-obe.ptr.o365filtering.com ([157.55.158.29]:14877 "EHLO
	na01-sn2-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754190AbaBJUYJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 15:24:09 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Haiyang Zhang <haiyangz@microsoft.com>,
        "FlorianSchandinat@gmx.de" <FlorianSchandinat@gmx.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
CC: KY Srinivasan <kys@microsoft.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
Subject: RE: [PATCH] hyperv_fb: Add screen refresh after pause/resume
 operation
Thread-Topic: [PATCH] hyperv_fb: Add screen refresh after pause/resume
 operation
Thread-Index: AQHPELevFwzIeA4Y7UO6r7w197ycAJqvGgbg
Date: Mon, 10 Feb 2014 20:23:42 +0000
Message-ID: <d2240dee850c458ca642f20cf3b9f858@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
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
X-Forefront-Antispam-Report: CIP:131.107.147.100;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(13464003)(51704005)(199002)(189002)(164054003)(377454003)(81542001)(90146001)(92566001)(83072002)(2201001)(81342001)(56816005)(85852003)(76786001)(76796001)(56776001)(54316002)(23726002)(46406003)(65816001)(80022001)(2656002)(87266001)(76482001)(4396001)(74502001)(47446002)(31966008)(46102001)(66066001)(74662001)(79102001)(47736001)(1511001)(49866001)(47976001)(87936001)(54356001)(63696002)(47776003)(53806001)(20776003)(51856001)(50986001)(59766001)(77982001)(69226001)(6806004)(85306002)(74876001)(95416001)(93136001)(81686001)(94316002)(74366001)(86612001)(50466002)(80976001)(33646001)(93516002)(81816001)(94946001)(19580405001)(74706001)(44976005)(83322001)(95666001)(19580395003)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2SR01MB594;H:hybrid.exchange.microsoft.com;CLIP:131.107.147.100;FPR:B42E7552.1C73BC0A.8BFB2DC7.F06D3B1D.2017A;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Forefront-PRVS: 0118CD8765
X-OriginatorOrg: microsoft.com
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
> Subject: [PATCH] hyperv_fb: Add screen refresh after pause/resume operation
> 
> This is necessary because after VM is pause/resumed, some portion of the
> screen may need refresh.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
This was submitted before the tree re-opened. Is it still being considered?

Thanks,
- Haiyang

