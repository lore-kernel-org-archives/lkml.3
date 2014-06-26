Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280AbaFZO4N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 10:56:13 -0400
Received: from na01-by1-obe.ptr.o365filtering.com ([64.4.22.89]:18255 "EHLO
	na01-by1-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751765AbaFZO4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 10:56:10 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Olaf Hering <olaf@aepfle.de>
CC: Greg KH <greg@kroah.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH net-next] hyperv: Add handler for
 RNDIS_STATUS_NETWORK_CHANGE event
Thread-Topic: [PATCH net-next] hyperv: Add handler for
 RNDIS_STATUS_NETWORK_CHANGE event
Thread-Index: AQHPjB+WQKkwvkUXekGWoyJ+QmEz5Zt55UEAgAAEPICAADyUMIAEqgwA///ZfgCAAH5ugP//tltAgAB+poD//6PcsACSRsmAAAHL1dA=
Date: Thu, 26 Jun 2014 14:55:11 +0000
Message-ID: <072cf0ff85474ca8af2c3930f822ecad@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1403228076-7596-1-git-send-email-haiyangz@microsoft.com>
 <20140620045704.GA4850@aepfle.de> <20140620051213.GA9960@kroah.com>
 <ff458d1b896d4a70a32fa7709911274c@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
 <20140623080242.GA16924@aepfle.de>
 <06b508cbb6b949f4b3e13e7797948e56@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
 <20140623131723.GA7026@aepfle.de>
 <5fb9ddebb68d456ab87979b5cc3830ec@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
 <20140623162705.GA5957@aepfle.de>
 <4ee8be5360a44b5abfa6df871ec45527@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
 <20140626084539.GA32471@aepfle.de>
In-Reply-To: <20140626084539.GA32471@aepfle.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.59.235.233]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.159.99;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(24454002)(51704005)(189002)(199002)(377454003)(13464003)(51914003)(64706001)(47776003)(20776003)(93886003)(66066001)(80022001)(79102001)(81542001)(99396002)(44976005)(107046002)(92566001)(46102001)(2656002)(6806004)(83322001)(23676002)(97736001)(85852003)(83072002)(77982001)(87936001)(19580395003)(19580405001)(2009001)(84676001)(68736004)(81342001)(4396001)(21056001)(85326001)(86612001)(54356999)(50986999)(106466001)(77096999)(76176999)(31966008)(74662001)(33646001)(76482001)(74502001)(50466002)(106116001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2SR01MB594;H:hybrid.exchange.microsoft.com;FPR:;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02543CD7CD
X-OriginatorOrg: msft.ccsctp.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5QEuKYl018399



> -----Original Message-----
> From: Olaf Hering [mailto:olaf@aepfle.de]
> Sent: Thursday, June 26, 2014 4:46 AM
> To: Haiyang Zhang
> Cc: Greg KH; netdev@vger.kernel.org; jasowang@redhat.com; driverdev-
> devel@linuxdriverproject.org; linux-kernel@vger.kernel.org;
> davem@davemloft.net
> Subject: Re: [PATCH net-next] hyperv: Add handler for
> RNDIS_STATUS_NETWORK_CHANGE event
> 
> On Mon, Jun 23, Haiyang Zhang wrote:
> 
> > Yes, there is a link down/up event from the host, we currently call
> > netif_carrier_off() / netif_carrier_on() with these events. Will
> > hotplug scripts be triggered by netif_carrier_off/on? Where are the scripts
> located at (SLES)?
> 
> In /etc/sysconfig/network/ifcfg-eth0 STARTMODE= should be set to "ifplugd",
> this will most likely fix this sort of setup.

Thanks for the info! I'll let our team know.

- Haiyang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
