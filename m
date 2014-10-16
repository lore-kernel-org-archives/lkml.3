Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954AbaJPMJC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 08:09:02 -0400
Received: from www.linutronix.de ([62.245.132.108]:43140 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbaJPMJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 08:09:00 -0400
Date: Thu, 16 Oct 2014 14:08:56 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Walleij <linus.walleij@linaro.org>
cc: linux-kernel@vger.kernel.org, Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: integrator: move AP timer to clocksource
In-Reply-To: <1413444463-15823-1-git-send-email-linus.walleij@linaro.org>
Message-ID: <alpine.DEB.2.11.1410161408350.17020@nanos>
References: <1413444463-15823-1-git-send-email-linus.walleij@linaro.org>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2014, Linus Walleij wrote:

> This moves the timer/clocksource implementation for the
> Integrator/AP down to drivers/clocksource and augments the
> driver a little to use CLOCKSOURCE_OF_DECLARE(). Remove
> the static mapping of the timer blocks while we're at it.
> 
> Tested on the Integrator/AP.
> 
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> Daniel, Thomas: can you ACK this to be taken through ARM SoC?

Acked-by-me
