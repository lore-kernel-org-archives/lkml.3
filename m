Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750883AbaLPCnK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 21:43:10 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:45371 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbaLPCnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 21:43:08 -0500
MIME-Version: 1.0
In-Reply-To: <CAPM=9tyUKeA5FqhRQ+Ldj1nMM=729XnVAsKRw9h_n__JFSJtTw@mail.gmail.com>
References: <alpine.DEB.2.00.1412150715300.27943@skynet.skynet.ie>
	<CA+55aFzBS4p6NZcaggPmgOuRqnny4q+FcH6RM-5swJCw205JgA@mail.gmail.com>
	<CAPM=9twW6f2OoW4h8FAvKc+5f3MSTf1jnP+NCrnrQuWc_33tRA@mail.gmail.com>
	<CA+55aFxmT98972EM7OaJoF_P8AoA1Lyj6WcN9LaT+MC_wgrhRQ@mail.gmail.com>
	<CAPM=9tx=vkMFhiRRYkoaxL+a9vjMREMTO=xo68Xxsxuto5LWhw@mail.gmail.com>
	<CA+55aFyOD4a81DfXvVVxwK7AdLksffYkuwbydvOar1xJQut+AA@mail.gmail.com>
	<CAPM=9tyUKeA5FqhRQ+Ldj1nMM=729XnVAsKRw9h_n__JFSJtTw@mail.gmail.com>
Date: Mon, 15 Dec 2014 18:43:07 -0800
X-Google-Sender-Auth: 0YCXK2ImvoZSyKy-xMzbpbxhS94
Message-ID: <CA+55aFzKRjawGLXf7LBunfh5sLBa7oDLEHpD+6fQV0wQzAbORw@mail.gmail.com>
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

On Mon, Dec 15, 2014 at 6:37 PM, Dave Airlie <airlied@gmail.com> wrote:
>
> Now I've no idea if this happens with SNA it probably does, but it it
> didn't then F20 is using UXA so hardly anyone at Intel would see it.

Ugh, ok. I haven't upgraded to F21 yet, and won't until the merge
window is over and my life is back to semi-normal. Except for that
whole xmas thing, of course, so maybe not even then. So I can't say
whether this is gone with newer intel drivers.

                       Linus
