Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932426Ab3IPLMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 07:12:17 -0400
Received: from www.linutronix.de ([62.245.132.108]:47459 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371Ab3IPLMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 07:12:16 -0400
Date: Mon, 16 Sep 2013 13:12:13 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [GIT pull] timers core for 3.12
In-Reply-To: <alpine.DEB.2.02.1309161158280.4089@ionos.tec.linutronix.de>
Message-ID: <alpine.DEB.2.02.1309161311070.4089@ionos.tec.linutronix.de>
References: <alpine.DEB.2.02.1309161158280.4089@ionos.tec.linutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Sep 2013, Thomas Gleixner wrote:

> Linus,
> 
> please pull the latest timers/core git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers/core
> 
>  * armada SoC clocksource overhaul with a trivial merge conflict
>  * Minor improvements to various SoC clocksource drivers

Sorry for sending it late. It got delayed in various ways and
unfortunately there is stuff already merged via the SoC tree which
depends on this :(

Thanks,

	tglx
