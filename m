Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058AbaCAPbK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 10:31:10 -0500
Received: from www.linutronix.de ([62.245.132.108]:47048 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004AbaCAPbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 10:31:08 -0500
Date: Sat, 1 Mar 2014 16:31:13 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: James Hogan <james.hogan@imgtec.com>
cc: Jean-Jacques Hiblot <jjhiblot@traphandler.com>, linus.walleij@linaro.org,
        grant.likely@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] irq: Changed the return type of irq_chip.irq_startup()
 from unsigned int to int
In-Reply-To: <7150036.UpHTd1PK1K@radagast>
Message-ID: <alpine.DEB.2.02.1403011629540.18573@ionos.tec.linutronix.de>
References: <CACh+v5Nkuct0J65OHcnSd6Dfq4EyfafY8RpTvdwKXUA7A8_+Xw@mail.gmail.com> <1393521679-32331-1-git-send-email-jjhiblot@traphandler.com> <7150036.UpHTd1PK1K@radagast>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Feb 2014, James Hogan wrote:
> On Thursday 27 February 2014 18:21:19 Jean-Jacques Hiblot wrote:
> >  drivers/irqchip/irq-metag.c               | 4 ++--
> 
> I think you've missed out drivers/irqchip/irq-metag-ext.c

There is a good reason why I asked to do this with coccinelle.

Thanks,

	tglx

