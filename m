Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448Ab3LXIVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 03:21:18 -0500
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:13461
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751386Ab3LXIVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 03:21:17 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Tue, 24 Dec 2013 16:22:54 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Anson Huang <b20788@freescale.com>
CC: <kernel@pengutronix.de>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: imx: add necessary interface for pfd
Message-ID: <20131224082252.GG3872@S2101-09.ap.freescale.net>
References: <1387911938-4828-1-git-send-email-b20788@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1387911938-4828-1-git-send-email-b20788@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 24, 2013 at 02:05:38PM -0500, Anson Huang wrote:
> Common clk framework will disable unused clks in late init only if
> they are enabled by default and no one is using it, so we need to
> add is_enabled callback for clk framework to get clks' status.
> 
> PFD clocks are enabled by hardware reset, so we need to add
> interface for common clk framework to disable those unused ones for
> saving power.
> 
> Signed-off-by: Anson Huang <b20788@freescale.com>

Applied, thanks. 

