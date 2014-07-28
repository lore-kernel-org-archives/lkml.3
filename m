Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207AbaG1BqN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 21:46:13 -0400
Received: from mail-by2lp0238.outbound.protection.outlook.com ([207.46.163.238]:26451
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751250AbaG1BqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 21:46:07 -0400
Date: Mon, 28 Jul 2014 09:45:40 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Pawel Moll <pawel.moll@arm.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>, <paul@pwsan.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Peter De Schrijver <pdeschrijver@nvidia.com>, <arm@kernel.org>,
        <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH 1/5] ARM: imx: Remove references to platform_bus in mxc
 code
Message-ID: <20140728014538.GH8821@dragon>
References: <1406298233-27876-1-git-send-email-pawel.moll@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1406298233-27876-1-git-send-email-pawel.moll@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(24454002)(51704005)(110136001)(26826002)(105606002)(97756001)(81542001)(79102001)(85306003)(106466001)(81342001)(31966008)(97736001)(85852003)(4396001)(83072002)(50466002)(92566001)(23726002)(84676001)(77982001)(104016003)(21056001)(95666004)(19580395003)(99396002)(107046002)(64706001)(83322001)(19580405001)(44976005)(6806004)(68736004)(33656002)(102836001)(74502001)(74662001)(54356999)(76176999)(83506001)(47776003)(80022001)(86362001)(87936001)(76482001)(46102001)(92726001)(57986006)(20776003)(50986999)(46406003)(33716001);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB568;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0286D7B531
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 03:23:49PM +0100, Pawel Moll wrote:
> The bus devices created to be parents for other peripherals
> were using platform_bus as a parent, not being platform
> devices themselves. Remove the references, making them
> virtual devices instead.
> 
> Cc: Shawn Guo <shawn.guo@freescale.com>
> Cc: Sascha Hauer <kernel@pengutronix.de>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: linux-arm-kernel@lists.infradead.org
> Signed-off-by: Pawel Moll <pawel.moll@arm.com>

Acked-by: Shawn Guo <shawn.guo@freescale.com>
