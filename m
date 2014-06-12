Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751057AbaFLTGz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 15:06:55 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:59734 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbaFLTGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 15:06:54 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1406120157510.2473@skynet.skynet.ie>
References: <alpine.DEB.2.00.1406120157510.2473@skynet.skynet.ie>
Date: Thu, 12 Jun 2014 12:06:53 -0700
X-Google-Sender-Auth: 0SZSSkNLc_NOA2a7D7c3B06fUkY
Message-ID: <CA+55aFwOvYO2pSvd835R=iU3=8i5jYu07FbifU-nOVj5pecBmA@mail.gmail.com>
Subject: Re: [git pull] drm merge tree
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Airlie <airlied@linux.ie>, Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 5:58 PM, Dave Airlie <airlied@linux.ie> wrote:
>
> This is the main drm merge window pull request, changes all over the place, mostly normal levels of churn.

Hmm.

I just had the machine reboot on me when booting this and starting X,
leaving nothing in the logs.

This is on a bog-standard i7-4770S setup (so Haswell with Intel
integrated graphics).

I'm going to test it a few more times, but if I can recreate it, I'm
going to unpull this and that will basically mean that since it came
in late in the merge window, the whole thing will miss 3.16.

Because there is no way I will release an rc1 that just doesn't work
on my main machine. I'm ok with fixing bugs after-the-fact, but bugs
that cause my own machine to be unstable? That just means I won't
pull.

This is just a heads-up, I will have to see how bad this is.

              Linus
