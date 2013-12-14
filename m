Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab3LNOPG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 09:15:06 -0500
Received: from mail-db9lp0252.outbound.messaging.microsoft.com ([213.199.154.252]:4747
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753791Ab3LNOPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 09:15:02 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzzz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Sat, 14 Dec 2013 22:15:43 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Nicolin Chen <Guangyu.Chen@freescale.com>
CC: <kernel@pengutronix.de>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH 0/2] Add missing audio-related clocks to imx6 clock tree
Message-ID: <20131214141541.GG16177@S2101-09.ap.freescale.net>
References: <cover.1386949189.git.Guangyu.Chen@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1386949189.git.Guangyu.Chen@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 11:44:06PM +0800, Nicolin Chen wrote:
> This series of patches appends some essential clocks of audio IP to the
> current i.MX6 Series clock trees. 
> 
> Nicolin Chen (2):
>   ARM: imx6sl: Add missing pll4_audio_div to the clock tree
>   ARM: imx6sl: Add missing spba clock to clock tree

Applied both, thanks.

