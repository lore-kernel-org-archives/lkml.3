Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946Ab3EaWhQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 18:37:16 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:59720 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756990Ab3EaWhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 18:37:08 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH 11/21] irqdomain: export irq_domain_add_simple
To: Simon Horman <horms@verge.net.au>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Magnus Damm <damm@opensource.se>
In-Reply-To: <20130426005012.GB20070@verge.net.au>
References: <1366910944-3033663-1-git-send-email-arnd@arndb.de> <1366910944-3033663-12-git-send-email-arnd@arndb.de> <20130426005012.GB20070@verge.net.au>
Date: Fri, 31 May 2013 23:37:03 +0100
Message-Id: <20130531223703.CFB573E08FE@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Apr 2013 09:50:12 +0900, Simon Horman <horms@verge.net.au> wrote:
> On Thu, Apr 25, 2013 at 07:28:54PM +0200, Arnd Bergmann wrote:
> > All other irq_domain_add_* functions are exported already, and apparently
> > this one got left out by mistake, which causes build errors for ARM
> > allmodconfig kernels:
> > 
> > ERROR: "irq_domain_add_simple" [drivers/gpio/gpio-rcar.ko] undefined!
> > ERROR: "irq_domain_add_simple" [drivers/gpio/gpio-em.ko] undefined!
> > 
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > Cc: Grant Likely <grant.likely@linaro.org>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Simon Horman <horms+renesas@verge.net.au>
> > Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> > Cc: Magnus Damm <damm@opensource.se>
> 
> Acked-by: Simon Horman <horms+renesas@verge.net.au>
> 
> Grant, could consider taking this one?
> 

Applied, thanks. I'll push out to Linus shortly.

g.
