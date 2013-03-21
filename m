Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab3CUBvh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 21:51:37 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:60710 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062Ab3CUBvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 21:51:36 -0400
MIME-Version: 1.0
In-Reply-To: <1363771375-31715-1-git-send-email-mcgrof@do-not-panic.com>
References: <1363771375-31715-1-git-send-email-mcgrof@do-not-panic.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 20 Mar 2013 18:51:14 -0700
X-Google-Sender-Auth: RLTjsJLpE0Z6XCFEN1rPx05ueYE
Message-ID: <CAB=NE6WzwBMmkO=z0HjqZdEJn4s0m+d_8Vh08_zDO0PuLvy9jA@mail.gmail.com>
Subject: Re: [RFC 00/30] compat: deal with kernel backport namespace
To: backports@vger.kernel.org
Cc: ben@decadent.org.uk, noelamac@gmail.com, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, andi@firstfloor.org,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 2:22 AM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
>
> This patch series deals with the project that aims at
> backporting the Linux kernel [0]. If you don't care
> for that, at least read this and patch #1, the rest
> you can nuke.
>
> Ben reports compat_ namespace is already taken by the
> kernel, and while this is slightly true, I rather just
> deal with this now and avoid any future issues.
>
> I've chosen backport_. Any nay's?
>
> I've broken this set for easier review to one per kernel
> backported. Each patch is test compiled with ckmake [1]
> for kernels 2.6.24 - 3.9. I've then test compiled all this
> against compat-drivers-2013-03-15, which sucks in Ethernet,
> 802.11 Bluetooth, and DRM video drivers against linux-next
> tag next-20130315 and it all went fine for all kernels
> 2.6.24 - 3.9.
>
> I suppose the next set here, if we really are adamant about
> any possible namespace issues (is it necessary?) is to use
> include/linux/backport/ instead of include/linux/compat/ and
> likewise rename the compat module to backports as with
> COMPAT_* macros.
>
> I'm sending these as RFCs in hopes to get reviews / testing
> prior to any radical change, but more importantly in hopes
> anyone who cares for maintaining a Linux distribution will
> review.
>
> [0] https://backports.wiki.kernel.org
> [1] https://git.kernel.org/cgit/linux/kernel/git/mcgrof/compat.git/tree/bin/ckmake

I heard no one cry, so pushed.

  Luis
