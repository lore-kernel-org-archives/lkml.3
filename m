Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759551Ab3B0Di7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 22:38:59 -0500
Received: from mail-ve0-f176.google.com ([209.85.128.176]:38054 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541Ab3B0Di6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 22:38:58 -0500
MIME-Version: 1.0
In-Reply-To: <CAPM=9ty2_8TM8Y_5x-iE8aio1NCvmJMB7bmip3rcsrtK-0iR+Q@mail.gmail.com>
References: <alpine.DEB.2.00.1302260003460.24684@skynet.skynet.ie>
	<CA+55aFzRRxTjuQcLhkhfxDWpHEg3EoSY8CMP+v78i+_Z-EkQ1g@mail.gmail.com>
	<CAPM=9ty2_8TM8Y_5x-iE8aio1NCvmJMB7bmip3rcsrtK-0iR+Q@mail.gmail.com>
Date: Tue, 26 Feb 2013 19:38:57 -0800
X-Google-Sender-Auth: iv1ZtdNyGidce1xlw44flACrC5k
Message-ID: <CA+55aFyFobwz3++8ifE3SVyG7H8hFzhVvzkojAoXPoomjfEejw@mail.gmail.com>
Subject: Re: [git pull] drm merge for 3.9-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Airlie <airlied@gmail.com>
Cc: Dave Airlie <airlied@linux.ie>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Imre Deak <imre.deak@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 7:30 PM, Dave Airlie <airlied@gmail.com> wrote:
>
> If you want to just bump it so Ironlake isn't affected, (patch attached).

It works fine 95% of the time and isn't a hard failure when it
doesn't, so this isn't critical. I can wait for it to be fixed a
while.

> Is this external DP monitor or eDP laptop panel btw?

External monitor. Oh, and the monitor is actually connected to HDMI,
but the black screen and the DP messages definitely go hand-in-hand.

                 Linus
