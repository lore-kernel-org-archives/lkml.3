Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932482AbaIWO4b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 10:56:31 -0400
Received: from lekensteyn.nl ([178.21.112.251]:53873 "EHLO lekensteyn.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932193AbaIWO43 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 10:56:29 -0400
X-Greylist: delayed 2036 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Sep 2014 10:56:29 EDT
From: Peter Wu <peter@lekensteyn.nl>
To: C =?ISO-8859-1?Q?Bergstr=F6m?= <cbergstrom@pathscale.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Airlie <airlied@linux.ie>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Stupid NVIDIA 3D vgaarb.c patch
Date: Tue, 23 Sep 2014 16:22:17 +0200
Message-ID: <20771253.xd3Bmja4Qg@al>
User-Agent: KMail/4.13.3 (Linux/3.17.0-rc4-custom-00168-g7ec62d4; KDE/4.14.0; x86_64; ; )
In-Reply-To: <CAOnawYrxZA-O7xSges2LmDrmaZ__MnE7LyDfR2VLrdy+i_9VpQ@mail.gmail.com>
References: <CAOnawYp7kv7Zjn4j-j4-TUOshE9G1uXWEqXB_=RHePNwNLmwWA@mail.gmail.com> <CA+55aFwX_nV9oUjh6u5WY=jpLxN-a5GFLmXQWDbHW0Yom9OOVA@mail.gmail.com> <CAOnawYrxZA-O7xSges2LmDrmaZ__MnE7LyDfR2VLrdy+i_9VpQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Spam-Score: 0.0 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 September 2014 03:52:48 C Bergström wrote:
> Here's where I originally found it
> https://github.com/Bumblebee-Project/Bumblebee/issues/159
> (Adding Peter to cc chain)
> 
> I guess there's already a bug id and some (snarky?) comments
> https://bugzilla.kernel.org/show_bug.cgi?id=63641
> -------
> This is for Aorus X3 laptop with NVIDIA GTX 870m card
> 
> On Tue, Sep 23, 2014 at 3:43 AM, Linus Torvalds <
> torvalds@linux-foundation.org> wrote:
> 
> > Adding proper people and mailing lists..
> >
> > The PCI_CLASS_DISPLAY_VGA test goes back to the very beginning by
> > BenH, and I have no idea if adding PCI_CLASS_DISPLAY_3D is
> > appropriate, but hopefully somebody does. The fact that it makes
> > things work certainly argues fairly convincingly for it, but I want
> > some backup here.
> >
> > Dave, BenH?
> >
> > Christopher(?), can you please also specify which laptop etc. And the
> > patch itself seems to have come from somebody else, unless you're
> > Lekensteyn. So we'd want to get the provenance of that too.

If I understood this correctly, VGA arbitration is used to deal with multiple
users of a fixed IO memory address. I don't know whether modern software still
use it, but if they do, then it probably makes sense to include the 3D
controller class as some Nvidia graphics card are configured with this class.

Unfortunately I cannot provide more details than this as I don't know the
specifics. Feel free to take this patch and make it suitable for inclusion. I
don't have this kind of hardware, but mr. C is certainly not the only one with
this.

Kind regards,
Peter

> >                 Linus
> >
> > On Mon, Sep 22, 2014 at 1:28 PM, C Bergström <cbergstrom@pathscale.com>
> > wrote:
> > > Hi Linus,
> > >
> > > I don't know who the original author is and I can have one of the distro
> > > graphics friends review it, but I need this patch below to get NVIDIA
> > > drivers to work (without using any Intel graphics) on my laptop
> > > http://pastebin.com/wpmFi38k
> > >
> > > Sorry - I know this is not the proper way to submit a patch, but it's
> > > trivial and I'm not a kernel dev.
> > >
> > > Thanks
> > >
> > > ./C
> >

-- 
Kind regards,
Peter
https://lekensteyn.nl

