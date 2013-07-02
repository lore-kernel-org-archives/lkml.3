Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013Ab3GBKhJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 06:37:09 -0400
Received: from mail-qe0-f54.google.com ([209.85.128.54]:48231 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab3GBKhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 06:37:07 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20130702170708.4f1b6c24c40a6fe607802a22@canb.auug.org.au>
References: <20130702170708.4f1b6c24c40a6fe607802a22@canb.auug.org.au>
Date: Tue, 2 Jul 2013 12:37:05 +0200
Message-ID: <CA+icZUUP6ZNQN62aqHr3DKzFJmw7QjmkuquToLydg__iiXmNfA@mail.gmail.com>
Subject: Re: linux-next: Tree for Jul 2
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 2, 2013 at 9:07 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> Changes since 20130701:
>
> The powerpc tree gained a build failure so I used the version from
> next-20130701.
>
> The regulator tree lost its build failure.
>
> The arm-soc tree gained conflicts against the l2-mtd tree.
>
> The renesas tree gained a conflict against the arm tree.
>
> ----------------------------------------------------------------------------
>

When has this changed from drm-intel-next-queued (old) to for-linux-next (new)?
I was astonished I see still the issue of yesterday.

- Sedat -

[1] http://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/Next/Trees?id=next-20130702#n120
