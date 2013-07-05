Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644Ab3GEXwE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 19:52:04 -0400
Received: from www.linutronix.de ([62.245.132.108]:47365 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942Ab3GEXwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 19:52:02 -0400
Date: Sat, 6 Jul 2013 01:51:54 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?Heiko_St=FCbner?= <heiko@sntech.de>
cc: John Stultz <john.stultz@linaro.org>, Jamie Iles <jamie@jamieiles.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        Grant Likely <grant.likely@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Ulrich Prinz <ulrich.prinz@googlemail.com>
Subject: Re: [PATCH 6/9] clocksource: dw_apb_timer: quirk for inverted int
 mask
In-Reply-To: <201307060054.35996.heiko@sntech.de>
Message-ID: <alpine.DEB.2.02.1307060150030.32106@ionos.tec.linutronix.de>
References: <201307060051.09716.heiko@sntech.de> <201307060054.35996.heiko@sntech.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1376309650-1373068315=:32106"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1376309650-1373068315=:32106
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Sat, 6 Jul 2013, Heiko Stübner wrote:

> Some timer variants use an inverted setting to mask the timer interrupt.
> Therefore add a quirk to handle these variants.

And by that add even more pointless conditionals into critical code
pathes.


--8323329-1376309650-1373068315=:32106--
