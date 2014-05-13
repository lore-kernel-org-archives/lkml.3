Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149AbaEMCYl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 22:24:41 -0400
Received: from mail-bn1bon0075.outbound.protection.outlook.com ([157.56.111.75]:52124
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750791AbaEMCYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 22:24:40 -0400
X-Greylist: delayed 845 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 May 2014 22:24:40 EDT
Date: Tue, 13 May 2014 10:10:26 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Rob Herring <robherring2@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Rob Herring <robh@kernel.org>, Sascha Hauer <kernel@pengutronix.de>
Subject: Re: [PATCH 1/7] ARM: imx: fix function type for CLK_OF_DECLARE
Message-ID: <20140513021024.GJ8330@dragon>
References: <1399940993-1773-1-git-send-email-robherring2@gmail.com>
 <1399940993-1773-2-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1399940993-1773-2-git-send-email-robherring2@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(24454002)(189002)(199002)(51704005)(19580395003)(23726002)(87936001)(77982001)(54356999)(77096999)(97756001)(64706001)(76482001)(47776003)(81156002)(83322001)(79102001)(84676001)(21056001)(97736001)(6806004)(69596002)(50466002)(81542001)(20776003)(99396002)(50986999)(76176999)(4396001)(57986002)(86362001)(83072002)(74502001)(46102001)(74662001)(1411001)(85852003)(2009001)(31966008)(92566001)(46406003)(68736004)(19580405001)(44976005)(80022001)(33716001)(81342001)(33656001)(92726001)(102836001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB025;H:az84smr01.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 0210479ED8
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 07:29:47PM -0500, Rob Herring wrote:
> From: Rob Herring <robh@kernel.org>
> 
> Adding function type checking to CLK_OF_DECLARE found a type mismatch with
> mx35_clocks_init_dt. The function should return void.
> 
> Signed-off-by: Rob Herring <robh@kernel.org>
> Cc: Shawn Guo <shawn.guo@freescale.com>
> Cc: Sascha Hauer <kernel@pengutronix.de>

Acked-by: Shawn Guo <shawn.guo@freescale.com>
