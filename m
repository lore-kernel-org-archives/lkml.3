Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741AbaDCPRv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 11:17:51 -0400
Received: from na01-sn2-obe.ptr.o365filtering.com ([157.55.158.28]:32708 "EHLO
	na01-sn2-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752702AbaDCPRl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 11:17:41 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: David Miller <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
Subject: RE: [PATCH net-next,v4] hyperv: Add support for virtual Receive
 Side Scaling (vRSS)
Thread-Topic: [PATCH net-next,v4] hyperv: Add support for virtual Receive
 Side Scaling (vRSS)
Thread-Index: AQHPT08TqDh0JDv7Z0CBRIv4QyTrFpsAdbkA//+KlRA=
Date: Thu, 3 Apr 2014 15:17:28 +0000
Message-ID: <aa48898a5b084977b7b9ef8aa1588a43@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1396541134-9588-1-git-send-email-haiyangz@microsoft.com>
 <20140403.111508.1416100875090509051.davem@davemloft.net>
In-Reply-To: <20140403.111508.1416100875090509051.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.59.235.233]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.159.99;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(13464003)(51704005)(377454003)(164054003)(189002)(199002)(4396001)(33646001)(47736001)(6806004)(47976001)(97756001)(46102001)(76482001)(2009001)(54356001)(69226001)(50986001)(74876001)(99396002)(23726002)(53806001)(51856001)(87936001)(87266001)(2656002)(81342001)(49866001)(74662001)(94946001)(97736001)(74366001)(50466002)(97186001)(56816005)(81816001)(81686001)(83072002)(47446002)(86612001)(74502001)(31966008)(93516002)(56776001)(59766001)(77982001)(90146001)(80976001)(92566001)(74706001)(54316002)(46406003)(81542001)(98676001)(19580405001)(44976005)(83322001)(85306002)(65816001)(19580395003)(63696002)(80022001)(97336001)(94316002)(95666003)(79102001)(66066001)(95416001)(84676001)(85852003)(93136001)(47776003)(76796001)(20776003)(76786001)(142933001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2SR01MB592;H:hybrid.exchange.microsoft.com;FPR:76754B9E.3CE3040A.3174B97C.90E5FB3B.201F6;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Exchange-Organization-AntiSpam-Internal: BULK:None;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:(2001)
X-Forefront-PRVS: 0170DAF08C
X-OriginatorOrg: msft.ccsctp.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net]
> Sent: Thursday, April 3, 2014 11:15 AM
> To: Haiyang Zhang
> Cc: netdev@vger.kernel.org; KY Srinivasan; olaf@aepfle.de;
> jasowang@redhat.com; linux-kernel@vger.kernel.org; driverdev-
> devel@linuxdriverproject.org
> Subject: Re: [PATCH net-next,v4] hyperv: Add support for virtual Receive Side
> Scaling (vRSS)
> 
> From: Haiyang Zhang <haiyangz@microsoft.com>
> Date: Thu,  3 Apr 2014 09:05:34 -0700
> 
> > This feature allows multiple channels to be used by each virtual NIC.
> > It is available on Hyper-V host 2012 R2.
> >
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
> 
> I announced on netdev the other day that the merge window is open and I'm
> not accepting patches for new features until the net-next tree is open again.

I see. (I found the dependency was merged in, so I was re-submitting... )
I will wait for the net-next tree opening.

Thanks,
- Haiyang
