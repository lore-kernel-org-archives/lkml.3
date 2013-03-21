Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589Ab3CUSPo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 14:15:44 -0400
Received: from mail-ia0-f176.google.com ([209.85.210.176]:65181 "EHLO
	mail-ia0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549Ab3CUSPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 14:15:38 -0400
MIME-Version: 1.0
In-Reply-To: <1363820051-24428-11-git-send-email-robherring2@gmail.com>
References: <1363820051-24428-1-git-send-email-robherring2@gmail.com>
	<1363820051-24428-11-git-send-email-robherring2@gmail.com>
Date: Thu, 21 Mar 2013 19:15:38 +0100
Message-ID: <CACRpkdYvY9BRAikAyyFHvg8uaWK7msOhVSDFG_zRZQJhG1cuAA@mail.gmail.com>
Subject: Re: [PATCH 10/11] ARM: move sp804 and integrator timers to drivers/clocksource
From: Linus Walleij <linus.walleij@linaro.org>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>, haojian.zhuang@linaro.org,
        pawel.moll@arm.com, john.stultz@linaro.org, tglx@linutronix.de,
        Rob Herring <rob.herring@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 11:54 PM, Rob Herring <robherring2@gmail.com> wrote:

> From: Rob Herring <rob.herring@calxeda.com>
>
> Move timer-sp and integrator-ap timer code to drivers/clocksource and
> update timer-sp.h and arm_timer.h includes.
>
> This adds CLKSRC_OF support for the integrator-ap timer and removes the
> use of "arm,timer-primary" and "arm,timer-secondary" aliases. The timer
> selection should not be important as all 3 timers are equal capability.
>
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>

Nice!

This looks like it'll work.

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
