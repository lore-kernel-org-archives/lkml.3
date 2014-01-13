Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623AbaAMM33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 07:29:29 -0500
Received: from mail-db8lp0184.outbound.messaging.microsoft.com ([213.199.154.184]:40168
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751357AbaAMM31 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 07:29:27 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dIc89bh1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h1de097hz2dh87h2a8h839h947hd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Mon, 13 Jan 2014 20:30:35 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
CC: <linux-arm-kernel@lists.infradead.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Sascha Hauer <kernel@pengutronix.de>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] ARM: dts: imx53: add support for Ka-Ro TX53 modules
Message-ID: <20140113123033.GU23525@S2101-09.ap.freescale.net>
References: <1389609158-11179-1-git-send-email-LW@KARO-electronics.de>
 <1389609158-11179-3-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1389609158-11179-3-git-send-email-LW@KARO-electronics.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 11:32:38AM +0100, Lothar Waﬂmann wrote:
> This patch adds support for the Ka-Ro electronics GmbH TX53 modules.
> There are two distinct module types. One with an LVDS display
> interface and SATA support, the other with a parallel LCD
> interface and no SATA interface.
> 
> Signed-off-by: Lothar Waﬂmann <LW@KARO-electronics.de>

The patch looks good to me.  Ping me when pwm driver changes gets
accepted.

Shawn

