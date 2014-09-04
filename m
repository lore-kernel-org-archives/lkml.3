Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154AbaIDFJg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 01:09:36 -0400
Received: from mail-bn1on0063.outbound.protection.outlook.com ([157.56.110.63]:57118
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750788AbaIDFJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 01:09:35 -0400
Date: Thu, 4 Sep 2014 13:09:19 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-gpio@vger.kernel.org>, Alexander Shiyan <shc_work@mail.ru>,
        "Anson Huang" <b20788@freescale.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Denis Carikli <denis@eukrea.com>, Markus Pargmann <mpa@pengutronix.de>,
        "Greg Ungerer" <gerg@uclinux.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH v2] pinctrl: imx/mxs: move freescale drivers to subdir
Message-ID: <20140904050917.GB18688@dragon>
References: <1409746436-23094-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1409746436-23094-1-git-send-email-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130542809719810459;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009014)(6009001)(448002)(51704005)(199003)(24454002)(189002)(81342001)(106466001)(85326001)(64706001)(76482001)(47776003)(84676001)(46102001)(110136001)(23726002)(99396002)(26826002)(87936001)(104016003)(81542001)(54356999)(85852003)(20776003)(83506001)(33716001)(46406003)(74662001)(97736001)(31966008)(83072002)(97756001)(6806004)(50466002)(44976005)(74502001)(50986999)(19580405001)(92726001)(33656002)(90102001)(68736004)(102836001)(85306004)(57986006)(79102001)(83322001)(77982001)(107046002)(86362001)(19580395003)(92566001)(21056001)(76176999)(4396001)(80022001)(4477795004)(95666004)(241875001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB366;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0324C2C0E2
Authentication-Results: spf=permerror (sender IP is 192.88.168.50)
 smtp.mailfrom=shawn.guo@linaro.org; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 02:13:56PM +0200, Linus Walleij wrote:
> This moves all the Freescale-related drivers (i.MX and MXS) to
> its own subdirectory to clear the view.
> 
> Cc: Alexander Shiyan <shc_work@mail.ru>
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Cc: Anson Huang <b20788@freescale.com>
> Cc: Fabio Estevam <fabio.estevam@freescale.com>
> Cc: Denis Carikli <denis@eukrea.com>
> Cc: Markus Pargmann <mpa@pengutronix.de>
> Cc: Greg Ungerer <gerg@uclinux.org>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Acked-by: Shawn Guo <shawn.guo@linaro.org> 
