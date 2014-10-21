Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273AbaJUSYe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 14:24:34 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:34383 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827AbaJUSYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 14:24:32 -0400
MIME-Version: 1.0
In-Reply-To: <1413911644.30379.12.camel@hadess.net>
References: <1413881397.30379.7.camel@hadess.net>
	<CANcMJZA=7FNNCrMpz-mC4FaJMKi8hEhqGtO_bv7iJdWVC_GpWA@mail.gmail.com>
	<1413911644.30379.12.camel@hadess.net>
Date: Tue, 21 Oct 2014 20:24:31 +0200
X-Google-Sender-Auth: BJqMWoaOoT36Uzq-TlNLlrhpT5w
Message-ID: <CAMuHMdWw+rX-r2uVN0ZL-GFirOkCn7+Gh7BVd3JvyXXS_pcdVw@mail.gmail.com>
Subject: Re: A desktop environment[1] kernel wishlist
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Bastien Nocera <hadess@hadess.net>
Cc: John Stultz <john.stultz@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 7:14 PM, Bastien Nocera <hadess@hadess.net> wrote:
>> As for: 'Export of "wake reason" when the system wakes up (rtc alarm,
>> lid open, etc.) and wakealarm (/sys/class/rtc/foo/wakealarm)
>> documentation'
>>
>> Can you expand more on the rational for the need here? Is this for UI
>> for power debugging, or something else?
>
> No, it would be used for automating backups, or implementing
> suspend->hibernation transitions. For example, right before the machine
> suspends, I would schedule it to wake up in a hour. If I get woken up by
> the rtc alarm (and not by the user through a lid open), I might:
> - check that I'm plugged into the AC, it's night, and in the vicinity of
> the server that handles my backups and so backup the system.
> - check whether the battery is low, and hibernate the machine (if it
> supports it, obviously).

Isn't this already available through /sys/kernel/debug/wakeup_sources
and/or the various power/wake* files in sysfs?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
