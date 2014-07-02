Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408AbaGBI7k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 04:59:40 -0400
Received: from [207.46.163.184] ([207.46.163.184]:34336 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751450AbaGBI7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 04:59:38 -0400
From: Varun Sethi <Varun.Sethi@freescale.com>
To: Emilian Medve <Emilian.Medve@freescale.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
Subject: RE: [PATCH 1/3] iommu/fsl: Fix PAMU window size check.
Thread-Topic: [PATCH 1/3] iommu/fsl: Fix PAMU window size check.
Thread-Index: AQHPlcrfL+o9dvYIBU++4uSFp0q0S5uMfAOA
Date: Wed, 2 Jul 2014 08:58:45 +0000
Message-ID: <43e9c89d998b480b869b7ab4d9b4e52c@BL2PR03MB468.namprd03.prod.outlook.com>
References: <1403618237-26248-1-git-send-email-Varun.Sethi@freescale.com>
 <1403618237-26248-2-git-send-email-Varun.Sethi__13822.953499812$1403630309$gmane$org@freescale.com>
 <53B3B8B9.30400@Freescale.com>
In-Reply-To: <53B3B8B9.30400@Freescale.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.169.1]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 0260457E99
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(51704005)(189002)(199002)(479174003)(377454003)(13464003)(24454002)(85306003)(76176999)(50986999)(87936001)(83322001)(74316001)(54356999)(31966008)(86362001)(99286002)(64706001)(92566001)(101416001)(74502001)(2201001)(46102001)(83072002)(2656002)(85852003)(4396001)(99396002)(76482001)(19580395003)(19580405001)(74662001)(20776003)(79102001)(77982001)(81542001)(81342001)(106356001)(106116001)(33646001)(76576001)(107886001)(21056001)(95666004)(80022001)(66066001)(107046002)(105586002)(108616002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB578;H:BL2PR03MB468.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s628xnMq029002

Thanks Emil.

> -----Original Message-----
> From: Emil Medve [mailto:Emilian.Medve@Freescale.com]
> Sent: Wednesday, July 02, 2014 1:16 PM
> To: Sethi Varun-B16395; iommu@lists.linux-foundation.org;
> joro@8bytes.org; linux-kernel@vger.kernel.org; linuxppc-
> dev@lists.ozlabs.org; alex.williamson@redhat.com
> Subject: Re: [PATCH 1/3] iommu/fsl: Fix PAMU window size check.
> 
> On 06/24/2014 08:57 AM, Varun Sethi wrote:
> > is_power_of_2 requires an unsigned long parameter which would lead to
> > truncation of 64 bit values on 32 bit architectures.
> >
> > __ffs also expects an unsigned long parameter thus won't work for 64
> > bit values on 32 bit architectures.
> >
> > Signed-off-by: Varun Sethi <Varun.Sethi@freescale.com>
> > ---
> >  drivers/iommu/fsl_pamu.c        |    8 ++++----
> >  drivers/iommu/fsl_pamu_domain.c |    2 +-
> >  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> Tested-by: Emil Medve <Emilian.Medve@Freescale.com>
> 
> On a P4080 DS (i.e. 32-bit SoC)
> 
> 
> Cheers,
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
