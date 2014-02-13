Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868AbaBMB53 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 20:57:29 -0500
Received: from [216.32.180.30] ([216.32.180.30]:20678 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751320AbaBMB51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 20:57:27 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h17326ah8275bh8275dh1de097h186068hz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Thu, 13 Feb 2014 09:56:19 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Robin Gong <b38343@freescale.com>
CC: <broonie@kernel.org>, <s.hauer@pengutronix.de>,
        <linux-spi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <shijie.huang@freescale.com>
Subject: Re: [PATCH V1] spi: imx: add dma support for ecspi
Message-ID: <20140213015617.GA950@S2101-09.ap.freescale.net>
References: <1392199379-6742-1-git-send-email-b38343@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1392199379-6742-1-git-send-email-b38343@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 06:02:59PM +0800, Robin Gong wrote:
> Add basical dma support for ecspi. Validate on i.MX6qsabresd board.
> 
> Signed-off-by: Robin Gong <b38343@freescale.com>

Robin,

Are you aware of the submission [1] from Frank Li?  You may want to
coordinate the effort with him.

Shawn

[1] http://thread.gmane.org/gmane.linux.ports.arm.kernel/291722

