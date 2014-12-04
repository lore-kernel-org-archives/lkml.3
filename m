Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519AbaLDJyQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 04:54:16 -0500
Received: from mail-by2on0134.outbound.protection.outlook.com ([207.46.100.134]:14254
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751785AbaLDJyL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 04:54:11 -0500
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
Thread-Index: AQHQDtn5j6GPqUxwWEaud+fx6yvb95x9n9SAgAELugCAAGolgIAAAmBwgAAOO4CAAAulAA==
Date: Thu, 4 Dec 2014 09:54:08 +0000
Message-ID: <BY2PR0301MB061372E00518F169BCF2FFFA9B780@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1417598162-40433-1-git-send-email-Li.Xiubo@freescale.com>
 <4810522.t9QFQYHtHI@wuerfel>
 <BY2PR0301MB06131C2C901351E8592ED3D89B780@BY2PR0301MB0613.namprd03.prod.outlook.com>
 <548016D9.6030006@ti.com>
 <BY2PR0301MB0613ABEA1410C04CF07C1C7C9B780@BY2PR0301MB0613.namprd03.prod.outlook.com>
 <548024C7.3060004@ti.com>
In-Reply-To: <548024C7.3060004@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.53]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0614;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0614;
x-forefront-prvs: 041517DFAB
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(164054003)(51704005)(54356999)(76176999)(110136001)(74316001)(62966003)(68736005)(50986999)(66066001)(86362001)(20776003)(64706001)(101416001)(33656002)(31966008)(107046002)(95666004)(77156002)(99286002)(106356001)(105586002)(106116001)(122556002)(40100003)(76576001)(46102003)(92726001)(92566001)(97736003)(4396001)(21056001)(87936001)(93886004)(2656002)(120916001)(99396003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0614;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomi,

Thanks for your information very much.

> > Sorry for confusing, it was delayed for other reasons internal.
> >
> > I am not familiar about the DRM, and I'd like to know if the DRM driver will
> be
> > support, should I also develop the libdrm too ? Or just coding in kernel
> level ?
> 
> For simple drm drivers (this looks like it would be a simple one), I
> don't think there's any need for libdrm support. The generic DRM
> interfaces should be enough, so just kernel level coding needed.
> 

That's to say, if I am using the X11 server without any code in usrspace,
If the DRM driver will support /dev/fbX, it could work correctly ?

Thanks,

BRs
Xiubo




