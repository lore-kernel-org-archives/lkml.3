Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932656AbaDCBwO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 21:52:14 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:7635
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932530AbaDCBwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 21:52:12 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h2148h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzz1de098h1de097hz2dh2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h16a6h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h262fh268bh26d3h1155h)
Date: Thu, 3 Apr 2014 09:52:00 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: <stefan@agner.ch>
CC: <kernel@pengutronix.de>, <viresh.linux@gmail.com>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] ARM: dts: mx5: fix wrong stmpe-ts bindings
Message-ID: <20140403015158.GB2786@dragon>
References: <cover.1396457876.git.stefan@agner.ch>
 <94a8b96fe30ce97ec89e49ef6470271888024256.1396457876.git.stefan@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <94a8b96fe30ce97ec89e49ef6470271888024256.1396457876.git.stefan@agner.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2014 at 07:05:37PM +0200, stefan@agner.ch wrote:
> From: Stefan Agner <stefan@agner.ch>
> 
> Fix bindings for STMPE touchscreen controller to match the documented
> bindings and the actual bindings used by the driver.
> 
> Signed-off-by: Stefan Agner <stefan@agner.ch>
> Reviewed-by: Marek Vasut <marex@denx.de>

Applied, thanks.

