Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbaKJVTI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 16:19:08 -0500
Received: from mail-ig0-f181.google.com ([209.85.213.181]:55348 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbaKJVTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 16:19:07 -0500
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <CA+i8gKK0sj55s-Gk8Y36KM4yBFLvLotffbSodjH5Gsd_yxd5Sg@mail.gmail.com>
References: <CA+i8gKK0sj55s-Gk8Y36KM4yBFLvLotffbSodjH5Gsd_yxd5Sg@mail.gmail.com>
Date: Mon, 10 Nov 2014 22:19:05 +0100
Message-ID: <CAKMK7uGa_dHnie8EACcX0mQvc-uGpsgQHjWGN_obxPa3O6SJbw@mail.gmail.com>
Subject: Re: [Regression] 83f45fc turns machine's screen off
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Emmanuel Benisty <benisty.e@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@linux.ie>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding relevant mailing lists.


On Sat, Nov 8, 2014 at 7:34 PM, Emmanuel Benisty <benisty.e@gmail.com> wrote:
> Hi,
>
> The following commit permanently turns my screen off when x server is
> started (i3 330M Ironlake):
>
>     [83f45fc360c8e16a330474860ebda872d1384c8c] drm: Don't grab an fb
> reference for the idr
>
> Reverting this commit fixed the issue.

This is definitely unexpected. I think we need a bit more data to
figure out what's going on here:
- Please boot with drm.debug=0xe added to your kernel cmdline and grab
the dmesg right after boot-up for both a working or broken kernel.
- Are you using any special i915 cmdline options?

Everything else should be in the debug logs I hope.

Thanks, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
