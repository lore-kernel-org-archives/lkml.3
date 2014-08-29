Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbaH2Tip (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 15:38:45 -0400
Received: from mail-bl2lp0209.outbound.protection.outlook.com ([207.46.163.209]:11602
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753104AbaH2Tio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 15:38:44 -0400
Message-ID: <1409341095.24184.18.camel@snotra.buserror.net>
Subject: Re: [PATCHv2] clk: ppc-corenet: rename to ppc-qoriq and add
 CLK_OF_DECLARE support
From: Scott Wood <scottwood@freescale.com>
To: Jingchang Lu <jingchang.lu@freescale.com>
CC: <mturquette@linaro.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Date: Fri, 29 Aug 2014 14:38:15 -0500
In-Reply-To: <1409301354-13699-1-git-send-email-jingchang.lu@freescale.com>
References: <1409301354-13699-1-git-send-email-jingchang.lu@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:6853:5536:db43:a2c7]
X-ClientProxiedBy: BY2PR01CA0058.prod.exchangelabs.com (10.255.242.48) To
 BY2PR0301MB0727.namprd03.prod.outlook.com (25.160.63.17)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0318501FAE
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(6009001)(24454002)(199003)(51704005)(189002)(377424004)(88136002)(80022001)(79102001)(21056001)(23676002)(46102001)(101416001)(87976001)(77156001)(83322001)(19580395003)(76482001)(19580405001)(62966002)(77982001)(47776003)(87286001)(50226001)(85852003)(81342001)(81542001)(64706001)(92566001)(74662001)(4396001)(93916002)(20776003)(74502001)(89996001)(92726001)(50466002)(31966008)(90102001)(33646002)(50986999)(99396002)(103116003)(77096002)(76176999)(104166001)(107046002)(95666004)(86362001)(85306004)(106356001)(42186005)(102836001)(110136001)(105586002)(3826002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0727;H:[IPv6:2601:2:5800:3f7:6853:5536:db43:a2c7];FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-08-29 at 16:35 +0800, Jingchang Lu wrote:
> The IP is shared on PPC and ARM, this rename it to qoriq for better
> represention, and this also add the CLK_OF_DECLARE support for being
> initialized by of_clk_init() on ARM.
> 
> Signed-off-by: Jingchang Lu <jingchang.lu@freescale.com>
> ---
> changes in v2:
>  rename the driver name to ppc-qoriq.c for shared on PPC and ARM.
> 
>  drivers/clk/Kconfig           |   9 +-
>  drivers/clk/Makefile          |   2 +-
>  drivers/clk/clk-ppc-corenet.c | 307 -----------------------------------------
>  drivers/clk/clk-qoriq.c       | 312 ++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 318 insertions(+), 312 deletions(-)
>  delete mode 100644 drivers/clk/clk-ppc-corenet.c
>  create mode 100644 drivers/clk/clk-qoriq.c

Please use -M -C with git format-patch to detect the rename, so we can
see what changed during the rename.

-Scott


