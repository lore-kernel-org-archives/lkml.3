Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688AbaLDKTH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 05:19:07 -0500
Received: from mail-bn1bon0118.outbound.protection.outlook.com ([157.56.111.118]:30529
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752992AbaLDKTF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 05:19:05 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: Arnd Bergmann <arnd@arndb.de>,
        "plagnioj@jcrosoft.com" <plagnioj@jcrosoft.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "alexander.stein@systec-electronic.com" 
	<alexander.stein@systec-electronic.com>
Subject: RE: [PATCHv2 0/4] LS1021A: Add dcfb framebuffer driver support.
Thread-Topic: [PATCHv2 0/4] LS1021A: Add dcfb framebuffer driver support.
Thread-Index: AQHQDtn5j6GPqUxwWEaud+fx6yvb95x9n9SAgAELugCAAGolgIAAAmBwgAAOO4CAAAulAIAAAmaAgAAAsHA=
Date: Thu, 4 Dec 2014 10:03:43 +0000
Message-ID: <BY2PR0301MB0613088FB4D7A4796AEAF2219B780@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1417598162-40433-1-git-send-email-Li.Xiubo@freescale.com>
 <4810522.t9QFQYHtHI@wuerfel>
 <BY2PR0301MB06131C2C901351E8592ED3D89B780@BY2PR0301MB0613.namprd03.prod.outlook.com>
 <548016D9.6030006@ti.com>
 <BY2PR0301MB0613ABEA1410C04CF07C1C7C9B780@BY2PR0301MB0613.namprd03.prod.outlook.com>
 <548024C7.3060004@ti.com>
 <BY2PR0301MB061372E00518F169BCF2FFFA9B780@BY2PR0301MB0613.namprd03.prod.outlook.com>
 <5480308F.6070607@ti.com>
In-Reply-To: <5480308F.6070607@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.53]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0614;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0614;
x-forefront-prvs: 041517DFAB
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(199003)(51704005)(479174003)(377454003)(13464003)(189002)(24454002)(46102003)(76576001)(92726001)(122556002)(40100003)(2656002)(93886004)(87936001)(19580405001)(19580395003)(99396003)(120916001)(97736003)(4396001)(92566001)(21056001)(86362001)(20776003)(64706001)(66066001)(33656002)(101416001)(76176999)(54356999)(54206007)(68736005)(50986999)(54606007)(110136001)(74316001)(62966003)(106356001)(106116001)(105586002)(77156002)(99286002)(31966008)(95666004)(107046002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0614;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomi,

Thanks very much for your help.

I will have a try these days.

BRs
Xiubo


> -----Original Message-----
> From: Tomi Valkeinen [mailto:tomi.valkeinen@ti.com]
> Sent: Thursday, December 04, 2014 6:00 PM
> To: Xiubo Li-B47053
> Cc: Arnd Bergmann; plagnioj@jcrosoft.com; linux-fbdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; shawn.guo@linaro.org; alexander.stein@systec-
> electronic.com
> Subject: Re: [PATCHv2 0/4] LS1021A: Add dcfb framebuffer driver support.
> 
> On 04/12/14 11:54, Li.Xiubo@freescale.com wrote:
> > Hi Tomi,
> >
> > Thanks for your information very much.
> >
> >>> Sorry for confusing, it was delayed for other reasons internal.
> >>>
> >>> I am not familiar about the DRM, and I'd like to know if the DRM driver
> will
> >> be
> >>> support, should I also develop the libdrm too ? Or just coding in kernel
> >> level ?
> >>
> >> For simple drm drivers (this looks like it would be a simple one), I
> >> don't think there's any need for libdrm support. The generic DRM
> >> interfaces should be enough, so just kernel level coding needed.
> >>
> >
> > That's to say, if I am using the X11 server without any code in usrspace,
> > If the DRM driver will support /dev/fbX, it could work correctly ?
> 
> Yes. DRM offers helper code to add /dev/fbX with not too many lines. You
> can look at the docs and drm_fb_helper.c.
> 
> And X11 should work fine on top of that, using the X11 fbdev support.
> 
>  Tomi
> 

