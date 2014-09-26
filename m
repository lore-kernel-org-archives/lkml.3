Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbaIZBRJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 21:17:09 -0400
Received: from mail-bn1on0116.outbound.protection.outlook.com ([157.56.110.116]:41952
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752384AbaIZBRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 21:17:08 -0400
Date: Fri, 26 Sep 2014 09:16:36 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Stefan Agner <stefan@agner.ch>
CC: <linus.walleij@linaro.org>, <gnurou@gmail.com>, <kernel@pengutronix.de>,
        <linux-gpio@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <bpringlemeir@nbsps.com>,
        <l.stach@pengutronix.de>
Subject: Re: [PATCH v3 0/5] vf610: Add GPIO support
Message-ID: <20140926011635.GB21077@dragon>
References: <cover.1411662961.git.stefan@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1411662961.git.stefan@agner.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(24454002)(199003)(54356999)(76176999)(50986999)(57986006)(90102001)(83506001)(104016003)(23726002)(33656002)(50466002)(99396003)(97736003)(68736004)(83072002)(110136001)(97756001)(102836001)(21056001)(46406003)(107046002)(86362001)(6806004)(31966008)(19580405001)(4396001)(83322001)(19580395003)(44976005)(81156004)(92566001)(92726001)(106466001)(84676001)(85852003)(105606002)(47776003)(64706001)(77982003)(20776003)(95666004)(33716001)(120916001)(79102003)(74662003)(46102003)(69596002)(74502003)(80022003)(10300001)(81342003)(85306004)(87936001)(76482002)(81542003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0632;H:az84smr01.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0632;
X-Forefront-PRVS: 03468CBA43
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 06:37:04PM +0200, Stefan Agner wrote:
> Stefan Agner (5):
>   pinctrl: imx: detect uninitialized pins
>   pinctrl: imx: add gpio pinmux support for vf610
>   gpio: vf610: add gpiolib/IRQ chip driver for Vybrid
>   ARM: dts: vf610: use new GPIO support
>   Documentation: dts: add bindings for Vybrid GPIO/PORT module

For patch #1, #2, #3 and #5:

Acked-by: Shawn Guo <shawn.guo@freescale.com>
