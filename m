Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499AbaLPHoj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 02:44:39 -0500
Received: from mail.fireflyinternet.com ([87.106.93.118]:50026 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751124AbaLPHoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 02:44:37 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Date: Tue, 16 Dec 2014 07:44:13 +0000
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Dave Airlie <airlied@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Daniel Vetter <daniel.vetter@intel.com>
Subject: Re: [git pull] drm for 3.19-rc1
Message-ID: <20141216074413.GB26498@nuc-i3427.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Dave Airlie <airlied@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Thomas Hellstrom <thellstrom@vmware.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	Daniel Vetter <daniel.vetter@intel.com>
References: <alpine.DEB.2.00.1412150715300.27943@skynet.skynet.ie>
 <CA+55aFzBS4p6NZcaggPmgOuRqnny4q+FcH6RM-5swJCw205JgA@mail.gmail.com>
 <CAPM=9twW6f2OoW4h8FAvKc+5f3MSTf1jnP+NCrnrQuWc_33tRA@mail.gmail.com>
 <CA+55aFxmT98972EM7OaJoF_P8AoA1Lyj6WcN9LaT+MC_wgrhRQ@mail.gmail.com>
 <CAPM=9tx=vkMFhiRRYkoaxL+a9vjMREMTO=xo68Xxsxuto5LWhw@mail.gmail.com>
 <CA+55aFyOD4a81DfXvVVxwK7AdLksffYkuwbydvOar1xJQut+AA@mail.gmail.com>
 <CAPM=9tyUKeA5FqhRQ+Ldj1nMM=729XnVAsKRw9h_n__JFSJtTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM=9tyUKeA5FqhRQ+Ldj1nMM=729XnVAsKRw9h_n__JFSJtTw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 12:37:52PM +1000, Dave Airlie wrote:
> > Having a quiet deprecation warning with the understanding that things
> > will stay around for *years* is fine. Although it makes me wonder how
> > much value the deprecation message really adds. I mean, why the hell
> > print a message, when the only correct thing to do is to just look at
> > and fix Xorg?
> >
> > And if you can't get Xorg fixed, then the message is kind of pointless too?
> >
> > So really, I don't see the point of even a oneliner message. You guys
> > know who the user is. There's no value in the message. Either you fix
> > the user or you don't.
> >
> > It's not like "oh, it's Xorg that uses our drm interfaces" is a big
> > surprise, is it?
> 
> Its not X.org the X server,

It is plymouthd using libkms. It affects -radeon, -nouveau and -intel
who all try to copy the fbcon created using a dumb buffer into the
Screen Pixmap.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
