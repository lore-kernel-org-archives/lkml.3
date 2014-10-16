Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885AbaJPCah (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 22:30:37 -0400
Received: from mail-bn1on0145.outbound.protection.outlook.com ([157.56.110.145]:65187
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751342AbaJPCag convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 22:30:36 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Shengchao Guo <Shawn.Guo@freescale.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH v3] ARM: ls1021a: add gating clocks to IP blocks.
Thread-Topic: [PATCH v3] ARM: ls1021a: add gating clocks to IP blocks.
Thread-Index: AQHP1yw1xpt6riX400mCXn9hhSG2j5wRjisAgCCUt7A=
Date: Thu, 16 Oct 2014 02:30:31 +0000
Message-ID: <458d4826bf9a4d678480ae3d9660380e@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1411476275-9164-1-git-send-email-Li.Xiubo@freescale.com>
 <20140925085403.GG6405@dragon>
In-Reply-To: <20140925085403.GG6405@dragon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB338;
x-exchange-antispam-report-test: UriScan:;
x-forefront-prvs: 036614DD9C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(6009001)(164054003)(189002)(199003)(51704005)(20776003)(46102003)(80022003)(99286002)(95666004)(97736003)(76576001)(110136001)(77096002)(4396001)(21056001)(106356001)(92566001)(86362001)(33646002)(64706001)(106116001)(85306004)(105586002)(108616004)(66066001)(85852003)(54356999)(76176999)(40100003)(87936001)(99396003)(76482002)(2656002)(74316001)(31966008)(122556002)(120916001)(50986999)(101416001)(107046002)(24736002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB338;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:ovrnspm;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shawn,

[...]
> > +						DCFG_CCSR_DEVDISR1,
> > +						ls1021a_clk_shift(0));
> 
> I think we can ignore the 80 columns warning and put these on one line
> to make the code a bit easier to read.
> 

Yes, it looks better, but in the FSL's internal Gerrit it will be a little
Harder to merge this patch in SDK, the Jenkins will check this and then return
failure.


Thanks,

BRs
Xiubo

> > +	clks[LS1021A_CLK_ESDHC_EN] = ls1021a_clk_gate("esdhc_en", "dummy",
> > +						DCFG_CCSR_DEVDISR1,
> > +						ls1021a_clk_shift(2));
[...]
