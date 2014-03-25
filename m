Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176AbaCYUig (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 16:38:36 -0400
Received: from na01-by1-obe.ptr.o365filtering.com ([64.4.22.87]:2154 "EHLO
	na01-by1-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755121AbaCYUid convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 16:38:33 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Haiyang Zhang <haiyangz@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: KY Srinivasan <kys@microsoft.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
Subject: RE: [PATCH net-next,v4] hyperv: Add support for virtual Receive
 Side Scaling (vRSS)
Thread-Topic: [PATCH net-next,v4] hyperv: Add support for virtual Receive
 Side Scaling (vRSS)
Thread-Index: AQHPRT7oyWtXlru1UE29zpPCw7NDQZrySCzQ
Date: Tue, 25 Mar 2014 20:37:43 +0000
Message-ID: <216cd74854414cfc9b338cab41a3d1a0@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1395434633-16771-1-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1395434633-16771-1-git-send-email-haiyangz@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: =?us-ascii?Q?CIP:131.107.159.99;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(3?=
 =?us-ascii?Q?77454003)(51704005)(13464003)(189002)(199002)(164054003)(567?=
 =?us-ascii?Q?76001)(54316002)(80976001)(76786001)(56816005)(81816001)(747?=
 =?us-ascii?Q?06001)(94946001)(95666003)(74876001)(4396001)(50986001)(5046?=
 =?us-ascii?Q?6002)(81686001)(6806004)(15975445006)(84676001)(47976001)(47?=
 =?us-ascii?Q?736001)(2201001)(92566001)(2656002)(87936001)(15202345003)(4?=
 =?us-ascii?Q?6102001)(87266001)(54356001)(97186001)(76482001)(76796001)(7?=
 =?us-ascii?Q?4366001)(19580395003)(83322001)(44976005)(97336001)(19580405?=
 =?us-ascii?Q?001)(90146001)(51856001)(49866001)(77982001)(33646001)(69226?=
 =?us-ascii?Q?001)(53806001)(95416001)(1511001)(83072002)(81342001)(977360?=
 =?us-ascii?Q?01)(93516002)(66066001)(46406003)(575784001)(94316002)(85852?=
 =?us-ascii?Q?003)(47776003)(81542001)(63696002)(2009001)(65816001)(319660?=
 =?us-ascii?Q?08)(74662001)(74502001)(47446002)(93136001)(20776003)(866120?=
 =?us-ascii?Q?01)(85306002)(97756001)(59766001)(79102001)(80022001)(986760?=
 =?us-ascii?Q?01)(23726002)(142933001)(24736002);DIR:OUT;SFP:1101;SCL:1;SR?=
 =?us-ascii?Q?VR:BY2SR01MB596;H:hybrid.exchange.microsoft.com;FPR:783E0C12?=
 =?us-ascii?Q?.3CC387CA.45747B5E.8066BBD9.201B9;PTR:InfoDomainNonexistent;?=
 =?us-ascii?Q?MX:1;A:1;LANG:en;?=
X-Exchange-Antispam-Report-Test: BULK:None;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:(2001)
X-Forefront-PRVS: 01613DFDC8
X-OriginatorOrg: msft.ccsctp.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Haiyang Zhang [mailto:haiyangz@microsoft.com]
> Sent: Friday, March 21, 2014 4:44 PM
> To: davem@davemloft.net; netdev@vger.kernel.org
> Cc: Haiyang Zhang; KY Srinivasan; olaf@aepfle.de; jasowang@redhat.com;
> linux-kernel@vger.kernel.org; driverdev-devel@linuxdriverproject.org
> Subject: [PATCH net-next,v4] hyperv: Add support for virtual Receive
> Side Scaling (vRSS)
> 
> This feature allows multiple channels to be used by each virtual NIC.
> It is available on Hyper-V host 2012 R2.
> 
> (It depends on this commit:
> Drivers: hv: vmbus: Support per-channel driver state
> http://git.kernel.org/cgit/linux/kernel/git/next/linux-
> next.git/commit/?id=8a7206a89f85c8439561b0eff85bb9440a2e97a9
> )

Hi Dave,

Do we know when the dependency (commit: 8a7206a89f) will be merged
into net-next tree?

Thanks,
- Haiyang
