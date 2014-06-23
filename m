Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352AbaFWU02 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 16:26:28 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:33766 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755379AbaFWU00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 16:26:26 -0400
X-Sasl-enc: +XPZPlDScEE6lKMXS5YA6zYFiDCRr9M+qTmlEB57wRqm 1403555186
Date: Mon, 23 Jun 2014 16:26:15 -0400
From: Greg KH <greg@kroah.com>
To: Ilia Mirkin <imirkin@alum.mit.edu>
Cc: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        David Airlie <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: Re: unparseable, undocumented /sys/class/drm/.../pstate
Message-ID: <20140623202615.GA29199@kroah.com>
References: <20140621180201.GA4621@amd.pavel.ucw.cz>
 <CAKb7UvhOCiBHcsB6a0qKBNsC3c9pmb=Wc7zucbBuP6vt-tx2eA@mail.gmail.com>
 <20140621194538.GA4903@kroah.com>
 <CAKb7UvjhOystpeRy1nQx49Nspve4wHQPb+e7gJQ-RT-HseK4Cw@mail.gmail.com>
 <20140623130259.GA29809@amd.pavel.ucw.cz>
 <CAKb7UvhmatCtu2rEHgVOjitN1gAPTsgfaUmA2iOLX2Qwhi+Yxg@mail.gmail.com>
 <20140623201503.GA4551@amd.pavel.ucw.cz>
 <CAKb7UvjU+MvW+rXi8488GE64Exuxj3+H5V+E8fzfL5fTb1CGMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKb7UvjU+MvW+rXi8488GE64Exuxj3+H5V+E8fzfL5fTb1CGMA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 04:18:39PM -0400, Ilia Mirkin wrote:
> On Mon, Jun 23, 2014 at 4:15 PM, Pavel Machek <pavel@ucw.cz> wrote:
> > Hi!
> >
> >> >> >> > I guess better interface would be something like
> >> >> >> >
> >> >> >> > pstate/07/core_clock_min
> >> >> >> >           core_clock_max
> >> >> >> >           memory_clock_min
> >> >> >> >           memory_clock_max
> >> >> >> >
> >> >> >> > and then pstate/active containing just the number of active state?
> >> >
> >> >> Could we just say that the format of this file is one-per-line of
> >> >>
> >> >> level: information-for-the-user
> >> >
> >> > But it is not.
> >>
> >> But it is...
> >>
> >> > Management tools will want to parse it, sooner or
> >> > later.  What is wrong with solution described above?
> >>
> >> It is complex and annoying to the people that will actually use it.
> >
> > grep -r . pstate/ is actually not that bad...
> 
> While that's a clever trick that anyone who's done a bunch of stuff
> with sysfs knows, I doubt the average linux user could come up with
> that on their own. I know I didn't.

That's fine, why would an "average" Linux user ever need to poke around
in sysfs?  Again, please describe what you are wanting to have exported
to userspace, and what userspace is supposed to do with that
information, before worrying about the actual sysfs file layout.

greg k-h
