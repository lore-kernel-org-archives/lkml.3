Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437AbaAPBto (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 20:49:44 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:61642 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbaAPBtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 20:49:40 -0500
MIME-Version: 1.0
Date: Thu, 16 Jan 2014 08:49:38 +0700
X-Google-Sender-Auth: LDJf3frKQ4fEUT9DGohiD4Vs7p0
Message-ID: <CA+55aFzcHCg1Azf0t4KrYx0N1z0xaeT8fNHJEW5og3VBd+UPOA@mail.gmail.com>
Subject: Baytrail problems (was Re: Linux 3.13-rc8)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paul Drews <paul.drews@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding in the appropriate people...

On Tue, Jan 14, 2014 at 7:01 PM, One Thousand Gnomes
<gnomes@lxorguk.ukuu.org.uk> wrote:
>
> It seems to hate Baytrail/T
>
> My ASUS T100TA has gone from 3.11 'needs video=VGA-1:blah' to get the mode
> right but otherwise running nicely and playing 3D games to 3.13-rc8
>
> - crashes and burns during boot if the Baytrail pinctrl driver is compiled
>   in

Andy, Paul? The changes to the pinctrl driver since 3.11 look trivial,
but I guess the GPIO and ACPI ID addition ends up also enabling all
the old code that Alan probably never ran in 3.11 because the driver
didn't trigger on his machine.

Alan, do you have a crash picture/log?

> - i915 console doesn't work

Daniel/Dave?

> - X can be kind of hacked to work by adding mode lines wit xrandr and
>   turning the vga back on
>
> Bugs filed on both issues. The pinctrl one is nasty as it makes the i915
> driver crash during initialisation, so the only way you can debug it is
> pretty much a USB debug cable.
>
> Without pinctrl the crash goes away but the display still doesn't work.

Thanks,

              Linus
