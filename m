Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553AbaIWU3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 16:29:20 -0400
Received: from gate.crashing.org ([63.228.1.57]:60054 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756127AbaIWU3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 16:29:19 -0400
Message-ID: <1411504140.4184.26.camel@pasglop>
Subject: Re: Stupid NVIDIA 3D vgaarb.c patch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: C =?ISO-8859-1?Q?Bergstr=F6m?= <cbergstrom@pathscale.com>,
        David Airlie <airlied@linux.ie>,
        Alex Williamson <alex.williamson@redhat.com>,
        DRI <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 24 Sep 2014 06:29:00 +1000
In-Reply-To: <CA+55aFwX_nV9oUjh6u5WY=jpLxN-a5GFLmXQWDbHW0Yom9OOVA@mail.gmail.com>
References: <CAOnawYp7kv7Zjn4j-j4-TUOshE9G1uXWEqXB_=RHePNwNLmwWA@mail.gmail.com>
	 <CA+55aFwX_nV9oUjh6u5WY=jpLxN-a5GFLmXQWDbHW0Yom9OOVA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-09-22 at 13:43 -0700, Linus Torvalds wrote:
> Adding proper people and mailing lists..
> 
> The PCI_CLASS_DISPLAY_VGA test goes back to the very beginning by
> BenH, and I have no idea if adding PCI_CLASS_DISPLAY_3D is
> appropriate, but hopefully somebody does. The fact that it makes
> things work certainly argues fairly convincingly for it, but I want
> some backup here.
> 
> Dave, BenH?
> 
> Christopher(?), can you please also specify which laptop etc. And the
> patch itself seems to have come from somebody else, unless you're
> Lekensteyn. So we'd want to get the provenance of that too.

Hrm, that sucks. "3D" could mean anything really, we might need an
explicit vendor ID check as well and maybe even device ID ...

Ben.

>                 Linus
> 
> On Mon, Sep 22, 2014 at 1:28 PM, C Bergström <cbergstrom@pathscale.com> wrote:
> > Hi Linus,
> >
> > I don't know who the original author is and I can have one of the distro
> > graphics friends review it, but I need this patch below to get NVIDIA
> > drivers to work (without using any Intel graphics) on my laptop
> > http://pastebin.com/wpmFi38k
> >
> > Sorry - I know this is not the proper way to submit a patch, but it's
> > trivial and I'm not a kernel dev.
> >
> > Thanks
> >
> > ./C


