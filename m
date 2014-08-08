Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613AbaHHUak (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:30:40 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:38839 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbaHHUaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:30:39 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxb1q9bwdM6_H=ctFHc+4rP4rBuzWMDNXVZwpwf0cN-Bw@mail.gmail.com>
References: <20140808143418.GA25720@phenom.ffwll.local>
	<CA+55aFxVsV58oi0E5H0dTRGH2r+WogkuzhncTJHy9F4d2sTTrA@mail.gmail.com>
	<CA+55aFxb1q9bwdM6_H=ctFHc+4rP4rBuzWMDNXVZwpwf0cN-Bw@mail.gmail.com>
Date: Fri, 8 Aug 2014 13:30:38 -0700
X-Google-Sender-Auth: kmG-0mGZKYFx6Q5RqqqvOnztVTo
Message-ID: <CA+55aFyXXyJ1subAWjwv3-yFndRNpUSWLFVb8Aq=NWAS+PXsJQ@mail.gmail.com>
Subject: Re: [PULL] drm-intel-fixes
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Airlie <airlied@gmail.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 8, 2014 at 12:37 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> The problem seems to exist already with just the plain drm pull from
> Dave. I thought I had tested that, but apparently not.

Still busy bisecting (and it's going into the i915 part of Dave's drm
pull, so the bisect looks sane so far), but in case some i915 person
is trying to think about what it might be, it doesn't seem to be the
backlight per se.

Sometimes it resumes with the backlight on and something showing on
the screen, but no reaction to mouse or keyboard. And in fact, I have
now gotten an X lockup twice *without* doing resume/suspend, so it
seems like the whole resume/suspend thing is just a way to trigger it,
not the fundamental problem.

The machine is alive (the printscreen button takes a screenshot, for
example - I can tell by the sound), but the graphics side is hung.

This is a Sony Vaio Pro 11, so it's bog-standard intel graphics (Haswell ULT).

                 Linus
