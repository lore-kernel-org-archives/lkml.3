Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489AbaE0BZ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 21:25:29 -0400
Received: from mail-by2lp0239.outbound.protection.outlook.com ([207.46.163.239]:19389
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751575AbaE0BZ1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 21:25:27 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Wim Van Sebroeck <wim@iguana.be>
CC: "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCHv5 0/2] imx2-wdt: Add regmap-mmio support
Thread-Topic: [PATCHv5 0/2] imx2-wdt: Add regmap-mmio support
Thread-Index: AQHPT6vlHJ0+8N91m0STifjb71S1QptTjZwAgABn/NA=
Date: Tue, 27 May 2014 01:25:23 +0000
Message-ID: <1714222ba73043c68f026799a43dce41@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1396575205-24394-1-git-send-email-Li.Xiubo@freescale.com>
 <20140526191246.GA21870@spo001.leaseweb.com>
In-Reply-To: <20140526191246.GA21870@spo001.leaseweb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 02243C58C6
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(428001)(199002)(189002)(51704005)(83072002)(85852003)(99286001)(87936001)(2656002)(99396002)(76482001)(76176999)(54356999)(77096999)(83322001)(50986999)(81342001)(81542001)(33646001)(101416001)(46102001)(66066001)(80022001)(20776003)(64706001)(79102001)(76576001)(92566001)(77982001)(86362001)(74662001)(74502001)(31966008)(4396001)(21056001)(74316001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB506;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Li.Xiubo@freescale.com; 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Xiubo Li (2):
> >   watchdog: imx2_wdt: Sort the header files alphabetically
> >   watchdog: imx2_wdt: convert to use regmap API.
> >
> >  drivers/watchdog/Kconfig    |  1 +
> >  drivers/watchdog/imx2_wdt.c | 62 +++++++++++++++++++++++++++---------------
> ---
> >  2 files changed, 39 insertions(+), 24 deletions(-)
> 
> both patches have been added to linux-watchdog-next.
> 

Thanks very much,

BRs
Xiubo



