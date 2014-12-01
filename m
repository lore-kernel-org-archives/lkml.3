Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932579AbaLAWVb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 17:21:31 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:53321 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753934AbaLAWVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 17:21:30 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        Kevin Hilman <khilman@kernel.org>
Subject: Re: [PATCH] PM / Kconfig: Do not select PM directly from Kconfig files
Date: Mon, 01 Dec 2014 23:42:52 +0100
Message-ID: <1709855.vJRHLWCgos@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAMuHMdU-PH=L4L-Jt8BVCvcFwJJY6PhEEBPWtO3wLhh2ndyA6g@mail.gmail.com>
References: <4088467.A4Xd3YfMSv@vostro.rjw.lan> <CAMuHMdU-PH=L4L-Jt8BVCvcFwJJY6PhEEBPWtO3wLhh2ndyA6g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 01, 2014 10:21:54 AM Geert Uytterhoeven wrote:
> On Sat, Nov 29, 2014 at 2:03 AM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >
> > It is not valid to select CONFIG_PM directly without selecting
> > CONFIG_PM_SLEEP or CONFIG_PM_RUNTIME too, because that breaks
> > dependencies (ia64 does that) and it is not necessary to select
> > CONFIG_PM directly if CONFIG_PM_SLEEP or CONFIG_PM_RUNTIME is
> > set, because it will be set automatically then (sh does that).
> >
> > Fix those mistakes.
> >
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > ---
> >  arch/ia64/Kconfig |    1 -
> >  arch/sh/Kconfig   |    1 -
> 
> For the sh part:
> 
> Acked-by: Geert Uytterhoeven <geert+renesas@glider.be>

Thanks!

> Note that sh is orphaned, so you should resend your patch to Andrew Morton,
> or queue it yourself.

Since it depends on material already in my tree, I'm going to queue it up myself.

Rafael

