Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759402AbaGRCiL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 22:38:11 -0400
Received: from mail-by2lp0237.outbound.protection.outlook.com ([207.46.163.237]:56248
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751329AbaGRCiK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 22:38:10 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Nicolin Chen <nicoleotsuka@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "timur@tabi.org" <timur@tabi.org>,
        "shengjiu.wang@freescale.com" <shengjiu.wang@freescale.com>,
        "guangyu.chen@freescale.com" <guangyu.chen@freescale.com>
Subject: RE: [PATCH 0/2] ASoC: fsl_sai: Two bug fixes for fsl_sai driver
Thread-Topic: [PATCH 0/2] ASoC: fsl_sai: Two bug fixes for fsl_sai driver
Thread-Index: AQHPocG9MoqrjolH6kW1Pjv2BsB8nZulHprw
Date: Fri, 18 Jul 2014 02:38:06 +0000
Message-ID: <9e28b763e864442baccf0f45d975ef51@BN1PR0301MB0609.namprd03.prod.outlook.com>
References: <cover.1405603108.git.nicoleotsuka@gmail.com>
In-Reply-To: <cover.1405603108.git.nicoleotsuka@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 02760F0D1C
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(377454003)(13464003)(51704005)(189002)(164054003)(199002)(106116001)(77982001)(19580395003)(46102001)(83322001)(33646002)(31966008)(92566001)(2656002)(74316001)(19580405001)(106356001)(74502001)(81342001)(87936001)(101416001)(20776003)(4396001)(81542001)(85306003)(76576001)(95666004)(54356999)(76176999)(80022001)(99396002)(85852003)(107046002)(86362001)(66066001)(77096002)(21056001)(105586002)(99286002)(76482001)(79102001)(64706001)(74662001)(50986999)(83072002)(108616002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB328;H:BN1PR0301MB0609.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Nicolin Chen [mailto:nicoleotsuka@gmail.com]
> Sent: Thursday, July 17, 2014 9:22 PM
> To: broonie@kernel.org
> Cc: linux-kernel@vger.kernel.org; linuxppc-dev@lists.ozlabs.org; alsa-
> devel@alsa-project.org; timur@tabi.org; Xiubo Li-B47053; Wang Shengjiu-B02247;
> Chen Guangyu-B42378
> Subject: [PATCH 0/2] ASoC: fsl_sai: Two bug fixes for fsl_sai driver
> 
> Nicolin Chen (2):
>   ASoC: fsl_sai: Reset FIFOs after disabling TE/RE
>   ASoC: fsl_sai: Fix incorrect register writing in fsl_sai_isr()
> 

Yes, they are all looks good to me.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>

Thanks,

BRs
Xiubo


>  sound/soc/fsl/fsl_sai.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> --
> 1.8.4

