Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab3H2MzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 08:55:21 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:48956
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752210Ab3H2MzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 08:55:19 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275dh1de097hz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Thu, 29 Aug 2013 20:55:19 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Kumar Gala <galak@codeaurora.org>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, <gregkh@linuxfoundation.org>,
        <devicetree@vger.kernel.org>, <linux-serial@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <fabio.estevam@freescale.com>,
        <s.hauer@pengutronix.de>
Subject: Re: [PATCH 1/2] serial: fsl-imx-uart: Cleanup duplicate device tree
 binding
Message-ID: <20130829125517.GJ18729@S2101-09.ap.freescale.net>
References: <1377716903-19699-1-git-send-email-galak@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1377716903-19699-1-git-send-email-galak@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 02:08:22PM -0500, Kumar Gala wrote:
> We had two bindings for the same serial device, it looks like the one in
> tty/serial/fsl-imx-uart.txt is the more up to date one so go with it and
> merge a few things about the use/need for aliases in from
> serial/fsl-imx-uart.txt.
> 
> Signed-off-by: Kumar Gala <galak@codeaurora.org>

Acked-by: Shawn Guo <shawn.guo@linaro.org>

