Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbaESGrS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 02:47:18 -0400
Received: from mail-by2lp0237.outbound.protection.outlook.com ([207.46.163.237]:4019
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750993AbaESGrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 02:47:16 -0400
Date: Mon, 19 May 2014 14:47:02 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: Emil Goode <emilgoode@gmail.com>, Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        <kernel-janitors@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2 v4] ARM: imx: fix error handling in ipu device
 registration
Message-ID: <20140519064701.GK10685@dragon>
References: <1400446261-27085-1-git-send-email-emilgoode@gmail.com>
 <1400446261-27085-2-git-send-email-emilgoode@gmail.com>
 <20140519063145.GF16662@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140519063145.GF16662@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(51704005)(24454002)(189002)(80022001)(68736004)(69596002)(99396002)(87936001)(81156002)(83322001)(33716001)(79102001)(64706001)(20776003)(86362001)(47776003)(102836001)(77096999)(57986004)(92726001)(23756003)(21056001)(44976005)(19580405001)(19580395003)(50986999)(92566001)(84676001)(81342001)(77982001)(50466002)(83506001)(76482001)(4396001)(74662001)(31966008)(74502001)(33656001)(54356999)(81542001)(6806004)(76176999)(85852003)(83072002)(46102001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB027;H:az84smr01.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Forefront-PRVS: 021670B4D2
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 08:31:45AM +0200, Uwe Kleine-König wrote:
> On Sun, May 18, 2014 at 10:50:59PM +0200, Emil Goode wrote:
> > If we fail to allocate struct platform_device pdev we
> > dereference it after the goto label err.
> > 
> > This bug was found using coccinelle.
> > 
> > Signed-off-by: Emil Goode <emilgoode@gmail.com>
> Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> 
> Shawn, is it already to late for 3.15?

Let me try to see.

Shawn
