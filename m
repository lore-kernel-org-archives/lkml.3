Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410AbaHZHjh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 03:39:37 -0400
Received: from mail-by2lp0241.outbound.protection.outlook.com ([207.46.163.241]:51222
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752889AbaHZHjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 03:39:35 -0400
Date: Tue, 26 Aug 2014 15:39:13 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
CC: Thierry Reding <thierry.reding@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-pwm@vger.kernel.org>, Sascha Hauer <kernel@pengutronix.de>,
        "Arnd Bergmann" <arnd@arndb.de>, Tony Prisk <linux@prisktech.co.nz>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv4 4/4] pwm: imx: support output polarity inversion
Message-ID: <20140826073911.GB12289@dragon>
References: <1408517756-9412-1-git-send-email-LW@KARO-electronics.de>
 <1408517756-9412-2-git-send-email-LW@KARO-electronics.de>
 <1408517756-9412-3-git-send-email-LW@KARO-electronics.de>
 <1408517756-9412-4-git-send-email-LW@KARO-electronics.de>
 <1408517756-9412-5-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1408517756-9412-5-git-send-email-LW@KARO-electronics.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130535123734304936;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(448002)(189002)(199003)(51704005)(24454002)(90102001)(4396001)(19580405001)(83506001)(110136001)(86362001)(31966008)(107046002)(83322001)(95666004)(44976005)(102836001)(85852003)(93886004)(85326001)(77982001)(26826002)(33656002)(64706001)(81156004)(21056001)(57986006)(92566001)(79102001)(50986999)(97736001)(83072002)(33716001)(81342001)(99396002)(6806004)(69596002)(54356999)(19580395003)(74662001)(47776003)(50466002)(80022001)(68736004)(76482001)(23756003)(106466001)(87936001)(92726001)(85306004)(20776003)(74502001)(84676001)(46102001)(81542001)(76176999)(104016003);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB359;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03152A99FF
Authentication-Results: spf=permerror (sender IP is 192.88.158.2)
 smtp.mailfrom=shawn.guo@linaro.org; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2014 at 08:55:56AM +0200, Lothar Waﬂmann wrote:
> The i.MX pwm unit on i.MX27 and newer SoCs provides a configurable
> output polarity. This patch adds support to utilize this feature where
> available.
> 
> Signed-off-by: Lothar Waﬂmann <LW@KARO-electronics.de>

Acked-by: Shawn Guo <shawn.guo@linaro.org>
