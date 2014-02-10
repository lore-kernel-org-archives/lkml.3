Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751630AbaBJHPg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 02:15:36 -0500
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:57641
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750797AbaBJHPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 02:15:34 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(z579ehz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275dh1de097hz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Mon, 10 Feb 2014 15:15:59 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: <linux-kernel@vger.kernel.org>, Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Anson Huang <b20788@freescale.com>, <kernel@pengutronix.de>
Subject: Re: [PATCH 1/2] regulator: anatop: Add power gating support to
 digital LDOs
Message-ID: <20140210071556.GL9628@S2101-09.ap.freescale.net>
References: <1391697813-20091-1-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1391697813-20091-1-git-send-email-p.zabel@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 06, 2014 at 03:43:32PM +0100, Philipp Zabel wrote:
> The ARM, PU, and SOC LDOs in the i.MX6 PMU can completely gate
> their power output. Since power gating is configured by writing
> zero to the voltage target bitfield,, store a copy of the
> voltage selector to be restored when reenabling the regulator.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

Nice way to get disabling and bypass supported!  For both patches,

Acked-by: Shawn Guo <shawn.guo@linaro.org>

