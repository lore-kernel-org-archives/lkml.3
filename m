Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759AbaIPCHT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 22:07:19 -0400
Received: from mail-bn1on0147.outbound.protection.outlook.com ([157.56.110.147]:52408
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754324AbaIPCHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 22:07:16 -0400
Date: Tue, 16 Sep 2014 09:51:09 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Joe Perches <joe@perches.com>
CC: <linux-arm-kernel@lists.infradead.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/8] arm: mach-imx: Convert pr_warning to pr_warn
Message-ID: <20140916015108.GC23450@dragon>
References: <cover.1410632834.git.joe@perches.com>
 <2c6cfbc8d456f98db88e20ee3d72a251e929ff0a.1410632835.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2c6cfbc8d456f98db88e20ee3d72a251e929ff0a.1410632835.git.joe@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(51704005)(189002)(24454002)(85306004)(83072002)(85852003)(87936001)(79102001)(77982001)(95666004)(76482001)(110136001)(57986006)(558084003)(90102001)(21056001)(33656002)(26826002)(46102002)(102836001)(4396001)(74662001)(31966008)(54356999)(97756001)(84676001)(50466002)(19580405001)(44976005)(83322001)(6806004)(46406003)(33716001)(92566001)(23726002)(74502001)(92726001)(68736004)(19580395003)(76176999)(97736003)(105606002)(20776003)(107046002)(47776003)(104016003)(106466001)(64706001)(99396002)(80022002)(50986999)(81342002)(81542002)(83506001)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB259;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03361FCC43
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 13, 2014 at 11:31:15AM -0700, Joe Perches wrote:
> Use the more common pr_warn.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied, thanks.
