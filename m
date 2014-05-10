Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667AbaEJF14 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 01:27:56 -0400
Received: from mail-bn1blp0190.outbound.protection.outlook.com ([207.46.163.190]:45563
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750900AbaEJF1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 01:27:54 -0400
Date: Sat, 10 May 2014 13:27:45 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Alexander Shiyan <shc_work@mail.ru>
CC: <linux-kernel@vger.kernel.org>, Linus Walleij <linus.walleij@linaro.org>,
        Sascha Hauer <kernel@pengutronix.de>
Subject: Re: [PATCH] pinctrl: Add i.MX1 pincontrol driver
Message-ID: <20140510052742.GJ2870@dragon>
References: <1399652193-17827-1-git-send-email-shc_work@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1399652193-17827-1-git-send-email-shc_work@mail.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130441732722519811;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(51704005)(189002)(199002)(24454002)(81156002)(69596002)(68736004)(19580395003)(83322001)(44976005)(46406003)(19580405001)(4477795002)(80022001)(50466002)(87936001)(79102001)(2009001)(33656001)(85852003)(21056001)(84676001)(23726002)(92566001)(74502001)(81342001)(74662001)(46102001)(57986002)(54356999)(76176999)(50986999)(86362001)(77096999)(97736001)(83072002)(97756001)(4396001)(31966008)(6806004)(47776003)(81542001)(33716001)(64706001)(92726001)(558084003)(77982001)(76482001)(99396002)(20776003)(241875001);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR03MB406;H:az84smr01.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:;
X-Forefront-PRVS: 02070414A1
Authentication-Results: spf=softfail (sender IP is 192.88.158.2)
 smtp.mailfrom=shawn.guo@linaro.org; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 08:16:33PM +0400, Alexander Shiyan wrote:
> This patch adds pincontrol driver for Freescale i.MX1 SOCs.
> 
> Signed-off-by: Alexander Shiyan <shc_work@mail.ru>

Acked-by: Shawn Guo <shawn.guo@linaro.org>
