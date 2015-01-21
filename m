Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895AbbAUIR6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 03:17:58 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39592 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbbAUIRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 03:17:52 -0500
Date: Wed, 21 Jan 2015 09:17:48 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Samuel Ortiz <sameo@linux.intel.com>, Mark Brown <broonie@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/8] soc: Add MediaTek pericfg controller support
Message-ID: <20150121081748.GC12209@pengutronix.de>
References: <1421747231-554-1-git-send-email-s.hauer@pengutronix.de>
 <1421747231-554-3-git-send-email-s.hauer@pengutronix.de>
 <20150120161555.GH15924@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150120161555.GH15924@leverpostej>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:15:06 up 97 days, 19:28, 116 users,  load average: 0.17, 0.06,
 0.06
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 04:15:55PM +0000, Mark Rutland wrote:
> > +
> > +	pericfg: pericfg@10003000 {
> > +		#reset-cells = <1>;
> > +		#clock-cells = <1>;
> > +		compatible = "mediatek,mt8135-pericfg";
> > +		reg = <0 0x10003000 0 0x1000>;
> > +	};
> 
> This looks identical to the infracfg (same address too). Is that
> deliberate?

Both controllers indeed control clocks and resets, but with a different
register layout, so the nodes really look identical. I'll change the
address to the real address of the MT8135 pericfg though to make the
example more realistic.

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
