Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609Ab3HBIQe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 04:16:34 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57513 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754469Ab3HBIQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 04:16:31 -0400
Date: Fri, 2 Aug 2013 10:16:29 +0200
From: Borislav Petkov <bp@alien8.de>
To: Aaron Lu <aaron.lu@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, lkml <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: i915 backlight
Message-ID: <20130802081628.GA11566@pd.tnic>
References: <20130731162252.GC4724@pd.tnic>
 <20130731163623.GD4724@pd.tnic>
 <1419236.138PcnXVBh@vostro.rjw.lan>
 <20130801080724.GA3448@nazgul.tnic>
 <51FB4B0A.7060706@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51FB4B0A.7060706@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 02, 2013 at 02:00:42PM +0800, Aaron Lu wrote:
> Assume you have specified to use intel_backlight in xorg.conf

Right, I have:

Section "Device"
        Option "Backlight"      "intel_backlight"
        Identifier  "Card0"
        Driver      "intel"
        BusID       "PCI:0:2:0"
EndSection

in there currently.

> does booting with video.brightness_switch_enabled=0 help?

Nope.

Kernel command line is like this:

[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.11.0-rc3+ root=/dev/sdb2 ro root=/dev/sdb2 ignore_loglevel log_buf_len=10M resume=/dev/sdb1 acpi_backlight=vendor video.brightness_switch_enabled=0 i915.i915_enable_rc6=4 i915.i915_enable_fbc=1 i915.lvds_downclock=1 i915.powersave=1

and acpi_backlight=vendor doesn't make any difference. It still works
over sysfs though.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
