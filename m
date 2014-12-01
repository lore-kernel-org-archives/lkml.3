Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836AbaLAKEw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 05:04:52 -0500
Received: from www.linutronix.de ([62.245.132.108]:41723 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415AbaLAKEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 05:04:50 -0500
Date: Mon, 1 Dec 2014 11:04:47 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] x86 / PM: Replace CONFIG_PM_RUNTIME in io_apic.c
In-Reply-To: <5062650.1vTULtXiIc@vostro.rjw.lan>
Message-ID: <alpine.DEB.2.11.1412011101150.3961@nanos>
References: <5062650.1vTULtXiIc@vostro.rjw.lan>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Nov 2014, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> After commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is
> selected) PM_RUNTIME is always set if PM is set, so #ifdef blocks
> depending on CONFIG_PM_RUNTIME may now be changed to depend on
> CONFIG_PM.
> 
> Replace CONFIG_PM_RUNTIME with CONFIG_PM in x86/kernel/apic/io_apic.c.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
> 
> This depends on commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if PM_SLEEP
> is selected) which currently is only in linux-next (via linux-pm).

The function below is moving in linux-next to a different place
.... So it has to wait until everything has hit linus tree.

Feel free to send the cleanups directly to Linus after linux-pm and
x86 has been merged.
 
Thanks,

	tglx
