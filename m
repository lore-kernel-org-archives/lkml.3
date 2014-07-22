Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257AbaGVCOX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 22:14:23 -0400
Received: from mail-bn1blp0183.outbound.protection.outlook.com ([207.46.163.183]:14739
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751595AbaGVCOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 22:14:22 -0400
Date: Tue, 22 Jul 2014 10:14:04 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Stefan Agner <stefan@agner.ch>
CC: <kernel@pengutronix.de>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: dts: vf610-colibri: split device tree for carrier
 boards
Message-ID: <20140722021403.GP8537@dragon>
References: <1405693518-28293-1-git-send-email-stefan@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1405693518-28293-1-git-send-email-stefan@agner.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(51704005)(24454002)(189002)(77982001)(83506001)(97736001)(74662001)(92726001)(33656002)(31966008)(83072002)(105606002)(85306003)(79102001)(107046002)(86362001)(47776003)(23726002)(4396001)(20776003)(85852003)(80022001)(69596002)(97756001)(76482001)(19580405001)(26826002)(50986999)(83322001)(102836001)(19580395003)(106466001)(76176999)(99396002)(21056001)(95666004)(54356999)(104016003)(74502001)(84676001)(46406003)(50466002)(6806004)(92566001)(81156004)(46102001)(44976005)(81342001)(33716001)(57986006)(81542001)(110136001)(68736004)(87936001)(64706001);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB564;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02801ACE41
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 04:25:18PM +0200, Stefan Agner wrote:
> The Colibri VF61 is a module which needs a carrier board to actually
> run. Different carrier board have different hardware support, hence
> we should reflect this in the device tree files. This patch adds the
> Colibri Evaluation Board, which supports almost all peripherals
> defined in the Colibri standard.
> 
> Also align the compatible naming, file splitting and file naming with
> the scheme which was choosen for the Tegra based modules.
> 
> Signed-off-by: Stefan Agner <stefan@agner.ch>

Applied, thanks.
