Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271AbaEFN4P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 09:56:15 -0400
Received: from mail-bl2lp0207.outbound.protection.outlook.com ([207.46.163.207]:13147
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755504AbaEFN4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 09:56:13 -0400
Date: Tue, 6 May 2014 21:55:44 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Brian Norris <computersforpeace@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        Huang Shijie <b32955@freescale.com>, Marek Vasut <marex@denx.de>,
        <linux-mtd@lists.infradead.org>, Sascha Hauer <kernel@pengutronix.de>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 01/12] ARM: imx/mxs defconfigs: add MTD_SPI_NOR (new
 dependency for M25P80)
Message-ID: <20140506135541.GA2798@dragon>
References: <1398925607-7482-1-git-send-email-computersforpeace@gmail.com>
 <1398925607-7482-2-git-send-email-computersforpeace@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1398925607-7482-2-git-send-email-computersforpeace@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(51704005)(24454002)(189002)(199002)(81542001)(83506001)(84676001)(33656001)(46406003)(1411001)(92726001)(99396002)(97756001)(97736001)(92566001)(33716001)(86362001)(69596002)(81342001)(68736004)(23726002)(77982001)(19580405001)(19580395003)(83322001)(44976005)(50986999)(20776003)(6806004)(79102001)(47776003)(74662001)(4396001)(2009001)(77096999)(81156002)(57986002)(85852003)(83072002)(21056001)(80022001)(50466002)(74502001)(76176999)(46102001)(54356999)(64706001)(76482001)(87936001)(31966008);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB429;H:az84smr01.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 0203C93D51
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 11:26:36PM -0700, Brian Norris wrote:
> These defconfigs contain the CONFIG_M25P80 symbol, which is now
> dependent on the MTD_SPI_NOR symbol. Add CONFIG_MTD_SPI_NOR to satisfy
> the new dependency.
> 
> Signed-off-by: Brian Norris <computersforpeace@gmail.com>
> Cc: Shawn Guo <shawn.guo@freescale.com>
> Cc: Sascha Hauer <kernel@pengutronix.de>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Reviewed-by: Marek Vasut <marex@denx.de>

Applied, thanks.
