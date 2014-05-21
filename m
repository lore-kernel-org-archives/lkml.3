Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911AbaEUH01 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 03:26:27 -0400
Received: from mail-by2lp0239.outbound.protection.outlook.com ([207.46.163.239]:9524
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751824AbaEUH00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 03:26:26 -0400
Date: Wed, 21 May 2014 15:10:14 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Maxime Ripard <maxime.ripard@free-electrons.com>, <jimwall@q.com>,
        <brian@crystalfontz.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: dt: imx28-cfa10036: introduce a regulator for mmc0
Message-ID: <20140521071011.GA20050@dragon>
References: <1400166768-18801-1-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1400166768-18801-1-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130451298261079782;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.158.246;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(24454002)(189002)(199002)(51704005)(81342001)(97756001)(81542001)(50986999)(99396002)(76176999)(50466002)(23726002)(77096999)(86362001)(64706001)(54356999)(77982001)(20776003)(47776003)(80022001)(46102001)(74502001)(31966008)(74662001)(76482001)(83506001)(21056001)(92726001)(6806004)(4396001)(83072002)(85852003)(19580395003)(46406003)(83322001)(87936001)(44976005)(19580405001)(33716001)(92566001)(102836001)(33656002)(57986005);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB414;H:az84smr01.freescale.net;FPR:;MLV:sfv;PTR:gate-az5.freescale.com;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 0218A015FA
Authentication-Results: spf=softfail (sender IP is 192.88.158.246)
 smtp.mailfrom=shawn.guo@linaro.org; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 05:12:48PM +0200, Alexandre Belloni wrote:
> The PWM3 pinmux configuration conflicts with gpio 3.28. Introduce a regulator
> for mmc0 so that it conflicts with the pwm driver and fails gracefully. The
> kernel will then able to access mmc0 normally.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Applied, thanks.
