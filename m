Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114AbaCDPqL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 10:46:11 -0500
Received: from www.linutronix.de ([62.245.132.108]:34356 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbaCDPqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 10:46:09 -0500
Date: Tue, 4 Mar 2014 16:46:14 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alexander Shiyan <shc_work@mail.ru>
cc: linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH] irq: Export symbol no_action()
In-Reply-To: <1393931733.877810306@f371.i.mail.ru>
Message-ID: <alpine.DEB.2.02.1403041645060.18573@ionos.tec.linutronix.de>
References: <1393656316-26757-1-git-send-email-shc_work@mail.ru> <alpine.DEB.2.02.1403041203540.18573@ionos.tec.linutronix.de> <1393931733.877810306@f371.i.mail.ru>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1276902186-1393947975=:18573"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1276902186-1393947975=:18573
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Tue, 4 Mar 2014, Alexander Shiyan wrote:

> Вторник,  4 марта 2014, 12:05 +01:00 от Thomas Gleixner <tglx@linutronix.de>:
> > On Sat, 1 Mar 2014, Alexander Shiyan wrote:
> > 
> > > This will allow to use dummy IRQ handler no_action() from
> > > drivers compiled as module. For example, dummy handler is could
> > > be used for drivers that use ARM FIQ interrupts.
> > 
> > And why exactly requires a driver which uses ARM FIQ interrupts the
> > no_action implementation?
>
 
> FIQ Interrupt handler is not used in this function. In FIQ case this
> is just a dummy declaration. Real handler is assigned by using the
> set_fiq_handler().

Why do you need a dummy declaration at all?

set_fiq_handler() is completely detached from the generic interrupt
subsystem.

Thanks,

	tglx
--8323329-1276902186-1393947975=:18573--
