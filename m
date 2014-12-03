Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840AbaLCLiR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:38:17 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:51678 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbaLCLiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:38:14 -0500
MIME-Version: 1.0
X-Originating-IP: [95.23.62.239]
In-Reply-To: <1655942.O63mJN07or@vostro.rjw.lan>
References: <1655942.O63mJN07or@vostro.rjw.lan>
Date: Wed, 3 Dec 2014 12:38:12 +0100
Message-ID: <CABxcv=n-ADTXRaS6_K=B7UZEi9aCysNgS9yMs8jiZWY-2yqRLQ@mail.gmail.com>
Subject: Re: [PATCH] gpio / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
From: Javier Martinez Canillas <javier@dowhile0.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Linux GPIO List <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Rafael,

On Wed, Dec 3, 2014 at 2:50 AM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> After commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is
> selected) PM_RUNTIME is always set if PM is set, so #ifdef blocks
> depending on CONFIG_PM_RUNTIME may now be changed to depend on
> CONFIG_PM.
>
> Replace CONFIG_PM_RUNTIME with CONFIG_PM in drivers/gpio/gpio-omap.c.
>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---

Acked-by: Javier Martinez Canillas <javier@dowhile0.org>

>
> Note: This depends on commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if
> PM_SLEEP is selected) which is only in linux-next at the moment (via the
> linux-pm tree).
>
> Please let me know if it is OK to take this one into linux-pm.
>

AFAICT there isn't another patch for gpio-omap on this cycle so I'm OK
if you take this through linux-pm.

Best regards,
Javier
