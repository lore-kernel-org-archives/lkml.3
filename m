Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751116AbaLPBDw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 20:03:52 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:59124 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbaLPBDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 20:03:51 -0500
MIME-Version: 1.0
In-Reply-To: <CAPM=9twW6f2OoW4h8FAvKc+5f3MSTf1jnP+NCrnrQuWc_33tRA@mail.gmail.com>
References: <alpine.DEB.2.00.1412150715300.27943@skynet.skynet.ie>
	<CA+55aFzBS4p6NZcaggPmgOuRqnny4q+FcH6RM-5swJCw205JgA@mail.gmail.com>
	<CAPM=9twW6f2OoW4h8FAvKc+5f3MSTf1jnP+NCrnrQuWc_33tRA@mail.gmail.com>
Date: Mon, 15 Dec 2014 17:03:50 -0800
X-Google-Sender-Auth: 5MoFpygVjDGsZtqhlvd-N-iCfB4
Message-ID: <CA+55aFxmT98972EM7OaJoF_P8AoA1Lyj6WcN9LaT+MC_wgrhRQ@mail.gmail.com>
Subject: Re: [git pull] drm for 3.19-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Airlie <airlied@gmail.com>
Cc: Dave Airlie <airlied@linux.ie>, Daniel Vetter <daniel.vetter@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 4:48 PM, Dave Airlie <airlied@gmail.com> wrote:
>
> I'd be inclined to just revert this for now, it is annoying we let
> userspace away with this, but we probably need to find a better
> way to enforce it, since the cat is out of the bag.

.. why did that commit ever even get far enough to get to me?

It seems to happen on any reasonably modern Intel graphics - at least
it happens on both my laptop and my desktop. And I'm running
bog-standard F20, so either nobody ever even tested that broken thing,
or nobody bothered to look at the messages to notice it was broken.
Either way, it shows a rather distinct lack of actual testing,
wouldn't you say?

I really see no excuse for crap like this. If I find obvious bugs
immediately, on my very normal hardware and very normal distribution,
that means that there is something wrong in the development process.
If I was some subtle timing-dependent thing, or I were to be using
eally odd hardware, or I had to do something special to trigger it,
that would be one thing. But that's definitely not the case here.

                       Linus "not happy" Torvalds
