Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726AbaDQR12 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 13:27:28 -0400
Received: from [157.55.158.25] ([157.55.158.25]:22030 "EHLO
	na01-sn2-obe.outbound.o365filtering.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751430AbaDQR1Q convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 13:27:16 -0400
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
Thread-Index: AQHPUo9hwVfmBzXAgEOnJHwk6QrgC5sG8p4AgA8rcRA=
Date: Thu, 17 Apr 2014 17:25:31 +0000
Message-ID: <4d82d2d3960447cfade67174b03ec877@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1396898623-31667-1-git-send-email-haiyangz@microsoft.com>
 <20140407.144258.2113005286706932770.davem@davemloft.net>
In-Reply-To: <20140407.144258.2113005286706932770.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.59.235.233]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.159.100;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(377454003)(13464003)(51704005)(164054003)(189002)(199002)(53806002)(54356002)(93516002)(47446003)(50986002)(98676001)(65816002)(63696004)(47776003)(87266001)(93136001)(76482001)(86612001)(87936001)(74876001)(85306002)(76786001)(59766002)(95416001)(95666003)(47736002)(74366001)(51856002)(56816006)(94946001)(94316002)(90146001)(76796001)(56776002)(47976003)(49866002)(54316003)(20776003)(46102001)(2656002)(77982001)(66066001)(80022001)(97736001)(85852003)(83072002)(2009001)(97756001)(84676001)(79102001)(97336001)(99396002)(97186001)(44976005)(19580405001)(19580395003)(83322001)(6806004)(80976001)(31966008)(81816001)(81686001)(33646001)(4396001)(92566001)(74706001)(23726002)(50466002)(74662001)(46406003)(69226001)(81542001)(81342001)(74502001)(142933001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2SR01MB595;H:hybrid.exchange.microsoft.com;FPR:;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Exchange-Organization-AntiSpam-Internal: BULK:None;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 01842C458A
X-OriginatorOrg: msft.ccsctp.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net]
> Sent: Monday, April 7, 2014 2:43 PM
> To: Haiyang Zhang
> Cc: netdev@vger.kernel.org; KY Srinivasan; olaf@aepfle.de;
> jasowang@redhat.com; linux-kernel@vger.kernel.org; driverdev-
> devel@linuxdriverproject.org
> Subject: Re: [PATCH net-next,v4] hyperv: Add support for virtual Receive Side
> Scaling (vRSS)
> 
> 
> The net-next tree is not open yet, I will announce when it is and you can submit
> net-next targetted patches.

Dave,

Is the net-next tree open now? 
(I haven't seen your announcement, but I saw some patches for net-next are under review.)

Thanks,
- Haiyang
