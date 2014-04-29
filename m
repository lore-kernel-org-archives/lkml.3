Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbaD2GOw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 02:14:52 -0400
Received: from mail-bl2lp0210.outbound.protection.outlook.com ([207.46.163.210]:18029
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754865AbaD2GOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 02:14:51 -0400
Date: Tue, 29 Apr 2014 14:14:19 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Lad Prabhakar <prabhakar.csengg@gmail.com>
CC: Russell King <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Olof Johansson <olof@lixom.net>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Tony Prisk <linux@prisktech.co.nz>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: configs: drop CONFIG_COMMON_CLK_DEBUG
Message-ID: <20140429061417.GJ16451@dragon>
References: <1398504922-9223-1-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1398504922-9223-1-git-send-email-prabhakar.csengg@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.1;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(428001)(51704005)(189002)(199002)(24454002)(50986999)(76176999)(85852003)(23726002)(33716001)(6806004)(4396001)(83072002)(47776003)(92566001)(33656001)(97756001)(77982001)(44976005)(20776003)(83322001)(54356999)(87936001)(77096999)(46406003)(81542001)(19580395003)(92726001)(99396002)(76482001)(46102001)(81342001)(80976001)(74502001)(57986002)(19580405001)(101416001)(80022001)(31966008)(86362001)(79102001)(50466002);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB245;H:tx30smr01.am.freescale.net;FPR:EE1E08A3.E9E5769.31EEA4BB.8CE2912B.20110;MLV:sfv;PTR:gate-tx3.freescale.com;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 0196A226D1
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2014 at 03:05:22PM +0530, Lad Prabhakar wrote:
> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> 
> this patch removes COMMON_CLK_DEBUG config option
> from defconfig file as this config option is obsolete.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
>  arch/arm/configs/imx_v4_v5_defconfig    |    1 -
>  arch/arm/configs/imx_v6_v7_defconfig    |    1 -
...
>  arch/arm/configs/mxs_defconfig          |    1 -

Please drop these 3 files from your patch.  The obsolete
COMMON_CLK_DEBUG option has been removed from two of them on my branch
by savedefconfig, and we will address the remaining one in another
patch.

Shawn
