Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158AbaJYStv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 14:49:51 -0400
Received: from www.linutronix.de ([62.245.132.108]:50858 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbaJYSst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 14:48:49 -0400
Date: Sat, 25 Oct 2014 11:55:11 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
cc: linux-arm-kernel@lists.infradead.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        linux-kernel@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH 1/2] clocksource: enable pxa_timer for SA-1100 platform
In-Reply-To: <10546062.ah0Qvxpsuh@wuerfel>
Message-ID: <alpine.DEB.2.11.1410251154280.5308@nanos>
References: <1413377405-7503-1-git-send-email-dbaryshkov@gmail.com> <10546062.ah0Qvxpsuh@wuerfel>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Oct 2014, Arnd Bergmann wrote:

> On Wednesday 15 October 2014 16:50:04 Dmitry Eremin-Solenikov wrote:
> > SA-11x0 platform used the same IP block as was used on PXA. Consequently
> > it makes sense to have only one driver. Enable pxa_timer clocksource for
> > StrongARM platform.
> > 
> > Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> 
> Both patches look good to me.
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
> Should we merge them through arm-soc or through the clocksource tree?

It touches arm, so please take it through arm-soc with my acked-by.

Thanks,

	tglx
