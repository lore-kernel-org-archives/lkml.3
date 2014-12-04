Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbaLDB4f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 20:56:35 -0500
Received: from mail-bn1on0111.outbound.protection.outlook.com ([157.56.110.111]:25952
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751911AbaLDB4d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 20:56:33 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: "plagnioj@jcrosoft.com" <plagnioj@jcrosoft.com>,
        "tomi.valkeinen@ti.com" <tomi.valkeinen@ti.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "alexander.stein@systec-electronic.com" 
	<alexander.stein@systec-electronic.com>
Subject: RE: [PATCHv2 0/4] LS1021A: Add dcfb framebuffer driver support.
Thread-Topic: [PATCHv2 0/4] LS1021A: Add dcfb framebuffer driver support.
Thread-Index: AQHQDtn5j6GPqUxwWEaud+fx6yvb95x9n9SAgAELugA=
Date: Thu, 4 Dec 2014 01:56:28 +0000
Message-ID: <BY2PR0301MB06131C2C901351E8592ED3D89B780@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1417598162-40433-1-git-send-email-Li.Xiubo@freescale.com>
 <4810522.t9QFQYHtHI@wuerfel>
In-Reply-To: <4810522.t9QFQYHtHI@wuerfel>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.53]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0614;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0614;
x-forefront-prvs: 041517DFAB
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(377454003)(13464003)(24454002)(189002)(199003)(51704005)(54356999)(76176999)(54206007)(54606007)(110136001)(50986999)(62966003)(74316001)(68736005)(66066001)(20776003)(86362001)(64706001)(33656002)(101416001)(15975445006)(107046002)(31966008)(95666004)(77156002)(105586002)(106356001)(99286002)(106116001)(15202345003)(122556002)(40100003)(76576001)(46102003)(92726001)(92566001)(97736003)(4396001)(21056001)(120916001)(87936001)(19580395003)(19580405001)(2656002)(99396003)(422495003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0614;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Thanks for you advice.

Because this is very emergency for customers and have delayed for monthes, and the
DRM/KMS will have a little long time to be supported. So I'd like to add this first
and will add DRM/KMS version later.

Thanks very much,

BRs
Xiubo


> -----Original Message-----
> From: linux-fbdev-owner@vger.kernel.org [mailto:linux-fbdev-
> owner@vger.kernel.org] On Behalf Of Arnd Bergmann
> Sent: Wednesday, December 03, 2014 5:52 PM
> To: linux-arm-kernel@lists.infradead.org
> Cc: Xiubo Li-B47053; plagnioj@jcrosoft.com; tomi.valkeinen@ti.com; linux-
> fbdev@vger.kernel.org; linux-kernel@vger.kernel.org; shawn.guo@linaro.org;
> alexander.stein@systec-electronic.com
> Subject: Re: [PATCHv2 0/4] LS1021A: Add dcfb framebuffer driver support.
> 
> On Wednesday 03 December 2014 17:15:58 Xiubo Li wrote:
> > Framebuffer driver for the Freescale SoC Display Controller.
> >
> >
> > Change in V2:
> > - Use the native-mode timing as default.
> > - Add to_fsl_private().
> 
> <standard reply>
> 
> We try to not have any new framebuffer drivers. Please consider making
> this a DRM/KMS driver instead.
> 
> </standard reply>
> 
> 	Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
