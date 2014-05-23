Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751507AbaEWTIA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 15:08:00 -0400
Received: from na01-sn2-obe.ptr.o365filtering.com ([157.55.158.25]:28182 "EHLO
	na01-sn2-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751056AbaEWTH6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 15:07:58 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: David Miller <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
Subject: RE: [PATCH net-next] Add hash value into RNDIS Per-packet info
Thread-Topic: [PATCH net-next] Add hash value into RNDIS Per-packet info
Thread-Index: AQHPdScxN2x9yztw/kacAt3uZPgG35tO+qSA//+K6dA=
Date: Fri, 23 May 2014 18:52:29 +0000
Message-ID: <c70268824a95436aab3e3e8c0bbf4201@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1400702139-29280-1-git-send-email-haiyangz@microsoft.com>
 <20140523.145001.2140056621716323006.davem@davemloft.net>
In-Reply-To: <20140523.145001.2140056621716323006.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.159.99;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(199002)(189002)(377454003)(164054003)(51704005)(13464003)(81542001)(31966008)(74502001)(74662001)(74706001)(50986002)(81342001)(51856002)(47736002)(54356002)(54316003)(49866002)(65816002)(63696004)(47976003)(59766002)(56816006)(56776002)(47446003)(53806002)(90146001)(23726002)(87936001)(2656002)(50466002)(4396001)(74876001)(76796001)(76786001)(85852003)(83072002)(97736001)(92566001)(6806004)(47776003)(79102001)(97336001)(20776003)(83322001)(87266001)(97186001)(64706001)(93516002)(19580395003)(98676001)(46406003)(97756001)(2009001)(77982001)(69226001)(19580405001)(44976005)(80022001)(66066001)(94946001)(94316002)(76482001)(33646001)(95416001)(99396002)(86612001)(93136001)(81816001)(95666003)(85306002)(74366001)(84676001)(21056001)(81686001)(68736004)(46102001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2SR01MB594;H:hybrid.exchange.microsoft.com;FPR:;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Exchange-Antispam-Report-Test: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 0220D4B98D
X-OriginatorOrg: msft.ccsctp.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net]
> Sent: Friday, May 23, 2014 2:50 PM
> To: Haiyang Zhang
> Cc: netdev@vger.kernel.org; KY Srinivasan; olaf@aepfle.de;
> jasowang@redhat.com; linux-kernel@vger.kernel.org; driverdev-
> devel@linuxdriverproject.org
> Subject: Re: [PATCH net-next] Add hash value into RNDIS Per-packet info
> 
> From: Haiyang Zhang <haiyangz@microsoft.com>
> Date: Wed, 21 May 2014 12:55:39 -0700
> 
> > It passes the hash value as the RNDIS Per-packet info to the Hyper-V
> host,
> > so that the send completion notices can be spread across multiple
> channels.
> > MS-TFS: 140273
> >
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> 
> Applied, but please craft your Subject lines correctly in the future.
> 
> You did not specify a subsystem prefix, which in this case should
> have been something like "hyperv: "
> 
> Otherwise people scanning the commit log headers have no idea where
> your changes might be taking place.
> 
> I fixed it up this time for you.

Thank you for fixing it! I will do this in the future.

Thanks,
- Haiyang
