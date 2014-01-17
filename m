Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997AbaAQCYV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 21:24:21 -0500
Received: from [207.46.163.151] ([207.46.163.151]:45106 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751667AbaAQCYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 21:24:19 -0500
From: Jingchang Lu <jingchang.lu@freescale.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [PATCHv9 2/2] dma: Add Freescale eDMA engine driver support
Thread-Topic: [PATCHv9 2/2] dma: Add Freescale eDMA engine driver support
Thread-Index: AQHPEmrvyxjbmA0a8EaGX9qH7zMJ1pqHMCUAgAD/lUA=
Date: Fri, 17 Jan 2014 02:22:26 +0000
Message-ID: <8e515b3695ea4c33a61f354b77be0b6b@BL2PR03MB467.namprd03.prod.outlook.com>
References: <1389839400-29728-1-git-send-email-b35083@freescale.com>
 <1389839400-29728-3-git-send-email-b35083@freescale.com>
 <201401161202.49333.arnd@arndb.de>
In-Reply-To: <201401161202.49333.arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 0094E3478A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(779001)(679001)(689001)(13464003)(51704005)(24454002)(199002)(189002)(377454003)(83072002)(31966008)(87936001)(47446002)(85306002)(81342001)(81686001)(87266001)(76576001)(74876001)(85852003)(4396001)(93516002)(74706001)(81542001)(74366001)(74502001)(2656002)(90146001)(74662001)(56816005)(80022001)(66066001)(69226001)(65816001)(47976001)(63696002)(76796001)(51856001)(19580395003)(19580405001)(80976001)(47736001)(50986001)(83322001)(79102001)(53806001)(54356001)(49866001)(46102001)(54316002)(77982001)(56776001)(59766001)(76482001)(76786001)(92566001)(93136001)(74316001)(33646001)(81816001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB467;H:BL2PR03MB467.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0H2OOPp021794



> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Thursday, January 16, 2014 7:03 PM
> To: Lu Jingchang-B35083
> Cc: vinod.koul@intel.com; dan.j.williams@intel.com; shawn.guo@linaro.org;
> pawel.moll@arm.com; mark.rutland@arm.com; swarren@wwwdotorg.org; linux-
> kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
> devicetree@vger.kernel.org; Wang Huan-B18965
> Subject: Re: [PATCHv9 2/2] dma: Add Freescale eDMA engine driver support
> 
> On Thursday 16 January 2014, Jingchang Lu wrote:
> > Add Freescale enhanced direct memory(eDMA) controller support.
> > This module can be found on Vybrid and LS-1 SoCs.
> >
> > Signed-off-by: Alison Wang <b18965@freescale.com>
> > Signed-off-by: Jingchang Lu <b35083@freescale.com>
> 
> Very nice! All my previous comments have been addressed, so
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
> One small comment still:
> 
> > +
> > +static DEFINE_MUTEX(fsl_edma_mutex);
> > +
> 
> I think this mutex should be part of struct fsl_edma_engine, not global.
Yes, it should be for each edma controller, I will define it in struct fsl_edma_engine. Thanks.


Best Regards,
Jingchang


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
