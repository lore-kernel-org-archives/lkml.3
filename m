Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbaEBP0H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:26:07 -0400
Received: from mail-sn2on0225.outbound.o365filtering.com ([157.56.87.225]:40529
	"EHLO na01-sn2-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751968AbaEBP0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:26:05 -0400
X-Greylist: delayed 1702 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 May 2014 11:26:05 EDT
From: Haiyang Zhang <haiyangz@microsoft.com>
To: KY Srinivasan <kys@microsoft.com>, Jim Davis <jim.epost@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        netdev <netdev@vger.kernel.org>
Subject: RE: randconfig build error with next-20140502, in
 drivers/net/hyperv/netvsc_drv.c
Thread-Topic: randconfig build error with next-20140502, in
 drivers/net/hyperv/netvsc_drv.c
Thread-Index: AQHPZg5VELXjQQ2rFUCGAjzcri4hopstWxlwgAB8gQD//5HAEA==
Date: Fri, 2 May 2014 15:25:56 +0000
Message-ID: <9847b18e41ed493daa61a1b5a9c1b7e8@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <CA+r1ZhhAdRwEFE3u4E1QQiCSa6Cz5Onhy1iVJHhzB4dUiEOL4g@mail.gmail.com>
 <91a4eac99889460f91f619385208cbca@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
 <f49938e3920d4e5e9088ccd1de92f69b@BY2PR03MB299.namprd03.prod.outlook.com>
In-Reply-To: <f49938e3920d4e5e9088ccd1de92f69b@BY2PR03MB299.namprd03.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.159.99;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(189002)(199002)(164054003)(13464003)(377454003)(51704005)(19580405001)(97336001)(95416001)(31966008)(50466002)(97186001)(74662001)(95666003)(66066001)(19580395003)(86612001)(80022001)(83322001)(85852003)(94946001)(46102001)(6806004)(97736001)(33646001)(69226001)(83072002)(74706001)(20776003)(47776003)(80976001)(79102001)(4396001)(76482001)(74502001)(1511001)(74876001)(74366001)(44976005)(81816001)(77982001)(50986002)(47446003)(54316003)(53806002)(85306002)(94316002)(87266001)(98676001)(23676002)(84676001)(51856002)(49866002)(56816006)(59766002)(47736002)(81686001)(76786001)(81342001)(93516002)(76796001)(90146001)(47976003)(2656002)(54356002)(87936001)(93136001)(99396002)(56776002)(63696004)(65816002)(92566001)(2009001)(81542001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2SR01MB592;H:hybrid.exchange.microsoft.com;FPR:;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Exchange-Antispam-Report-Test: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 019919A9E4
X-OriginatorOrg: msft.ccsctp.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s42FQIHO020565



> -----Original Message-----
> From: KY Srinivasan
> Sent: Friday, May 2, 2014 11:00 AM
> To: Haiyang Zhang; Jim Davis; Stephen Rothwell; linux-next; linux-kernel;
> devel@linuxdriverproject.org; netdev
> Subject: RE: randconfig build error with next-20140502, in
> drivers/net/hyperv/netvsc_drv.c
> 
> 
> 
> > -----Original Message-----
> > From: Haiyang Zhang
> > Sent: Friday, May 2, 2014 7:42 AM
> > To: Jim Davis; Stephen Rothwell; linux-next; linux-kernel; KY
> Srinivasan;
> > devel@linuxdriverproject.org; netdev
> > Subject: RE: randconfig build error with next-20140502, in
> > drivers/net/hyperv/netvsc_drv.c
> >
> >
> >
> > > -----Original Message-----
> > > From: Jim Davis [mailto:jim.epost@gmail.com]
> > > Sent: Friday, May 2, 2014 9:56 AM
> > > To: Stephen Rothwell; linux-next; linux-kernel; KY Srinivasan;
> Haiyang
> > > Zhang; devel@linuxdriverproject.org; netdev
> > > Subject: randconfig build error with next-20140502, in
> > > drivers/net/hyperv/netvsc_drv.c
> > >
> > > Building with the attached random configuration file,
> > >
> > > drivers/net/hyperv/netvsc_drv.c: In function â€˜netvsc_recv_callbackâ€™:
> > > drivers/net/hyperv/netvsc_drv.c:648:11: error: â€˜struct net_deviceâ€™
> has
> > > no member  named â€˜real_num_rx_queuesâ€™
> > >         net->real_num_rx_queues);
> > >            ^
> > > In file included from drivers/net/hyperv/netvsc_drv.c:26:0:
> > > drivers/net/hyperv/netvsc_drv.c: In function â€˜netvsc_probeâ€™:
> > > drivers/net/hyperv/netvsc_drv.c:832:32: error: â€˜struct net_deviceâ€™
> has
> > > no member named â€˜real_num_rx_queuesâ€™
> > >     net->real_num_tx_queues, net->real_num_rx_queues);
> > >                                 ^
> > > include/linux/device.h:1080:58: note: in definition of macro
> â€˜dev_infoâ€™
> > >  #define dev_info(dev, fmt, arg...) _dev_info(dev, fmt, ##arg)
> > >                                                           ^
> > > make[3]: *** [drivers/net/hyperv/netvsc_drv.o] Error 1
> >
> > real_num_rx_queues is defined in "include/linux/netdevice.h":
> > It requires CONFIG_SYSFS flag, which is enabled by default, but not
> set in
> > your config file.
> >
> > Could you use default config and add hyperv drivers, then try again?
> 
> Haiyang,
> 
> That is the point - the code must compile correctly for all possible
> configurations.
> You will want to protect the dependencies appropriately.
> 
OK, I'll look into this.

Thanks,
- Haiyang

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
