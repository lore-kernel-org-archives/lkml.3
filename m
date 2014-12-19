Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152AbaLSCBX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 21:01:23 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:64533 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751881AbaLSCBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 21:01:20 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Kevin Hilman <khilman@kernel.org>, Jiri Slaby <jslaby@suse.cz>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH 3/4] tty: 8250_omap: Replace CONFIG_PM_RUNTIME with CONFIG_PM
Date: Fri, 19 Dec 2014 03:23:06 +0100
Message-ID: <1717301.JY7Dj69iXr@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141219015717.GB13956@kroah.com>
References: <472992175.g1ArEYGFPo@vostro.rjw.lan> <1897135.rk4lcWQyIt@vostro.rjw.lan> <20141219015717.GB13956@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 18, 2014 05:57:17 PM Greg Kroah-Hartman wrote:
> On Fri, Dec 19, 2014 at 02:55:00AM +0100, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > 
> > The 8250_omap serial driver is a new user of CONFIG_PM_RUNTIME.
> > 
> > However, after commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if
> > PM_SLEEP is selected) PM_RUNTIME is always set if PM is set, so
> > #ifdef blocks depending on CONFIG_PM_RUNTIME may now be changed to
> > depend on CONFIG_PM.
> > 
> > Replace CONFIG_PM_RUNTIME with CONFIG_PM in 8250_omap.c.
> > 
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > ---
> > 
> > Please let me know if there are any objections against pushing this through
> > the linux-pm tree.
> 
> Please do:
> 
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Thanks!

