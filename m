Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbaLSB5U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 20:57:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59680 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbaLSB5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 20:57:18 -0500
Date: Thu, 18 Dec 2014 17:57:17 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Kevin Hilman <khilman@kernel.org>, Jiri Slaby <jslaby@suse.cz>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH 3/4] tty: 8250_omap: Replace CONFIG_PM_RUNTIME with
 CONFIG_PM
Message-ID: <20141219015717.GB13956@kroah.com>
References: <472992175.g1ArEYGFPo@vostro.rjw.lan>
 <1897135.rk4lcWQyIt@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1897135.rk4lcWQyIt@vostro.rjw.lan>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2014 at 02:55:00AM +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> The 8250_omap serial driver is a new user of CONFIG_PM_RUNTIME.
> 
> However, after commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if
> PM_SLEEP is selected) PM_RUNTIME is always set if PM is set, so
> #ifdef blocks depending on CONFIG_PM_RUNTIME may now be changed to
> depend on CONFIG_PM.
> 
> Replace CONFIG_PM_RUNTIME with CONFIG_PM in 8250_omap.c.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
> 
> Please let me know if there are any objections against pushing this through
> the linux-pm tree.

Please do:

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
