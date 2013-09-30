Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531Ab3I3BYD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 21:24:03 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:42076 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437Ab3I3BX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 21:23:59 -0400
Date: Mon, 30 Sep 2013 01:23:58 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
cc: Stephen Warren <swarren@wwwdotorg.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>,
        Grant Likely <grant.likely@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kumar Gala <galak@codeaurora.org>, Pawel Moll <pawel.moll@arm.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Balaji T K <balajitk@ti.com>, Tony Lindgren <tony@atomide.com>,
        Jon Hunter <jgchunter@gmail.com>, linux-gpio@vger.kernel.org,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, r.sricharan@ti.com, holler@ahsoftware.de,
        aaro.koskinen@iki.fi, joelf@ti.com
Subject: Re: [RFC v2] gpio/omap: auto-setup a GPIO when used as an IRQ
In-Reply-To: <52453545.3090504@collabora.co.uk>
Message-ID: <alpine.DEB.2.02.1309300122450.17980@utopia.booyaka.com>
References: <1380009480-4975-1-git-send-email-javier.martinez@collabora.co.uk> <5244C0C4.2030004@wwwdotorg.org> <52453545.3090504@collabora.co.uk>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Sep 2013, Javier Martinez Canillas wrote:

> I cc'ed Aaro Koskinen and Paul Walmsley now which seems to have OMAP1 platforms
> to test. Could you please test [1] and [2] on a OMAP1 board? These patches
> solves a long standing issue we have on OMAP2+ when booting with DT and it would
> be great if you can check that it does not cause regressions on OMAP1 based boards.

Unfortunately my OMAP1 test platform is down at the moment, so am not able 
to test.  But saw that it passed Aaro's tests, so I'd say that's a pretty 
good endorsement.


- Paul
