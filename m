Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816AbaF1MxJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 08:53:09 -0400
Received: from na01-by1-obe.ptr.o365filtering.com ([64.4.22.93]:15632 "EHLO
	na01-by1-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752704AbaF1MxE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 08:53:04 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Fabian Frederick <fabf@skynet.be>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: KY Srinivasan <kys@microsoft.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: [PATCH 1/1] drivers/net/hyperv/netvsc.c: remove unnecessary
 null test before kfree
Thread-Topic: [PATCH 1/1] drivers/net/hyperv/netvsc.c: remove unnecessary
 null test before kfree
Thread-Index: AQHPkr0hEqbVXgdUhE+l/ET32s4++ZuGeGZA
Date: Sat, 28 Jun 2014 12:52:28 +0000
Message-ID: <dfce647599ed410db841878cd1dc8662@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1403951793-31069-1-git-send-email-fabf@skynet.be>
In-Reply-To: <1403951793-31069-1-git-send-email-fabf@skynet.be>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.147.100;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(13464003)(51704005)(189002)(199002)(377454003)(2009001)(33646001)(86612001)(97756001)(44976005)(74662001)(74502001)(97736001)(6806004)(83072002)(23726002)(99396002)(21056001)(85852003)(19580395003)(68736004)(83322001)(92566001)(31966008)(19580405001)(84676001)(4396001)(76482001)(81542001)(77982001)(64706001)(80022001)(106466001)(66066001)(79102001)(50466002)(20776003)(47776003)(106116001)(87936001)(50986999)(77096999)(76176999)(2656002)(46102001)(46406003)(81342001)(107046002)(54356999)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2SR01MB597;H:hybrid.exchange.microsoft.com;FPR:;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0256C18696
X-OriginatorOrg: msft.ccsctp.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Fabian Frederick [mailto:fabf@skynet.be]
> Sent: Saturday, June 28, 2014 6:37 AM
> To: linux-kernel@vger.kernel.org
> Cc: Fabian Frederick; KY Srinivasan; Haiyang Zhang;
> devel@linuxdriverproject.org
> Subject: [PATCH 1/1] drivers/net/hyperv/netvsc.c: remove unnecessary
> null test before kfree
> 
> Fix checkpatch warning:
> WARNING: kfree(NULL) is safe this check is probably not required
> 
> Cc: "K. Y. Srinivasan" <kys@microsoft.com>
> Cc: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: devel@linuxdriverproject.org
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>

Also, please add netdev@vger.kernel.org to the recipients.
Thanks.
