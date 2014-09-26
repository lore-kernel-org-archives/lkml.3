Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040AbaIZBpm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 21:45:42 -0400
Received: from mail-bn1bbn0108.outbound.protection.outlook.com ([157.56.111.108]:15392
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752384AbaIZBpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 21:45:41 -0400
Date: Fri, 26 Sep 2014 09:45:14 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Stefan Agner <stefan@agner.ch>
CC: <kernel@pengutronix.de>, <daniel.lezcano@linaro.org>, <tglx@linutronix.de>,
        <festevam@gmail.com>, <jingchang.lu@freescale.com>,
        <bpringlemeir@nbsps.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] ARM: vf610: Add ARM Global Timer clocksource
 option
Message-ID: <20140926014513.GF21077@dragon>
References: <1411575610-20895-1-git-send-email-stefan@agner.ch>
 <1411575610-20895-4-git-send-email-stefan@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1411575610-20895-4-git-send-email-stefan@agner.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(24454002)(199003)(51704005)(189002)(92726001)(4396001)(50466002)(23726002)(110136001)(86362001)(97736003)(102836001)(92566001)(99396003)(69596002)(87936001)(54356999)(33716001)(76176999)(68736004)(50986999)(76482002)(104016003)(84676001)(6806004)(85306004)(106466001)(46406003)(81156004)(107046002)(83506001)(120916001)(10300001)(31966008)(46102003)(74662003)(90102001)(74502003)(81542003)(79102003)(64706001)(33656002)(80022003)(77982003)(95666004)(81342003)(85852003)(19580405001)(97756001)(44976005)(47776003)(83322001)(20776003)(21056001)(83072002)(57986006)(19580395003);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR03MB472;H:az84smr01.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB472;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 03468CBA43
Authentication-Results: spf=temperror (sender IP is 192.88.158.2)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 06:20:10PM +0200, Stefan Agner wrote:
> Add the ARM Global Timer as clocksource/scheduler clock option and
> use it as default scheduler clock. This leaves the PIT timer for
> other users e.g. the secondary Cortex-M4 core. Also, the Global Timer
> has double the precission (running at pheripheral clock compared to
> IPG clock) and a 64-bit incrementing counter register. We still keep
> the PIT timer as an secondary option in case the ARM Global Timer is
> not available.
> 
> Signed-off-by: Stefan Agner <stefan@agner.ch>

Applied, thanks.
