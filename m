Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822AbaJOAlc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 20:41:32 -0400
Received: from na01-sn2-obe.ptr.o365filtering.com ([157.55.158.29]:54092 "EHLO
	na01-sn2-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755517AbaJOAla convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 20:41:30 -0400
X-Greylist: delayed 10429 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Oct 2014 20:41:30 EDT
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Haiyang Zhang <haiyangz@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: KY Srinivasan <kys@microsoft.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
Subject: RE: [PATCH net-next,v2] hyperv: Add handling of IP header with option
 field in netvsc_set_hash()
Thread-Topic: [PATCH net-next,v2] hyperv: Add handling of IP header with
 option field in netvsc_set_hash()
Thread-Index: AQHP6BB2vlLAj4MIqUq28P5iYFD9BZwwUP9A
Date: Wed, 15 Oct 2014 00:41:19 +0000
Message-ID: <1bacf9599d0148bf8517e2193f8f7e9c@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1413317117-28678-1-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1413317117-28678-1-git-send-email-haiyangz@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.159.100;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(377454003)(189002)(13464003)(199003)(1511001)(85852003)(99396003)(120916001)(20776003)(85306004)(97756001)(47776003)(64706001)(84676001)(44976005)(76482002)(2201001)(108616004)(107046002)(66066001)(6806004)(68736004)(92566001)(23726002)(21056001)(31966008)(76176999)(87936001)(50466002)(2656002)(97736003)(106466001)(2501002)(86612001)(46102003)(80022003)(77096999)(54356999)(2421001)(2561002)(106116001)(4396001)(19580405001)(46406003)(2009001)(19580395003)(33646002)(50986999)(142933001)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2SR01MB597;H:hybrid.exchange.microsoft.com;FPR:;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2SR01MB597;
X-Forefront-PRVS: 0365C0E14B
X-OriginatorOrg: msft.ccsctp.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Haiyang Zhang [mailto:haiyangz@microsoft.com]
> Sent: Tuesday, October 14, 2014 4:05 PM
> To: davem@davemloft.net; netdev@vger.kernel.org
> Cc: Haiyang Zhang; KY Srinivasan; olaf@aepfle.de; jasowang@redhat.com;
> linux-kernel@vger.kernel.org; driverdev-devel@linuxdriverproject.org
> Subject: [PATCH net-next,v2] hyperv: Add handling of IP header with
> option field in netvsc_set_hash()
> 

This is a duplicate of a patch submitted earlier today. Please ignore.


