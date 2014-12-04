Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298AbaLDIaL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 03:30:11 -0500
Received: from mail-by2on0137.outbound.protection.outlook.com ([207.46.100.137]:5984
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753228AbaLDIaG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 03:30:06 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>, Arnd Bergmann <arnd@arndb.de>
CC: "plagnioj@jcrosoft.com" <plagnioj@jcrosoft.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "alexander.stein@systec-electronic.com" 
	<alexander.stein@systec-electronic.com>
Subject: RE: [PATCHv2 0/4] LS1021A: Add dcfb framebuffer driver support.
Thread-Topic: [PATCHv2 0/4] LS1021A: Add dcfb framebuffer driver support.
Thread-Index: AQHQDtn5j6GPqUxwWEaud+fx6yvb95x9n9SAgAELugCAAGolgIAAAmBw
Date: Thu, 4 Dec 2014 08:30:01 +0000
Message-ID: <BY2PR0301MB0613ABEA1410C04CF07C1C7C9B780@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1417598162-40433-1-git-send-email-Li.Xiubo@freescale.com>
 <4810522.t9QFQYHtHI@wuerfel>
 <BY2PR0301MB06131C2C901351E8592ED3D89B780@BY2PR0301MB0613.namprd03.prod.outlook.com>
 <548016D9.6030006@ti.com>
In-Reply-To: <548016D9.6030006@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.53]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0614;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0614;
x-forefront-prvs: 041517DFAB
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(6009001)(199003)(51704005)(479174003)(377454003)(13464003)(189002)(24454002)(46102003)(76576001)(122556002)(40100003)(2656002)(93886004)(87936001)(19580395003)(19580405001)(99396003)(120916001)(97736003)(4396001)(92726001)(92566001)(21056001)(86362001)(20776003)(64706001)(66066001)(33656002)(101416001)(76176999)(54356999)(54206007)(68736005)(50986999)(54606007)(74316001)(62966003)(106356001)(99286002)(105586002)(77156002)(106116001)(31966008)(95666004)(107046002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0614;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:ovrnspm;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomi,



> -----Original Message-----
> From: Tomi Valkeinen [mailto:tomi.valkeinen@ti.com]
> Sent: Thursday, December 04, 2014 4:10 PM
> To: Xiubo Li-B47053; Arnd Bergmann
> Cc: plagnioj@jcrosoft.com; linux-fbdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; shawn.guo@linaro.org; alexander.stein@systec-
> electronic.com
> Subject: Re: [PATCHv2 0/4] LS1021A: Add dcfb framebuffer driver support.
> 
> Hi Xiubo,
> 
> On 04/12/14 03:56, Li.Xiubo@freescale.com wrote:
> > Hi Arnd,
> >
> > Thanks for you advice.
> >
> > Because this is very emergency for customers and have delayed for monthes,
> and the
> > DRM/KMS will have a little long time to be supported. So I'd like to add
> this first
> > and will add DRM/KMS version later.
> 
> I would also suggest to just write a drm driver for this. I don't see
> anything special in this driver that would be better supported via
> fbdev. With drm you'll get a more modern framework, and you will still
> have the same /dev/fbX device to use for legacy userspace software.
> 
> What do you mean with "delayed for months"? The first version of this
> series (that I can find) was posted less than two weeks ago.
> 

Sorry for confusing, it was delayed for other reasons internal.

I am not familiar about the DRM, and I'd like to know if the DRM driver will be
support, should I also develop the libdrm too ? Or just coding in kernel level ?
Is there any Document about how to have /dev/fbX device to use ?

If possible, I'd like this could be accept for this time. And I will add the DRM
Version later(for developing and testing will take a long time).

Thanks very much,

BRs
Xiubo


>  Tomi
> 

