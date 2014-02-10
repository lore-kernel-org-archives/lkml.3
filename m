Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931AbaBJP5s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 10:57:48 -0500
Received: from na01-by1-obe.ptr.o365filtering.com ([64.4.22.89]:9288 "EHLO
	na01-by1-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751831AbaBJP5r convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 10:57:47 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net] hyperv: Fix the carrier status setting
Thread-Topic: [PATCH net] hyperv: Fix the carrier status setting
Thread-Index: AQHPJfV8J3DMjAE27Umhag/05LGOWpquuEKA///sREA=
Date: Mon, 10 Feb 2014 15:57:12 +0000
Message-ID: <191b34a54dad423c875c05f084cb1021@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1391994478-25809-1-git-send-email-haiyangz@microsoft.com>
 <20140210090359.GQ26722@mwanda>
In-Reply-To: <20140210090359.GQ26722@mwanda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.159.99;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(54534003)(13464003)(51704005)(199002)(189002)(24454002)(164054003)(377454003)(90146001)(81542001)(92566001)(81342001)(83072002)(76796001)(76786001)(85852003)(23726002)(56816005)(46406003)(65816001)(56776001)(54316002)(80022001)(2656002)(87266001)(76482001)(4396001)(74502001)(47446002)(31966008)(46102001)(66066001)(74662001)(79102001)(47736001)(49866001)(47976001)(87936001)(54356001)(63696002)(47776003)(53806001)(20776003)(51856001)(50986001)(59766001)(77982001)(69226001)(6806004)(85306002)(74876001)(95416001)(93136001)(81686001)(50466002)(86612001)(74366001)(94316002)(80976001)(94946001)(81816001)(33646001)(93516002)(19580405001)(74706001)(83322001)(44976005)(19580395003)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2SR01MB594;H:hybrid.exchange.microsoft.com;CLIP:131.107.159.99;FPR:B85FCAF2.BC234F0A.FF7D2DCF.40E069E1.201C2;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Forefront-PRVS: 0118CD8765
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> Sent: Monday, February 10, 2014 4:04 AM
> To: Haiyang Zhang
> Cc: davem@davemloft.net; netdev@vger.kernel.org; olaf@aepfle.de;
> jasowang@redhat.com; driverdev-devel@linuxdriverproject.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH net] hyperv: Fix the carrier status setting
> 
> On Sun, Feb 09, 2014 at 05:07:58PM -0800, Haiyang Zhang wrote:
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
> 
> Changelog sucks.  What are the user visible effects of this bug?
> 
Without this patch, the "cat /sys/class/net/ethN/operstate" shows 
"unknown", and "ethtool ethN" shows "Link detected: yes", when VM
boots up with or without vNIC connected. This patch fixed the problem.

I will include the comments.

Thanks,
- Haiyang

