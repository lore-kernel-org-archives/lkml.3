Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873AbaIEPke (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 11:40:34 -0400
Received: from www.linutronix.de ([62.245.132.108]:60774 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbaIEPkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 11:40:32 -0400
Date: Fri, 5 Sep 2014 17:40:28 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Xiubo Li <Li.Xiubo@freescale.com>
cc: daniel.lezcano@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 1/4] Clocksource: Flextimer: Use internal clocksource
 read API.
In-Reply-To: <1409893340-30027-2-git-send-email-Li.Xiubo@freescale.com>
Message-ID: <alpine.DEB.2.10.1409051730270.5472@nanos>
References: <1409893340-30027-1-git-send-email-Li.Xiubo@freescale.com> <1409893340-30027-2-git-send-email-Li.Xiubo@freescale.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Sep 2014, Xiubo Li wrote:

> Since the Flextimer device will be implemented in BE mode on
> LS1 SoC, and in LE mode on Vybrid, LS2 SoCs, so here we need
> the endianness judgment before doing the mmio.

WTF? I explained you in great length HOW you should solve that, but
you just ignore it. Instead of trying to understand what I say you
just resend the same nonsense again.

Keep that attitude up, if you want to make sure, that your patches are
ignored in the future.

Thanks,

	tglx
