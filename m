Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569AbaDXWGp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 18:06:45 -0400
Received: from mail-bl2lp0210.outbound.protection.outlook.com ([207.46.163.210]:8373
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756215AbaDXWGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 18:06:40 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Andev <debiandev@gmail.com>
CC: "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH V1 net-next 1/1] hyperv: Enable sendbuf mechanism on the
 send path
Thread-Topic: [PATCH V1 net-next 1/1] hyperv: Enable sendbuf mechanism on
 the send path
Thread-Index: AQHPXzK1xiTkjzdkc0SXAOin2nil25shT8uAgAAAlvA=
Date: Thu, 24 Apr 2014 22:06:24 +0000
Message-ID: <cdb70820bcd0467586ce6893753c7065@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1398288285-16268-1-git-send-email-kys@microsoft.com>
 <CAJUuVQ7V+Se0auKdaiqPZr8i2WcNqWhHUwz8r85DKKCjnjtrvQ@mail.gmail.com>
In-Reply-To: <CAJUuVQ7V+Se0auKdaiqPZr8i2WcNqWhHUwz8r85DKKCjnjtrvQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2601:8:9b00:402:407a:561f:4c92:ca66]
x-forefront-prvs: 01917B1794
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(24454002)(377454003)(189002)(199002)(13464003)(51704005)(83072002)(77096999)(85852003)(46102001)(76176999)(80976001)(86612001)(54356999)(81342001)(81542001)(76576001)(92566001)(83322001)(74316001)(79102001)(19580395003)(50986999)(19580405001)(4396001)(33646001)(99396002)(2656002)(77982001)(80022001)(31966008)(1411001)(76482001)(86362001)(74502001)(87936001)(20776003)(74662001)(99286001)(24736002)(3826001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB297;H:BY2PR03MB299.namprd03.prod.outlook.com;FPR:B73EC3AE.A03F9D24.336F8393.D0C2D3A2.2021D;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3OM7Oqm001109



> -----Original Message-----
> From: Andev [mailto:debiandev@gmail.com]
> Sent: Thursday, April 24, 2014 2:50 PM
> To: KY Srinivasan
> Cc: davem@davemloft.net; netdev@vger.kernel.org; LKML;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com
> Subject: Re: [PATCH V1 net-next 1/1] hyperv: Enable sendbuf mechanism on
> the send path
> 
> On Wed, Apr 23, 2014 at 5:24 PM, K. Y. Srinivasan <kys@microsoft.com>
> wrote:
> 
> >  drivers/net/hyperv/hyperv_net.h |   14 +++
> >  drivers/net/hyperv/netvsc.c     |  226
> +++++++++++++++++++++++++++++++++++++--
> >  drivers/net/hyperv/netvsc_drv.c |    3 +->  3 files changed, 234
> insertions(+), 9 deletions(-)
> 
> I just looked over netvsc.c and it could definitely use a more consistent
> coding style.
> 
> Your use of goto exit/cleanup in some functions and returning directly on
> errors in others could use a cleanup. Please consider doing that while you are
> touching those files.

Will do. The most recent changes I made to netvsc.c, I think was consistent with the existing code;
going forward we will certainly move towards a more consistent coding style.

Regards,

K. Y
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
