Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196AbaCTIbe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 04:31:34 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49038 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071AbaCTIbc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 04:31:32 -0400
From: Juergen Beisert <jbe@pengutronix.de>
Organization: Pengutronix e.K.
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] mtd: gpmi: make blockmark swapping optional
Date: Thu, 20 Mar 2014 09:33:39 +0100
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: y@karo-electronics.de, Arnd Bergmann <arnd@arndb.de>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Huang Shijie <b32955@freescale.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Lothar =?utf-8?q?Wa=C3=9Fmann?= <LW@karo-electronics.de>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Sascha Hauer <kernel@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org
References: <1395235406-13449-1-git-send-email-y>
In-Reply-To: <1395235406-13449-1-git-send-email-y>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201403200933.39382.jbe@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5e26:aff:fe2b:7cc4
X-SA-Exim-Mail-From: jbe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lothar,

On Wednesday 19 March 2014 14:23:26 y@karo-electronics.de wrote:
> With a flash-based BBT there is no reason to move the Factory Bad
> Block Marker from the data area buffer (to where it is mapped by the
> GPMI NAND controller) to the OOB buffer. Thus, make this feature
> configurable via DT. This is required for the Ka-Ro electronics
> platforms.
> [...]

How do you create the BBT the very first time with valuable data when the NAND 
already contains factory bad blocks?

jbe

-- 
Pengutronix e.K.                              | Juergen Beisert             |
Linux Solutions for Science and Industry      | http://www.pengutronix.de/  |
