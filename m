Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968173AbaLLOhg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 09:37:36 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:61129 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S967493AbaLLOhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 09:37:34 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Jonathan Cameron <jic23@kernel.org>
Cc: linux-iio@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Hartmut Knaack <knaack.h@gmx.de>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] iio / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
Date: Fri, 12 Dec 2014 15:59:11 +0100
Message-ID: <36391107.O5xXXLZB0Z@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <548ADFBA.6000303@kernel.org>
References: <202529361.GBbZ7zGgn8@vostro.rjw.lan> <548ADFBA.6000303@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, December 12, 2014 12:29:46 PM Jonathan Cameron wrote:
> On 03/12/14 02:06, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > 
> > After commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is
> > selected) PM_RUNTIME is always set if PM is set, so #ifdef blocks
> > depending on CONFIG_PM_RUNTIME may now be changed to depend on
> > CONFIG_PM.
> > 
> > Replace CONFIG_PM_RUNTIME with CONFIG_PM everywhere under
> > drivers/iio/.
> > 
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Acked-by: Jonathan Cameron <jic23@kernel.org>

Thanks!

> > ---
> > 
> > Note: This depends on commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if
> > PM_SLEEP is selected) which is only in linux-next at the moment (via the
> > linux-pm tree).
> > 
> > Please let me know if it is OK to take this one into linux-pm.
> It is.  If I took too long to reply and the dependency merged
> in the current window, I can take these through IIO if you'd prefer?

I guess it still will be more convenient to take them through linux-pm,
as I'm going to follow up with a patch that removes CONFIG_PM_RUNTIME
entirely when I'm done with all of the users of it.


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
