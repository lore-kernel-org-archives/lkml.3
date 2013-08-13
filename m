Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab3HMJKW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 05:10:22 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:46423 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225Ab3HMJKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 05:10:19 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Tue, 13 Aug 2013 11:10:18 +0200
Message-ID: <CA+icZUWmee5nTZCGvFb4vLpna5vUn+RJ-V9pHpKPFaTc96BG5Q@mail.gmail.com>
Subject: Re: linux-next: Tree for Aug 13 [ screen corruption in graphical mode ]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@gmail.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        DRI <dri-devel@lists.freedesktop.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 10:28 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> Changes since 20130812:
>
> The ext4 tree gained a conflict against Linus' tree.
>
> The infiniband tree gained a build failure for which I applied a merge
> fix patch and another so I used the version from next-20130812.
>
> The tty tree gained conflicts against the devicetree and tile trees.
>
> The usb tree gained a conflict against the net-next tree.
>
> The usb-gadget tree gained a build failure for which I reverted a commit.
>
> The ptr-ret tree gained a conflict against the staging tree.
>
> The akpm tree gained a conflict against the staging tree.
>
> ----------------------------------------------------------------------------
>

Hi,

with today's next-20130813 I cannot see 1/10 of my desktop-screen's
top, it's simply black.
I can estimate the URL line in Firefox (or open a new tab blindly and
get a known URL from my autocompleted history).

My Xorg stack did not change: libdrm-2.4.46 | mesa-9.16 | intel-ddx-2.4.14.
next-20130808 was OK - no screen corruptions.

Any idea, hint?

- Sedat -
