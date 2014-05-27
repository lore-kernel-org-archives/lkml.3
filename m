Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961AbaE0PcX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 11:32:23 -0400
Received: from na01-sn2-obe.ptr.o365filtering.com ([157.55.158.27]:58713 "EHLO
	na01-sn2-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752885AbaE0PcT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 11:32:19 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: David Miller <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Bernhard Walle <bernhard@bwalle.de>, KY Srinivasan <kys@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: request for backporting commit 99d3016de4 to 3.14 (stable)
Thread-Topic: request for backporting commit 99d3016de4 to 3.14 (stable)
Thread-Index: Ac95wLH85jVhEH9OSHmOIycNJ9BqKQ==
Date: Tue, 27 May 2014 15:32:08 +0000
Message-ID: <7788d6445c894835bf2e1dc64a77e797@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.159.100;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(189002)(199002)(164054003)(98676001)(81342001)(90146001)(46406003)(74662001)(94946001)(2656002)(81816001)(74502001)(81542001)(95416001)(21056001)(76786001)(94316002)(76796001)(86612001)(83072002)(6806004)(92566001)(97736001)(23726002)(68736004)(81686001)(74366001)(50466002)(51856002)(79102001)(85852003)(76176001)(2009001)(4396001)(83322001)(31966008)(97756001)(56776002)(47736002)(47776003)(20776003)(99396002)(44976005)(69226001)(50986002)(46102001)(54356002)(47976003)(63696004)(47446003)(97336001)(59766002)(65816002)(15975445006)(49866002)(54316003)(76482001)(53806002)(56816006)(19580395003)(64706001)(97186001)(85306002)(77982001)(93516002)(66066001)(80022001)(93136001)(87936001)(84676001)(87266001)(95666003)(575784001)(74876001)(33646001)(74706001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2SR01MB593;H:hybrid.exchange.microsoft.com;FPR:;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Exchange-Antispam-Report-Test: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 02243C58C6
X-OriginatorOrg: msft.ccsctp.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave, 

I found this commit is in stable tree already. Will it be backported into 3.14 as well? Otherwise, can we request it to be included into the next 3.14 update?

https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/drivers/net/hyperv?id=99d3016de4f2a29635f5382b0e9bd0e5f2151487
	hyperv: Change the receive buffer size for legacy hosts

Thanks,
- Haiyang
