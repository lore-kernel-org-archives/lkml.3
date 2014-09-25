Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598AbaIYWFQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 18:05:16 -0400
Received: from mail-bn1bbn0103.outbound.protection.outlook.com ([157.56.111.103]:7136
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751678AbaIYWFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 18:05:15 -0400
Message-ID: <1411682696.13320.207.camel@snotra.buserror.net>
Subject: Re: [PATCHv4] clk: ppc-corenet: rename to ppc-qoriq and add
 CLK_OF_DECLARE support
From: Scott Wood <scottwood@freescale.com>
To: Mike Turquette <mturquette@linaro.org>
CC: Jingchang Lu <jingchang.lu@freescale.com>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Date: Thu, 25 Sep 2014 17:04:56 -0500
In-Reply-To: <20140925213959.19023.80648@quantum>
References: <1411454806-8214-1-git-send-email-jingchang.lu@freescale.com>
	 <20140925213959.19023.80648@quantum>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:416f:c6f:49e6:9e61]
X-ClientProxiedBy: BN1PR08CA0029.namprd08.prod.outlook.com (10.242.217.157) To
 CY1PR0301MB0732.namprd03.prod.outlook.com (25.160.159.150)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0732;
X-Forefront-PRVS: 0345CFD558
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(24454002)(189002)(199003)(377424004)(51704005)(77096002)(77982003)(46102003)(87286001)(50226001)(81342003)(33646002)(74502003)(81542003)(103116003)(47776003)(104166001)(83072002)(77156001)(50466002)(92726001)(89996001)(80022003)(74662003)(64706001)(99396003)(10300001)(120916001)(95666004)(62966002)(87976001)(4396001)(50986999)(102836001)(110136001)(76482002)(83322001)(85306004)(107046002)(31966008)(19580395003)(23676002)(105586002)(76176999)(88136002)(101416001)(79102003)(93916002)(21056001)(42186005)(106356001)(20776003)(86362001)(92566001)(97736003)(90102001)(85852003)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0732;H:[IPv6:2601:2:5800:3f7:416f:c6f:49e6:9e61];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-09-25 at 14:39 -0700, Mike Turquette wrote:
> Quoting Jingchang Lu (2014-09-22 23:46:46)
> > +CLK_OF_DECLARE(qoriq_core_pll_v1, "fsl,qoriq-core-pll-1.0", core_pll_init);
> > +CLK_OF_DECLARE(qoriq_core_pll_v2, "fsl,qoriq-core-pll-2.0", core_pll_init);
> > +CLK_OF_DECLARE(qoriq_core_mux_v1, "fsl,qoriq-core-mux-1.0", core_mux_init);
> > +CLK_OF_DECLARE(qoriq_core_mux_v2, "fsl,qoriq-core-mux-2.0", core_mux_init);
> 
> Is there binding documentation for these compatibles?

Documentation/devicetree/bindings/clock/qoriq-clock.txt

-Scott


