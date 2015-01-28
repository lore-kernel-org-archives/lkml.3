Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760567AbbA1Voz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:44:55 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45185 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760917AbbA1Ugr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:36:47 -0500
Date: Wed, 28 Jan 2015 08:48:38 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Hongzhou Yang <hongzhou.yang@mediatek.com>
Cc: Rob Herring <robh+dt@kernel.org>, Linus Walleij <linus.walleij@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>, eddie.huang@mediatek.com,
        linux-kernel@vger.kernel.org, alan.cheng@mediatek.com,
        maoguang.meng@mediatek.com,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>, toby.liu@mediatek.com,
        Sascha Hauer <kernel@pengutronix.de>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        "Joe.C" <yingjoe.chen@mediatek.com>, dandan.he@mediatek.com,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrsoft.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 2/5] dt-bindings: Add pinctrl bindings for
 mt65xx/mt81xx.
Message-ID: <20150128074838.GX12209@pengutronix.de>
References: <1421818097-9281-1-git-send-email-hongzhou.yang@mediatek.com>
 <1421818097-9281-3-git-send-email-hongzhou.yang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421818097-9281-3-git-send-email-hongzhou.yang@mediatek.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:46:40 up 104 days, 19:00, 130 users,  load average: 0.10, 0.10,
 0.10
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 01:28:14PM +0800, Hongzhou Yang wrote:
> From: Hongzhou Yang <hongzhou.yang@mediatek.com>
> 
> Add devicetree bindings for Mediatek SoC pinctrl driver.
> 
> Signed-off-by: Hongzhou Yang <hongzhou.yang@mediatek.com>

This basically follows the pinmux binding I suggested as generic pinmux
binding for per-pin type controllers, so:

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
