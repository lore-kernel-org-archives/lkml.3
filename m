Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328AbaEKQqB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 12:46:01 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:47459 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793AbaEKQp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 12:45:59 -0400
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <CAPM=9txjONPn_p131Q1d=0D8Ma0K_6_DGF3ztDPG65wCXOfW0Q@mail.gmail.com>
References: <CADDKRnCwxmJ8RonvZaizTT9R1jPU++tPPSQAH5OKD5=h9bQhMA@mail.gmail.com>
	<CAKMK7uG20sF403PJcmWTD=kPF9seV4sXZpp9_hEq3LvV3kK5Hg@mail.gmail.com>
	<CADDKRnB1DCzgjX-q-cgFFW48uT5r5MUcuc5D6chekEET5dFxxA@mail.gmail.com>
	<20140509161438.GH31479@strange.amr.corp.intel.com>
	<20140509170335.GZ18465@intel.com>
	<CAPM=9txjONPn_p131Q1d=0D8Ma0K_6_DGF3ztDPG65wCXOfW0Q@mail.gmail.com>
Date: Sun, 11 May 2014 18:45:59 +0200
Message-ID: <CAKMK7uFtZm5UDRTqaNp4X--dxSxwkMgPE5OU9Vo_K0L+G=ccvw@mail.gmail.com>
Subject: Re: [Intel-gfx] [3.14.0-rc4] regression: drm FIFO underruns
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Dave Airlie <airlied@gmail.com>
Cc: =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        Damien Lespiau <damien.lespiau@intel.com>,
        David Airlie <airlied@linux.ie>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?J=C3=B6rg_Otte?= <jrg.otte@gmail.com>,
        Dave Airlie <airlied@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 9, 2014 at 11:18 PM, Dave Airlie <airlied@gmail.com> wrote:
> Please don't make things more prominent if the fixes can't be merged
> without rewriting the world,
>
> Distros have auto reporting tools for the major backtrace warnings,
> and releasing kernels with unfixable ones in it make it hard to know
> what is real and what isn't.

Fully agreed if we can't fix them. But we also need to strike some
balance for otherwise we can never enable we self-tests. And I
absolutely want those enable to have the best possible regression
testing coverage. E.g. every time we add a substantial amount of new
checks to the modeset state checker it takes 1-2 releases to settle
all the fallout. But we're backporting all the fixes, except when
they're too invasive (in which case we disable the check temporarily
or restrict it).
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
