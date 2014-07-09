Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223AbaGISJL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 14:09:11 -0400
Received: from na01-sn2-obe.ptr.o365filtering.com ([157.55.158.28]:20970 "EHLO
	na01-sn2-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752746AbaGISJI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 14:09:08 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Richard Weinberger <richard@nod.at>, KY Srinivasan <kys@microsoft.com>
CC: "sergei.shtylyov@cogentembedded.com" 
	<sergei.shtylyov@cogentembedded.com>,
        "romieu@fr.zoreil.com" <romieu@fr.zoreil.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3] hyperv: Add netpoll support
Thread-Topic: [PATCH v3] hyperv: Add netpoll support
Thread-Index: AQHPm4GQTC1PvAW20EWwE8/oqmwN9JuYCmNg
Date: Wed, 9 Jul 2014 18:08:51 +0000
Message-ID: <1773ae9702234a1d9e86ccf343c68c21@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1404915839-15940-1-git-send-email-richard@nod.at>
In-Reply-To: <1404915839-15940-1-git-send-email-richard@nod.at>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.159.100;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(199002)(189002)(377454003)(51704005)(13464003)(79102001)(80022001)(66066001)(81342001)(92566001)(1511001)(64706001)(47776003)(20776003)(74502001)(50466002)(106116001)(83072002)(85852003)(46406003)(50986999)(4396001)(107046002)(31966008)(44976005)(81542001)(2656002)(74662001)(23726002)(87936001)(83322001)(97736001)(19580395003)(21056001)(99396002)(54356999)(76176999)(77096999)(97756001)(19580405001)(84676001)(6806004)(33646001)(106466001)(86612001)(68736004)(46102001)(77982001)(76482001)(2009001)(108616002)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2SR01MB592;H:hybrid.exchange.microsoft.com;FPR:;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0267E514F9
X-OriginatorOrg: msft.ccsctp.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Richard Weinberger [mailto:richard@nod.at]
> Sent: Wednesday, July 9, 2014 10:24 AM
> To: KY Srinivasan; Haiyang Zhang
> Cc: sergei.shtylyov@cogentembedded.com; romieu@fr.zoreil.com;
> devel@linuxdriverproject.org; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; Richard Weinberger
> Subject: [PATCH v3] hyperv: Add netpoll support
> 
> In order to have at least a netconsole to debug kernel issues on
> Windows Azure this patch implements netpoll support.
> Sending packets is easy, netvsc_start_xmit() does already everything
> needed.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
Acked-by: Haiyang Zhang <haiyangz@microsoft.com>

Thanks.
