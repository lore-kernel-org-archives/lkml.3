Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716Ab3AXFjY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 00:39:24 -0500
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:32079
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750709Ab3AXFjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 00:39:18 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Thu, 24 Jan 2013 14:07:47 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Brian Lilly <brian@crystalfontz.com>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: mxs: dt: Add Crystalfontz CFA-10037 device tree
 support
Message-ID: <20130124060744.GA16959@S2100-06.ap.freescale.net>
References: <1358872551-14490-1-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1358872551-14490-1-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 05:35:51PM +0100, Maxime Ripard wrote:
> The CFA-10037 is another expansion board for the CFA-10036 module, with
> only a USB Host, a Ethernet device and a lot of gpios.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  arch/arm/boot/dts/imx28-cfa10037.dts |   77 ++++++++++++++++++++++++++++++++++

Please add the dtb target into arch/arm/boot/dts/Makfile.

Shawn

>  arch/arm/mach-mxs/mach-mxs.c         |    8 ++++
>  2 files changed, 85 insertions(+)
>  create mode 100644 arch/arm/boot/dts/imx28-cfa10037.dts

