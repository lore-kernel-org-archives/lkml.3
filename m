Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760960AbbA1Ugt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:36:49 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45183 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760911AbbA1Ugo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:36:44 -0500
Date: Wed, 28 Jan 2015 08:49:07 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Hongzhou Yang <hongzhou.yang@mediatek.com>,
        Sascha Hauer <kernel@pengutronix.de>, Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        "Joe.C" <yingjoe.chen@mediatek.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        dandan.he@mediatek.com, alan.cheng@mediatek.com, toby.liu@mediatek.com,
        maoguang.meng@mediatek.com, huang eddie <eddie.huang@mediatek.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrsoft.com>
Subject: Re: [PATCH v5 2/5] dt-bindings: Add pinctrl bindings for
 mt65xx/mt81xx.
Message-ID: <20150128074907.GY12209@pengutronix.de>
References: <1421818097-9281-1-git-send-email-hongzhou.yang@mediatek.com>
 <1421818097-9281-3-git-send-email-hongzhou.yang@mediatek.com>
 <CACRpkdb5=SX0-xdpngBszcha=R4nPLTSv3b_n=NOtGUL6f2_Fg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdb5=SX0-xdpngBszcha=R4nPLTSv3b_n=NOtGUL6f2_Fg@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:48:43 up 104 days, 19:02, 130 users,  load average: 0.01, 0.07,
 0.09
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 03:19:01PM +0100, Linus Walleij wrote:
> On Wed, Jan 21, 2015 at 6:28 AM, Hongzhou Yang
> <hongzhou.yang@mediatek.com> wrote:
> 
> > From: Hongzhou Yang <hongzhou.yang@mediatek.com>
> >
> > Add devicetree bindings for Mediatek SoC pinctrl driver.
> >
> > Signed-off-by: Hongzhou Yang <hongzhou.yang@mediatek.com>
> 
> Sascha can you ACK this binding?

Just did that.

> If you confirm it will cover also your usecase I'm gonna be happy
> with this...

\o/

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
