Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133AbaFWUSG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 16:18:06 -0400
Received: from na01-by1-obe.ptr.o365filtering.com ([64.4.22.90]:8541 "EHLO
	na01-by1-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753812AbaFWUSE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 16:18:04 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: David Miller <davem@davemloft.net>
CC: "olaf@aepfle.de" <olaf@aepfle.de>, "greg@kroah.com" <greg@kroah.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next] hyperv: Add handler for
 RNDIS_STATUS_NETWORK_CHANGE event
Thread-Topic: [PATCH net-next] hyperv: Add handler for
 RNDIS_STATUS_NETWORK_CHANGE event
Thread-Index: AQHPjB+WQKkwvkUXekGWoyJ+QmEz5Zt55UEAgAAEPICAADyUMIAEqgwA///ZfgCAAH5ugP//tltAgAC9AwD//4w30A==
Date: Mon, 23 Jun 2014 20:17:39 +0000
Message-ID: <83e9c73eb6914fb59f88de7c8570017d@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <06b508cbb6b949f4b3e13e7797948e56@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
	<20140623131723.GA7026@aepfle.de>
	<5fb9ddebb68d456ab87979b5cc3830ec@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
 <20140623.131018.1349792926453695313.davem@davemloft.net>
In-Reply-To: <20140623.131018.1349792926453695313.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.159.99;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(199002)(189002)(51704005)(377454003)(164054003)(13464003)(77982001)(80022001)(81342001)(79102001)(81542001)(74502001)(46102001)(76482001)(47776003)(4396001)(20776003)(74662001)(31966008)(66066001)(64706001)(93886003)(99396002)(97756001)(2009001)(97736001)(50466002)(106116001)(50986999)(77096999)(54356999)(106466001)(76176999)(21056001)(68736004)(6806004)(83322001)(19580395003)(19580405001)(44976005)(84676001)(46406003)(85852003)(85326001)(33646001)(23726002)(2656002)(83072002)(86612001)(87936001)(92566001)(24736002)(106276001);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUSR01MB590;H:hybrid.exchange.microsoft.com;FPR:;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 025100C802
X-OriginatorOrg: msft.ccsctp.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net]
> Sent: Monday, June 23, 2014 4:10 PM
> To: Haiyang Zhang
> Cc: olaf@aepfle.de; greg@kroah.com; netdev@vger.kernel.org;
> jasowang@redhat.com; driverdev-devel@linuxdriverproject.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH net-next] hyperv: Add handler for
> RNDIS_STATUS_NETWORK_CHANGE event
> 
> From: Haiyang Zhang <haiyangz@microsoft.com>
> Date: Mon, 23 Jun 2014 16:09:59 +0000
> 
> > So, what's the equivalent or similar command to "network restart" on
> > SLES12? Could you update the command line for the usermodehelper when
> > porting this patch to SLES 12?
> 
> No, you are not going to keep the usermodehelper invocation in your driver
> please remove it.  It is absolutely inappropriate, and I strictly do not want to
> keep it in there because other people will copy it and then we'll have a real
> mess on our hands.

I'm working on it, and will have a patch to replace the usermodehelper soon.

Thanks,
- Haiyang

