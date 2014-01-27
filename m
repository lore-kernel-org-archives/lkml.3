Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbaA0QVa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 11:21:30 -0500
Received: from na01-sn2-obe.ptr.o365filtering.com ([157.55.158.26]:51062 "EHLO
	na01-sn2-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753349AbaA0QV3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 11:21:29 -0500
X-Greylist: delayed 926 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Jan 2014 11:21:28 EST
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Jason Wang <jasowang@redhat.com>, KY Srinivasan <kys@microsoft.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net] net: hyperv: initialize link status correctly
Thread-Topic: [PATCH net] net: hyperv: initialize link status correctly
Thread-Index: AQHPGzHnWaLYcqJerkGAfpbTjomwWZqYvHbg
Date: Mon, 27 Jan 2014 16:05:03 +0000
Message-ID: <366785442d3b42d593f3c5df3f867ddd@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1390807854-4469-1-git-send-email-jasowang@redhat.com>
In-Reply-To: <1390807854-4469-1-git-send-email-jasowang@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.159.99;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(199002)(189002)(51704005)(377454003)(164054003)(13464003)(54316002)(56776001)(76482001)(74706001)(93516002)(49866001)(80976001)(93136001)(76796001)(59766001)(77982001)(47976001)(63696002)(20776003)(47776003)(1511001)(79102001)(74876001)(76786001)(50466002)(94316002)(81686001)(81816001)(74366001)(4396001)(50986001)(47736001)(51856001)(47446002)(31966008)(44976005)(74662001)(19580405001)(19580395003)(23726002)(53806001)(54356001)(2201001)(92566001)(56816005)(90146001)(83072002)(85852003)(85306002)(46102001)(2656002)(87266001)(6806004)(33646001)(74502001)(81542001)(83322001)(46406003)(87936001)(69226001)(65816001)(66066001)(80022001)(81342001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:CH1SR01MB600;H:hybrid.exchange.microsoft.com;CLIP:131.107.159.99;FPR:BC0DFB52.D12ADDA.45703F5F.F0E308FC.201A6;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Forefront-PRVS: 0104247462
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Jason Wang [mailto:jasowang@redhat.com]
> Sent: Monday, January 27, 2014 2:31 AM
> To: KY Srinivasan; Haiyang Zhang; devel@linuxdriverproject.org;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Cc: Jason Wang
> Subject: [PATCH net] net: hyperv: initialize link status correctly
> 
> Call netif_carrier_on() after register_device(). Otherwise it won't work since
> the device was still in NETREG_UNINITIALIZED state.
> 
> Fixes a68f9614614749727286f675d15f1e09d13cb54a
> (hyperv: Fix race between probe and open calls)
> 
> Cc: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: K. Y. Srinivasan <kys@microsoft.com>
> Reported-by: Di Nie <dnie@redhat.com>
> Tested-by: Di Nie <dnie@redhat.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---

I'm working on a fix for this, and will submit it soon.

Thanks,
- Haiyang


