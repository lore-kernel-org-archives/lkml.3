Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948AbaLAJV7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 04:21:59 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:45254 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbaLAJV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 04:21:56 -0500
MIME-Version: 1.0
In-Reply-To: <4088467.A4Xd3YfMSv@vostro.rjw.lan>
References: <4088467.A4Xd3YfMSv@vostro.rjw.lan>
Date: Mon, 1 Dec 2014 10:21:54 +0100
X-Google-Sender-Auth: BdkSZgM5z_GElMNOekklifmCTKo
Message-ID: <CAMuHMdU-PH=L4L-Jt8BVCvcFwJJY6PhEEBPWtO3wLhh2ndyA6g@mail.gmail.com>
Subject: Re: [PATCH] PM / Kconfig: Do not select PM directly from Kconfig files
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        Kevin Hilman <khilman@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 29, 2014 at 2:03 AM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> It is not valid to select CONFIG_PM directly without selecting
> CONFIG_PM_SLEEP or CONFIG_PM_RUNTIME too, because that breaks
> dependencies (ia64 does that) and it is not necessary to select
> CONFIG_PM directly if CONFIG_PM_SLEEP or CONFIG_PM_RUNTIME is
> set, because it will be set automatically then (sh does that).
>
> Fix those mistakes.
>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  arch/ia64/Kconfig |    1 -
>  arch/sh/Kconfig   |    1 -

For the sh part:

Acked-by: Geert Uytterhoeven <geert+renesas@glider.be>

Note that sh is orphaned, so you should resend your patch to Andrew Morton,
or queue it yourself.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
