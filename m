Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387Ab3FYMXE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 08:23:04 -0400
Received: from www.linutronix.de ([62.245.132.108]:55590 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab3FYMXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 08:23:03 -0400
Date: Tue, 25 Jun 2013 14:23:01 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
cc: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Sascha Hauer <kernel@pengutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jonathan Austin <jonathan.austin@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v4] irqchip: Add support for ARMv7-M's NVIC
In-Reply-To: <CACxGe6vBCKCnXRtvT9N6cRPa7uHTJDMw7k-46eCj7fFPko+Raw@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1306251420330.4013@ionos.tec.linutronix.de>
References: <1371073835-10639-1-git-send-email-u.kleine-koenig@pengutronix.de> <20130625103440.GR11232@pengutronix.de> <CACxGe6vBCKCnXRtvT9N6cRPa7uHTJDMw7k-46eCj7fFPko+Raw@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-593004445-1372162982=:4013"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-593004445-1372162982=:4013
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Tue, 25 Jun 2013, Grant Likely wrote:
> On Tue, Jun 25, 2013 at 11:34 AM, Uwe Kleine-König
> <u.kleine-koenig@pengutronix.de> wrote:
> > Hello Thomas, hello Grant,
> >
> > On Wed, Jun 12, 2013 at 11:50:35PM +0200, Uwe Kleine-König wrote:
> >> This interrupt controller is found on Cortex-M3 and Cortex-M4 machines.
> >>
> >> Support for this controller appeared in Catalin's Cortex tree based on
> >> 2.6.33 but was nearly completely rewritten.
> >>
> >> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> >> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> >> ---
> >>
> >> Notes:
> >>     Changes since v3, sent with
> >>     Message-Id: <1366214540-31166-1-git-send-email-u.kleine-koenig@pengutronix.de>:
> >>
> >>      - use generic chip
> >>      - rename nvic_do_IRQ to nvic_handle_irq
> >>
> >>     This depends on the stuff currently in tip/irq/for-arm
> > I see that tip/irq/for-arm went into next via Grant's irqdomain tree. I
> > assume that means the changes go in for 3.11?
> 
> Yes, the plan is to put that branch into v3.11. I don't know if Thomas
> plans to send a separate pull request for the irq/for-arm branch, or
> if he is going to let it go as part of my pull request. I'll work it

irq/for-arm is in irq/core as well. So whoever sends first will merge
it and the later pull request will just contain the same commits.

> out with him when the merge window opens. It would probably be best
> for your patch to be applied on the irq/for-arm branch and pushed
> separately from my irqdomain branch since I don't maintain any of the
> irqchip drivers.

I can take it via tip/irq/core.

Thanks,

	tglx
--8323329-593004445-1372162982=:4013--
