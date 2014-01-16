Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865AbaAPPvX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 10:51:23 -0500
Received: from mail-by2lp0241.outbound.protection.outlook.com ([207.46.163.241]:4628
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751955AbaAPPvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 10:51:20 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Olaf Hering <olaf@aepfle.de>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH V2 1/1] Drivers: hv: Implement the file copy service
Thread-Topic: [PATCH V2 1/1] Drivers: hv: Implement the file copy service
Thread-Index: AQHPEVjnKHWBxAK/ME2641uqAhZ1vZqHJXWAgABdVTA=
Date: Thu, 16 Jan 2014 15:51:16 +0000
Message-ID: <85222ac3dc894a1a8fde438ac1a150e3@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1389728116-21337-1-git-send-email-kys@microsoft.com>
 <20140116101653.GA20001@aepfle.de>
In-Reply-To: <20140116101653.GA20001@aepfle.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2601:8:9b00:402:1cb1:47cd:959b:a3a6]
x-forefront-prvs: 0093C80C01
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(679001)(689001)(779001)(164054003)(189002)(199002)(51704005)(24454002)(13464003)(377454003)(92566001)(93136001)(53806001)(74706001)(47976001)(54356001)(74366001)(93516002)(4396001)(76482001)(47736001)(49866001)(50986001)(74316001)(51856001)(85306002)(81342001)(69226001)(85852003)(74662001)(76576001)(76786001)(74502001)(47446002)(76796001)(31966008)(65816001)(80022001)(83322001)(19580405001)(19580395003)(80976001)(46102001)(33646001)(74876001)(81816001)(56816005)(90146001)(83072002)(77982001)(54316002)(59766001)(63696002)(79102001)(56776001)(87266001)(81542001)(2656002)(81686001)(87936001)(3826001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB298;H:BY2PR03MB299.namprd03.prod.outlook.com;CLIP:2601:8:9b00:402:1cb1:47cd:959b:a3a6;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0GFpSwt018748



> -----Original Message-----
> From: Olaf Hering [mailto:olaf@aepfle.de]
> Sent: Thursday, January 16, 2014 2:17 AM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; apw@canonical.com; jasowang@redhat.com
> Subject: Re: [PATCH V2 1/1] Drivers: hv: Implement the file copy service
> 
> On Tue, Jan 14, K. Y. Srinivasan wrote:
> 
> > +++ b/include/linux/hyperv.h
> > @@ -26,6 +26,8 @@
> >  #define _HYPERV_H
> >
> >  #include <linux/types.h>
> > +#include <linux/uuid.h>
> > +#include <linux/limits.h>
> 
> limits.h is not required.

Will get rid of it.

Thanks,

K. Y
> 
> Olaf
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
