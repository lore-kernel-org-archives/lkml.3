Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912AbaHOQzb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 12:55:31 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57825 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbaHOQzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 12:55:25 -0400
Date: Fri, 15 Aug 2014 18:54:37 +0200
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Thor Thayer <tthayer@opensource.altera.com>
Cc: atull <atull@opensource.altera.com>, robherring2@gmail.com,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        linux@arm.linux.org.uk, delicious.quinoa@gmail.com,
        dinguyen@opensource.altera.com, dougthompson@xmission.com,
        grant.likely@linaro.org, bp@alien8.de, sameo@linux.intel.com,
        lee.jones@linaro.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tthayer.linux@gmail.com
Subject: Re: [PATCHv10 2/2] arm: dts: Add Altera SDRAM EDAC bindings &
 devicetree entries.
Message-ID: <20140815165437.GB19071@pengutronix.de>
References: <1407770293-27190-1-git-send-email-tthayer@opensource.altera.com>
 <1407770293-27190-3-git-send-email-tthayer@opensource.altera.com>
 <73vbputf04.fsf@dude.hi.pengutronix.de>
 <alpine.DEB.2.02.1408151035110.21645@atx-linux-37>
 <53EE398D.3060509@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53EE398D.3060509@opensource.altera.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 18:48:34 up 42 days,  3:24, 35 users,  load average: 0,03, 0,03,
 0,05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: str@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2014 at 11:47:09AM -0500, Thor Thayer wrote:
> Hi Steffen!
> 
> Building on Alan's points, I don't see the reference to the child
> nodes in the syscon.txt binding documentation - can you point out
> what I'm missing?
> 
> I based this patch on other examples of syscon, and there aren't
> child nodes (exynos5250.dtsi, omap3.dtsi, etc). According to my
> understanding of the device tree parsing, the parent needs to
> register child nodes. Since syscon is the parent and doesn't
> register the child nodes, they won't be automatically probed. The
> other syscon implementations are at the same level as the syscon and
> use a phandle to the syscon (for instance the omap3.dtsi).
> 
> Thanks for reviewing!
> 
> Thor

Hm, I looked in one of my many directories with some version of the
kernel tree checked out, but ... you are right.
I can't find where I read that. Seems like I got confused somewhere...
There is now version of syscon.txt that mentions anything about childs.

Should have drank my morning coffee first.

Regards,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
