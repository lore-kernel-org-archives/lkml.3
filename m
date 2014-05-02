Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662AbaEBTas (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 15:30:48 -0400
Received: from mail-sn2on0218.outbound.o365filtering.com ([157.56.87.218]:57071
	"EHLO na01-sn2-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750877AbaEBTaq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 15:30:46 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: David Miller <davem@davemloft.net>
CC: "jim.epost@gmail.com" <jim.epost@gmail.com>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: randconfig build error with next-20140502, in
 drivers/net/hyperv/netvsc_drv.c
Thread-Topic: randconfig build error with next-20140502, in
 drivers/net/hyperv/netvsc_drv.c
Thread-Index: AQHPZg5VELXjQQ2rFUCGAjzcri4hopstWxlwgADFAYD//41gwA==
Date: Fri, 2 May 2014 19:30:25 +0000
Message-ID: <23526aafab1c4c3a984240bb56b38a19@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <CA+r1ZhhAdRwEFE3u4E1QQiCSa6Cz5Onhy1iVJHhzB4dUiEOL4g@mail.gmail.com>
	<91a4eac99889460f91f619385208cbca@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
 <20140502.151927.359156056899842119.davem@davemloft.net>
In-Reply-To: <20140502.151927.359156056899842119.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.159.99;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(377454003)(51704005)(13464003)(164054003)(189002)(199002)(56776002)(51856002)(97336001)(59766002)(56816006)(50986002)(85852003)(97186001)(87936001)(76796001)(76786001)(95666003)(54316003)(47976003)(47736002)(63696004)(65816002)(19580395003)(44976005)(95416001)(2656002)(90146001)(81542001)(81342001)(6806004)(93516002)(2009001)(93136001)(81686001)(92566001)(86612001)(94946001)(84676001)(97756001)(83072002)(97736001)(47446003)(46102001)(87266001)(74662001)(77982001)(50466002)(31966008)(76482001)(74502001)(66066001)(69226001)(80022001)(47776003)(94316002)(20776003)(4396001)(98676001)(46406003)(53806002)(85306002)(79102001)(23726002)(99396002)(54356002)(83322001)(80976001)(81816001)(19580405001)(49866002)(74706001)(33646001)(74366001)(74876001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUSR01MB603;H:hybrid.exchange.microsoft.com;FPR:;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Exchange-Antispam-Report-Test: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 019919A9E4
X-OriginatorOrg: msft.ccsctp.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net]
> Sent: Friday, May 2, 2014 3:19 PM
> To: Haiyang Zhang
> Cc: jim.epost@gmail.com; sfr@canb.auug.org.au; linux-
> next@vger.kernel.org; linux-kernel@vger.kernel.org; KY Srinivasan;
> devel@linuxdriverproject.org; netdev@vger.kernel.org
> Subject: Re: randconfig build error with next-20140502, in
> drivers/net/hyperv/netvsc_drv.c
> 
> From: Haiyang Zhang <haiyangz@microsoft.com>
> Date: Fri, 2 May 2014 14:42:06 +0000
> 
> > real_num_rx_queues is defined in "include/linux/netdevice.h":
> > It requires CONFIG_SYSFS flag, which is enabled by default, but not
> set in
> > your config file.
> >
> > Could you use default config and add hyperv drivers, then try again?
> 
> You must fix your driver to compile successfully under all possible
> configuration combinations, not just the ones which are convenient
> for you to support.

OK, I'll look into this.

Thanks,
- Haiyang

