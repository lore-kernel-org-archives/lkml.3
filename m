Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851Ab3HUKfM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 06:35:12 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:37899 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab3HUKfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 06:35:09 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Wed, 21 Aug 2013 12:35:08 +0200
Message-ID: <CA+icZUUkS-UptLRM1CfcaHH=8UD-ZaHbXr8wFkA+YKyk-rPjvg@mail.gmail.com>
Subject: Re: linux-next: Tree for Aug 21 [ screen corruption in graphical mode ]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>
Cc: linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 11:21 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> There will be no linux-next trees on Aug 23 or 26.
>
> Changes since 20130820:
>
> New tree: aio-direct
>
> Removed tree: xilinx (at maintainer's request)
>
> The xfs tree still had its build failure for which I reverted a commit.
>
> The trivial tree gained conflicts against the crypto, net-next and
> wireless trees.
>
> The aio tree gained conflicts against the aio-direct tree.
>
> The akpm-current tree gained conflicts against the modules and aio-direct
> trees.
>
> ----------------------------------------------------------------------------
>

Hi,

I still have this issue with next-20130821 and "Linux v3.11-rc6 plus
drm-intel-nightly on top"
Any new development on this?
Patches?

Currently, I have two workarounds:

[1] Revert this commit:

commit 5456fe3882812aba251886e36fe55bfefb8e8829
"drm/i915: Allocate LLC ringbuffers from stolen"

[2] Stop and start lightdm session manually

...switch to a VT and do a stop/start lightdm.

Any help appreciated.

BTW, I switched my Linux/X graphics stack to Mesa v9.2-rc1 and
Intel-DDX v2.21.14-55-ged40a7c (LibDRM is still v2.4.46).

Thanks.

Regards,
- Sedat -

P.S.: The suspend/resume problem which I saw parallelly on former
-next releases is gone.
