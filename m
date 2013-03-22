Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932893Ab3CVJM4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 05:12:56 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:56871 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932344Ab3CVJMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 05:12:54 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <s5hk3panhaq.wl%tiwai@suse.de>
References: <s5hk3panhaq.wl%tiwai@suse.de>
Date: Fri, 22 Mar 2013 10:12:54 +0100
X-Google-Sender-Auth: SfWqGcKFaGhp2DUnyBAqbFRgrqw
Message-ID: <CAKMK7uG3HiwpKY4XafSOCu+=fTvddzZN2EBYgc98ZiJgc+bgHw@mail.gmail.com>
Subject: Re: [Intel-gfx] Regression: HSW eDP broken on 3.9-rc[12]
From: Daniel Vetter <daniel@ffwll.ch>
To: Takashi Iwai <tiwai@suse.de>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 4:15 PM, Takashi Iwai <tiwai@suse.de> wrote:
> I noticed that a Haswell desktop machine with eDP gets only the blank
> screen on the latest Linus tree.  It works fine with 3.8, so it's a
> regression since 3.9-rc1.  Actually, it's not a regression.  It's
> three regressions in a shot! (I had to do painful bisections three
> times...)
>
> c464b2a17c59adedbdc02cc54341d630354edc3
>     drm/i915: set TRANSCODER_EDP even earlier
>
> d6dd9eb1d96d2b7345fe4664066c2b7ed86da898
>     drm/i915: dynamic Haswell display power well support
>
> commit cf0a6584aa6d382f802f2c3cacac23ccbccde0cd
>     drm/i915: write backlight harder
>
>
> The first commit affects no matter whether power well is on or off.
> It brings the eDP output always blank.

Can you please attach the xrandr output and drm.debug=0xe dmesg from
booting for that hsw eDP machine quickly?

Thanks, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
