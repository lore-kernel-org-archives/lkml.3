Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750940AbaLPChz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 21:37:55 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:49700 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbaLPChy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 21:37:54 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFyOD4a81DfXvVVxwK7AdLksffYkuwbydvOar1xJQut+AA@mail.gmail.com>
References: <alpine.DEB.2.00.1412150715300.27943@skynet.skynet.ie>
	<CA+55aFzBS4p6NZcaggPmgOuRqnny4q+FcH6RM-5swJCw205JgA@mail.gmail.com>
	<CAPM=9twW6f2OoW4h8FAvKc+5f3MSTf1jnP+NCrnrQuWc_33tRA@mail.gmail.com>
	<CA+55aFxmT98972EM7OaJoF_P8AoA1Lyj6WcN9LaT+MC_wgrhRQ@mail.gmail.com>
	<CAPM=9tx=vkMFhiRRYkoaxL+a9vjMREMTO=xo68Xxsxuto5LWhw@mail.gmail.com>
	<CA+55aFyOD4a81DfXvVVxwK7AdLksffYkuwbydvOar1xJQut+AA@mail.gmail.com>
Date: Tue, 16 Dec 2014 12:37:52 +1000
Message-ID: <CAPM=9tyUKeA5FqhRQ+Ldj1nMM=729XnVAsKRw9h_n__JFSJtTw@mail.gmail.com>
Subject: Re: [git pull] drm for 3.19-rc1
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
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

> Having a quiet deprecation warning with the understanding that things
> will stay around for *years* is fine. Although it makes me wonder how
> much value the deprecation message really adds. I mean, why the hell
> print a message, when the only correct thing to do is to just look at
> and fix Xorg?
>
> And if you can't get Xorg fixed, then the message is kind of pointless too?
>
> So really, I don't see the point of even a oneliner message. You guys
> know who the user is. There's no value in the message. Either you fix
> the user or you don't.
>
> It's not like "oh, it's Xorg that uses our drm interfaces" is a big
> surprise, is it?

Its not X.org the X server,

it is the X.org Intel driver, which has currently 3 different
acceleration architectures
for distros to choose from.

F20 ships UXA,
F21 ships SNA,
F22 will hopefully ship glamor.

Now I've no idea if this happens with SNA it probably does, but it it
didn't then
F20 is using UXA so hardly anyone at Intel would see it.

So yes its full of surprises, version 3.0 of the Intel DDX has been in
pre-release
for 2-3 years now I think.

Dave.
