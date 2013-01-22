Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650Ab3AVFqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 00:46:24 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:50544 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750899Ab3AVFqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 00:46:22 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI1432I1447Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Tue, 22 Jan 2013 14:14:35 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
CC: Alan Stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <arm@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>,
        Manjunath Goudar <manjunath.goudar@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>
Subject: Re: [PATCH 13/15] USB: ehci: make orion and mxc bus glues coexist
Message-ID: <20130122061433.GA4479@S2100-06.ap.freescale.net>
References: <Pine.LNX.4.44L0.1301211459550.24224-100000@netrider.rowland.org>
 <201301212137.42611.arnd@arndb.de>
 <20130122061116.GD29677@S2100-06.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130122061116.GD29677@S2100-06.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 02:11:18PM +0800, Shawn Guo wrote:
> Alan,
> 
> Thanks for the patch.  I just gave it try.  The USB Host port still
> works for me with a couple of fixes on your changes integrated (one
> for compiling and the other for probing).  So you have my ACK with
> the changes below rolled into your patch.
> 
> Acked-by: Shawn Guo <shawn.guo@linaro.org>
> 
Sorry.  I meant a Test tag.

Tested-by: Shawn Guo <shawn.guo@linaro.org>

