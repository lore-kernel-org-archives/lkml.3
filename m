Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbaE0Phq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 11:37:46 -0400
Received: from na01-by1-obe.ptr.o365filtering.com ([64.4.22.93]:51232 "EHLO
	na01-by1-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752954AbaE0Phi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 11:37:38 -0400
X-Greylist: delayed 876 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 May 2014 11:37:38 EDT
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Bernhard Walle <bernhard@bwalle.de>, KY Srinivasan <kys@microsoft.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Regression in hyperv network driver in 3.14
Thread-Topic: Regression in hyperv network driver in 3.14
Thread-Index: AQHPeZxGJRl1VWGeqEeJD+5P/x00sptU5X0AgAAQRwD//5QZMA==
Date: Tue, 27 May 2014 15:22:37 +0000
Message-ID: <3ea04efb185c4b658c43b4d303f75fe1@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <20140527111003.GA2214@kepler.fritz.box>
 <25b90b45e3284715ab0ab00cb812a99f@BY2PR03MB299.namprd03.prod.outlook.com>
 <4370df7be3d8c3e6d53dad487527b234@bwalle.de>
In-Reply-To: <4370df7be3d8c3e6d53dad487527b234@bwalle.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.147.100;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(85644002)(199002)(189002)(377424004)(377454003)(51704005)(164054003)(13464003)(81342001)(81542001)(90146001)(76796001)(74662001)(74706001)(74502001)(31966008)(76786001)(74876001)(50986002)(54356002)(49866002)(65816002)(47736002)(53806002)(47446003)(54316003)(87936001)(4396001)(2656002)(50466002)(56816006)(85852003)(83072002)(47976003)(63696004)(56776002)(97736001)(92566001)(97186001)(59766002)(6806004)(23676002)(87266001)(79102001)(20776003)(95416001)(93516002)(97336001)(64706001)(83322001)(1511001)(47776003)(2009001)(77982001)(69226001)(19580405001)(44976005)(80022001)(66066001)(19580395003)(98676001)(94316002)(575784001)(33646001)(76482001)(94946001)(15975445006)(86612001)(51856002)(99396002)(85306002)(46102001)(68736004)(74366001)(84676001)(21056001)(81816001)(93136001)(95666003)(81686001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2SR01MB594;H:hybrid.exchange.microsoft.com;FPR:;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Exchange-Antispam-Report-Test: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 02243C58C6
X-OriginatorOrg: msft.ccsctp.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s4RFbssW023851



> -----Original Message-----
> From: Bernhard Walle [mailto:bernhard@bwalle.de]
> Sent: Tuesday, May 27, 2014 10:42 AM
> To: KY Srinivasan
> Cc: Haiyang Zhang; linux-kernel@vger.kernel.org
> Subject: RE: Regression in hyperv network driver in 3.14
> 
> Am 2014-05-27 15:43, schrieb KY Srinivasan:
> 
> >> Can I provide more information to track down the problem?
> >
> > This bug has been fixed upstream. The issue is with regards to the
> > older hosts (ws2008 r2) not
> > Being able to handle the larger receive buffer currently used.
> 
> Can you point me to the commit that fixed the problem? Woudln't that
> be something for -stable since the problem is still in 3.14.4.
> 

Yes, this commit is in stable tree:
https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/drivers/net/hyperv?id=99d3016de4f2a29635f5382b0e9bd0e5f2151487
	hyperv: Change the receive buffer size for legacy hosts

I will ask the maintainer, see if it will be in next 3.14 update as well.

Thanks,
- Haiyang

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
