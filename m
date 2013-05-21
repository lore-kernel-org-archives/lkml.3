Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758632Ab3EUCk5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 22:40:57 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:59550
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753426Ab3EUCk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 22:40:56 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 7
X-BigFish: VS7(z329eqz98dI1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bh8275dhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h1151h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Tue, 21 May 2013 10:41:14 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Fabio Estevam <fabio.estevam@freescale.com>
CC: <gregkh@linuxfoundation.org>, <kernel@pengutronix.de>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] imx-drm: parallel-display: Let device core handle
 pinctrl
Message-ID: <20130521024113.GD3080@S2101-09.ap.freescale.net>
References: <1369058151-24986-1-git-send-email-fabio.estevam@freescale.com>
 <1369058151-24986-3-git-send-email-fabio.estevam@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1369058151-24986-3-git-send-email-fabio.estevam@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 20, 2013 at 10:55:51AM -0300, Fabio Estevam wrote:
> Since commit ab78029 (drivers/pinctrl: grab default handles from device core)
> we can rely on device core for handling pinctrl, so remove 
> devm_pinctrl_get_select_default() from the driver.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Acked-by: Shawn Guo <shawn.guo@linaro.org>

