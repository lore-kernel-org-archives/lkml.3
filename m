Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616AbaLCCd4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 21:33:56 -0500
Received: from mail-ig0-f170.google.com ([209.85.213.170]:62977 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbaLCCdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 21:33:54 -0500
MIME-Version: 1.0
In-Reply-To: <1655942.O63mJN07or@vostro.rjw.lan>
References: <1655942.O63mJN07or@vostro.rjw.lan>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Wed, 3 Dec 2014 11:33:33 +0900
Message-ID: <CAAVeFuKHYnPgCLFC+0QjYGyPxJ3fddGJkvmUk+=L0TZqsprXWQ@mail.gmail.com>
Subject: Re: [PATCH] gpio / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
        Javier Martinez Canillas <javier@dowhile0.org>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>, linux-omap@vger.kernel.org,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 3, 2014 at 10:50 AM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
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

Acked-by: Alexandre Courbot <acourbot@nvidia.com>
