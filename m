Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680AbaKRDwm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 22:52:42 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:42743 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaKRDwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 22:52:41 -0500
From: Kevin Hilman <khilman@kernel.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Linux PM list <linux-pm@vger.kernel.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        LKML <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH] PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is selected
References: <1415917702-6742-1-git-send-email-khilman@kernel.org>
	<6465990.KKns6W8hQE@vostro.rjw.lan>
	<7hioid3cqx.fsf@deeprootsystems.com>
	<1452958.d0yJE5gVgq@vostro.rjw.lan>
Date: Mon, 17 Nov 2014 19:52:37 -0800
In-Reply-To: <1452958.d0yJE5gVgq@vostro.rjw.lan> (Rafael J. Wysocki's message
	of "Tue, 18 Nov 2014 01:39:06 +0100")
Message-ID: <7h61edyxkq.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@rjwysocki.net> writes:

> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> The number of and dependencies between high-level power management
> Kconfig options make life much harder than necessary.  Several
> conbinations of them have to be tested and supported, even though
> some of those combinations are very rarely used in practice (it
> they are used in practice at all).  Moreover, the fact that we
> have separate independent Kconfig options for runtime PM and
> system suspend is a serious obscacle for integration between
> the two frameworks.
>
> To overcome these difficulties, always select PM_RUNTIME if PM_SLEEP
> is set.  Among other things, this will allow system suspend callbacks
> provided by bus types and device drivers to rely on the runtime PM
> framework regardless of the kernel configuration.
>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>
> As a follow up.
>
> Note that we won't need the patch making genpd select PM_RUNTIME with this,
> because genpd already depends on PM.
>
> Thoughts, comments?

Acked-by: Kevin Hilman <khilman@linaro.org>

...with dancing and singing in the streets (or more my speed: a
celebratory beer.) 

Kevin

