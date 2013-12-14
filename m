Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731Ab3LNOOm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 09:14:42 -0500
Received: from mail-db9lp0252.outbound.messaging.microsoft.com ([213.199.154.252]:36057
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751407Ab3LNOOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 09:14:41 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Sat, 14 Dec 2013 22:15:19 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Nicolin Chen <Guangyu.Chen@freescale.com>
CC: <kernel@pengutronix.de>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: imx6: Derive spdif clock from pll3_pfd3_454m
Message-ID: <20131214141518.GF16177@S2101-09.ap.freescale.net>
References: <1386949072-6520-1-git-send-email-Guangyu.Chen@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1386949072-6520-1-git-send-email-Guangyu.Chen@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 11:37:52PM +0800, Nicolin Chen wrote:
> SPDIF can derive a TX clock for playback from one of its clock sources --
> spdif root clock to match its supporting sample rates. So this patch set
> the spdif root clock's parent to pll3_pfd3_454m since the pll3_pfd3_454m
> can approximately meet its sample rate requirement.
> 
> Signed-off-by: Nicolin Chen <Guangyu.Chen@freescale.com>

Applied, thanks.

