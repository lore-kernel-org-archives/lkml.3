Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602AbaEFNIY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 09:08:24 -0400
Received: from [207.46.163.185] ([207.46.163.185]:25433 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751272AbaEFNIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 09:08:23 -0400
Date: Tue, 6 May 2014 20:52:24 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        <linux-kernel@vger.kernel.org>, Silvio F <silvio.fricke@gmail.com>,
        "Philipp Zabel" <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "Viresh Kumar" <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.hashim@st.com>, <spear-devel@list.st.com>
Subject: Re: [PATCH 2/6] mfd: stmpe: add optional regulators
Message-ID: <20140506125221.GA2870@dragon>
References: <1397659455-13638-1-git-send-email-linus.walleij@linaro.org>
 <1397659455-13638-3-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1397659455-13638-3-git-send-email-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130438543508113037;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(428001)(51704005)(199002)(189002)(24454002)(76482001)(46406003)(46102001)(2009001)(31966008)(74502001)(74662001)(101416001)(57986002)(99396002)(76176999)(97736001)(33656001)(50986999)(77982001)(50466002)(97756001)(33716001)(80022001)(77096999)(92726001)(92566001)(83072002)(85852003)(47776003)(20776003)(86362001)(6806004)(81342001)(81542001)(64706001)(83506001)(19580395003)(23726002)(54356999)(69596002)(19580405001)(44976005)(79102001)(84676001)(87936001)(21056001)(83322001)(68736004)(81156002)(4396001);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR03MB407;H:az84smr01.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Forefront-PRVS: 0203C93D51
Authentication-Results: spf=none (sender IP is 192.88.158.2)
 smtp.mailfrom=shawn.guo@linaro.org; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 04:44:11PM +0200, Linus Walleij wrote:
> The STMPE has VCC and VIO supply lines, and sometimes (as on
> Ux500) this comes from a software-controlled regulator. Make
> it possible to supply the STMPE with power from these
> regulators.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

What happens for this patch?  I'm asking because I need to know if I
should apply patch "ARM: dts: imx6: edmqmx6: add vcc and vio power
supplies to stmpe".

Shawn
