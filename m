Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954AbaB1IDm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 03:03:42 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:39169 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbaB1IDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 03:03:40 -0500
MIME-Version: 1.0
In-Reply-To: <5310359F.2040904@ti.com>
References: <1393502086-9433-1-git-send-email-tomi.valkeinen@ti.com>
	<530F80ED.1040509@infradead.org>
	<5310359F.2040904@ti.com>
Date: Fri, 28 Feb 2014 09:03:39 +0100
X-Google-Sender-Auth: 4ik1tIN4wKFgu_gz1G66IPtQyUo
Message-ID: <CAMuHMdVcXmukvrJ7KYNY5WJPgS3=oOqsfvb3k89UANx_6QBTKA@mail.gmail.com>
Subject: Re: [PATCH 0/3] Reorder drivers/video directory
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        David Airlie <airlied@linux.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 8:07 AM, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
> On 27/02/14 20:16, Randy Dunlap wrote:
>> On 02/27/2014 03:54 AM, Tomi Valkeinen wrote:
>>> Hi,
>>>
>>> This is a re-send of the series, with RFC removed from the subject, and a bunch
>>> of acks added.
>>>
>>> I'm cc'ing more people, to make sure this doesn't come as a surprise, and to
>>> make sure this is not a bad idea, doomed to fail horribly.
>>
>> What does this patch apply to?  I can't get it to apply cleanly to
>> -rc4 or Linus's current git tree.
>>
>> I like what I see so far.
>
> My branch was based on -rc2. Some minor fbdev fixes went in after that,
> and they seem to break the apply. I think the drivers/video/Kconfig and
> drivers/video/Makefile are the most problematic ones, any change there
> will conflict badly.

So you want to do the move based on one of the later -rcs, to avoid conflicits.
-rc5 may be too late, but it's up to Linus to decide.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
