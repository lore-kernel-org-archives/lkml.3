Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929AbaEGVwc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 17:52:32 -0400
Received: from mail-by1on0157.outbound.o365filtering.com ([207.46.101.157]:42309
	"EHLO na01-by1-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752910AbaEGVw3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 17:52:29 -0400
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
Thread-Index: AQHPZg5VELXjQQ2rFUCGAjzcri4hopstWxlwgADFAYCAB5BuEA==
Date: Wed, 7 May 2014 21:52:08 +0000
Message-ID: <51b5e93ef78c405dba1d0af5a059a823@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
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
X-Forefront-Antispam-Report: CIP:131.107.159.99;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(13464003)(377454003)(164054003)(51704005)(199002)(189002)(76482001)(74706001)(95666003)(97756001)(76786001)(97186001)(50466002)(97736001)(97336001)(74876001)(2009001)(95416001)(83072002)(23726002)(76796001)(86612001)(98676001)(85852003)(6806004)(64706001)(46102001)(19580395003)(19580405001)(44976005)(47776003)(90146001)(20776003)(74366001)(83322001)(87936001)(74502001)(74662001)(93136001)(66066001)(92566001)(80022001)(81686001)(31966008)(4396001)(68736004)(77982001)(81542001)(79102001)(81342001)(81816001)(84676001)(46406003)(56816006)(47976003)(56776002)(69226001)(51856002)(50986002)(65816002)(63696004)(93516002)(47736002)(59766002)(54356002)(47446003)(33646001)(87266001)(94946001)(99396002)(94316002)(2656002)(49866002)(53806002)(85306002)(54316003)(21056001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2SR01MB604;H:hybrid.exchange.microsoft.com;FPR:;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Exchange-Antispam-Report-Test: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 0204F0BDE2
X-OriginatorOrg: msft.ccsctp.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net]
> Sent: Friday, May 2, 2014 3:19 PM
> To: Haiyang Zhang
> Cc: jim.epost@gmail.com; sfr@canb.auug.org.au; linux-next@vger.kernel.org;
> linux-kernel@vger.kernel.org; KY Srinivasan; devel@linuxdriverproject.org;
> netdev@vger.kernel.org
> Subject: Re: randconfig build error with next-20140502, in
> drivers/net/hyperv/netvsc_drv.c
> 
> From: Haiyang Zhang <haiyangz@microsoft.com>
> Date: Fri, 2 May 2014 14:42:06 +0000
> 
> > real_num_rx_queues is defined in "include/linux/netdevice.h":
> > It requires CONFIG_SYSFS flag, which is enabled by default, but not
> > set in your config file.
> >
> > Could you use default config and add hyperv drivers, then try again?
> 
> You must fix your driver to compile successfully under all possible configuration
> combinations, not just the ones which are convenient for you to support.

I have submitted a patch to support compiling it without CONFIG_SYSFS flag.

Thanks,
- Haiyang
