Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323Ab3GYIk5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 04:40:57 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:29878
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751436Ab3GYIkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 04:40:53 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zz98dIzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de097hz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Thu, 25 Jul 2013 16:40:44 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Robin Gong <b38343@freescale.com>
CC: <broonie@kernel.org>, <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <rob@landley.net>, <lgirdwood@gmail.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <s.trumtrar@pengutronix.de>
Subject: Re: [PATCH v5] regulator: pfuze100: add pfuze100 regulator driver
Message-ID: <20130725084042.GA19368@S2101-09.ap.freescale.net>
References: <1374723198-9716-1-git-send-email-b38343@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1374723198-9716-1-git-send-email-b38343@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 11:33:18AM +0800, Robin Gong wrote:
> @@ -0,0 +1,113 @@
> +PFUZE100 family of regulators
> +
> +Required properties:
> +- compatible: "fsl,pfuze100"
> +- reg: I2C slave address
> +- regulators: This is the list of child nodes that specify the regulator
> +  initialization data for defined regulators. Please refer to below doc
> +  Documentation/devicetree/bindings/regulator/regulator.txt.

I had the comment on v4 patch.  The "regulators" should not be
documented as a property but a sub-node, because it's not a property
but sub-node.

Shawn

