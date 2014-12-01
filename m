Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596AbaLAWGX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 17:06:23 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:54447 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932349AbaLAWGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 17:06:21 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] x86 / PM: Replace CONFIG_PM_RUNTIME in io_apic.c
Date: Mon, 01 Dec 2014 23:27:44 +0100
Message-ID: <7023353.kvFs3YG3uq@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <alpine.DEB.2.11.1412011101150.3961@nanos>
References: <5062650.1vTULtXiIc@vostro.rjw.lan> <alpine.DEB.2.11.1412011101150.3961@nanos>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 01, 2014 11:04:47 AM Thomas Gleixner wrote:
> On Sat, 29 Nov 2014, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > 
> > After commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is
> > selected) PM_RUNTIME is always set if PM is set, so #ifdef blocks
> > depending on CONFIG_PM_RUNTIME may now be changed to depend on
> > CONFIG_PM.
> > 
> > Replace CONFIG_PM_RUNTIME with CONFIG_PM in x86/kernel/apic/io_apic.c.
> > 
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > ---
> > 
> > This depends on commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if PM_SLEEP
> > is selected) which currently is only in linux-next (via linux-pm).
> 
> The function below is moving in linux-next to a different place
> .... So it has to wait until everything has hit linus tree.
> 
> Feel free to send the cleanups directly to Linus after linux-pm and
> x86 has been merged.

OK, I will.  Thanks!

Rafael

