Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900Ab3LNTDZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 14:03:25 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:2146 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612Ab3LNTDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 14:03:24 -0500
Date: Sat, 14 Dec 2013 20:03:09 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH 00/12] i8k patch series
Message-ID: <20131214200309.3a2007f4@endymion.delvare>
In-Reply-To: <201312141945.20348.arnd@arndb.de>
References: <1387042221-3671-1-git-send-email-linux@roeck-us.net>
	<201312141945.20348.arnd@arndb.de>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Dec 2013 19:45:19 +0100, Arnd Bergmann wrote:
> On Saturday 14 December 2013, Guenter Roeck wrote:
> > Clean up and simplify the driver, add support for additional temperature
> > sensors, fix a problem seen with multi-core CPU, and add support
> > for additional systems.
> > 
> > ----------------------------------------------------------------
> > Guenter Roeck (14):
> >       i8k: Convert to use pr_ functions instead of printk
> >       i8k: Fix various checkpatch warnings and errors
> >       i8k: Convert to use to hwmon_device_register_with_groups hwmon API
> >       i8k: Support additional temperature sensors
> >       MAINTAINERS: Add myself as i8k maintainer
> >       i8k: Remove obsolete link to out-of-tree driver
> >       i8k: Drop driver version number and info message at startup
> >       i8k: Force SMM to run on CPU 0
> >       i8k: Add copyright
> >       i8k: Add support for Dell Studio laptops
> >       i8k: Add support for Dell XPS M140
> >       i8k: Use driver_data field of dmi_system_id to override fan multiplier
> >       i8k: Stop reading SMM BIOS version during driver probe
> >       i8k: Implement hwmon based fan speed control
> > 
> >  MAINTAINERS        |    2 +-
> >  drivers/char/i8k.c |  358 +++++++++++++++++++++++++++++-----------------------
> >  2 files changed, 201 insertions(+), 159 deletions(-)
> > 
> 
> All changes in this patch set look good to me.
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
> I wonder if it makes sense to move the driver to drivers/platform/x86/, which
> has a bunch of similar ones already.

That would be a good idea IMHO.

-- 
Jean Delvare
