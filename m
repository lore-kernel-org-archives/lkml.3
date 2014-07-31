Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167AbaGaAcF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 20:32:05 -0400
Received: from mail-bn1lp0144.outbound.protection.outlook.com ([207.46.163.144]:17225
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755348AbaGaAcB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 20:32:01 -0400
From: KY Srinivasan <kys@microsoft.com>
To: David Miller <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH 1/1] Drivers: net-next: hyperv
Thread-Topic: [PATCH 1/1] Drivers: net-next: hyperv
Thread-Index: AQHPrFT6ALcsHsREy0+0fW5ZdV0D6pu5UyuAgAABogA=
Date: Thu, 31 Jul 2014 00:31:56 +0000
Message-ID: <5d85f8205f3840449e0b678bab49e777@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1406769616-29871-1-git-send-email-kys@microsoft.com>
 <20140730.172523.1080858143706717134.davem@davemloft.net>
In-Reply-To: <20140730.172523.1080858143706717134.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e0:ed43::2]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 0289B6431E
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(13464003)(51704005)(377454003)(189002)(199002)(95666004)(83322001)(19580395003)(4396001)(50986999)(107046002)(31966008)(105586002)(21056001)(54356999)(101416001)(99286002)(33646002)(80022001)(79102001)(86612001)(76576001)(19580405001)(74502001)(99396002)(76176999)(74662001)(2656002)(85306003)(86362001)(106356001)(83072002)(20776003)(46102001)(85852003)(64706001)(110136001)(74316001)(76482001)(77982001)(77096002)(106116001)(87936001)(81542001)(81342001)(92566001)(24736002)(3826002)(108616003);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0712;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net]
> Sent: Wednesday, July 30, 2014 5:25 PM
> To: KY Srinivasan
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com
> Subject: Re: [PATCH 1/1] Drivers: net-next: hyperv
> 
> From: "K. Y. Srinivasan" <kys@microsoft.com>
> Date: Wed, 30 Jul 2014 18:20:16 -0700
> 
> > For forwarding scenarios, it will be useful to allocate larger
> > sendbuf. Make the necessary adjustments to permit this.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> 
> Please submit this with a proper Subject line, something like "[PATCH 1/1]
> hyperv: ${DESCRIPTION}" would be fine.
> 
> As is, nobody scanning the commit headers in the tree history can see what
> might be unique about this change to the hyperv driver vs. all others,
> because you haven't written a proper description.
Oops; sorry about that. I will resend this.

K. Y


