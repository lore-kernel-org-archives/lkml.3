Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392AbaLPCPt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 21:15:49 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:60962 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbaLPCPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 21:15:47 -0500
MIME-Version: 1.0
In-Reply-To: <CAPM=9tx=vkMFhiRRYkoaxL+a9vjMREMTO=xo68Xxsxuto5LWhw@mail.gmail.com>
References: <alpine.DEB.2.00.1412150715300.27943@skynet.skynet.ie>
	<CA+55aFzBS4p6NZcaggPmgOuRqnny4q+FcH6RM-5swJCw205JgA@mail.gmail.com>
	<CAPM=9twW6f2OoW4h8FAvKc+5f3MSTf1jnP+NCrnrQuWc_33tRA@mail.gmail.com>
	<CA+55aFxmT98972EM7OaJoF_P8AoA1Lyj6WcN9LaT+MC_wgrhRQ@mail.gmail.com>
	<CAPM=9tx=vkMFhiRRYkoaxL+a9vjMREMTO=xo68Xxsxuto5LWhw@mail.gmail.com>
Date: Mon, 15 Dec 2014 18:15:47 -0800
X-Google-Sender-Auth: Cwe3c9NfnYFbPkyaAcrYQ0RhKbU
Message-ID: <CA+55aFyOD4a81DfXvVVxwK7AdLksffYkuwbydvOar1xJQut+AA@mail.gmail.com>
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

On Mon, Dec 15, 2014 at 5:50 PM, Dave Airlie <airlied@gmail.com> wrote:
>
> Now you might complain that printing anything in this case is bad,

I don't mind it if it's *one* line, and if people realize that the
commentary in the commit in question was pure and utter shit.

Because talking about how it's going to become an error is pretty damn
premature, if Xorg uses it today. That's part of what just made me
really frigging upset. People applied this patch, didn't test it AT
ALL, and the commit message is completely inappropriate crap.

Having a quiet deprecation warning with the understanding that things
will stay around for *years* is fine. Although it makes me wonder how
much value the deprecation message really adds. I mean, why the hell
print a message, when the only correct thing to do is to just look at
and fix Xorg?

And if you can't get Xorg fixed, then the message is kind of pointless too?

So really, I don't see the point of even a oneliner message. You guys
know who the user is. There's no value in the message. Either you fix
the user or you don't.

It's not like "oh, it's Xorg that uses our drm interfaces" is a big
surprise, is it?

                         Linus
