Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751262AbaGFItl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 04:49:41 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:52463 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbaGFItj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 04:49:39 -0400
MIME-Version: 1.0
In-Reply-To: <5878240.sEB4GAESUK@grover>
References: <alpine.DEB.2.00.1407052310460.24632@skynet.skynet.ie>
	<5878240.sEB4GAESUK@grover>
Date: Sun, 6 Jul 2014 18:49:38 +1000
Message-ID: <CAPM=9txtM09G8_nW1ZTFNQqc_h_ZSBhUumrY0eZd_v+bxQ28wg@mail.gmail.com>
Subject: Re: [git pull] drm fixes
From: Dave Airlie <airlied@gmail.com>
To: Ed Tomlinson <edt@aei.ca>
Cc: Dave Airlie <airlied@linux.ie>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 July 2014 12:24, Ed Tomlinson <edt@aei.ca> wrote:
> Hi Dave,
>
> This is NOT fixing problems with a stalled boot due to VGA problems as
> reported in thread: [PATCH 5/5] drm/i915: Kick out vga console
> It can be fixed by reverting: a4de05268e674e8ed31df6348269e22d6c6a1803
> or applying the patch from Chris Wilson which can be found as a reply to my report.

I was hoping Daniel would get to it, but he is on holidays (as am I
really!), I'll take a look at the fix when I'm back in the office
myself if nobody has sent it to me.

Dave.
