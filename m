Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305AbaCFQQx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 11:16:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33878 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbaCFQQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 11:16:51 -0500
Date: Thu, 6 Mar 2014 08:17:18 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Andrew Grover <andy.grover@gmail.com>,
        Valentina Manea <valentina.manea.m@gmail.com>
Cc: devel@driverdev.osuosl.org, shuah.kh@samsung.com,
        linux-usb@vger.kernel.org, ly80toro@cip.cs.fau.de,
        tobias.polzer@fau.de, linux-kernel@vger.kernel.org,
        "Linux Kernel Community @ ROSEdu" <firefly@lists.rosedu.org>,
        dominik.paulus@fau.de, ihadzic@research.bell-labs.com
Subject: Re: [PATCH] staging: usbip: userspace: increase version to 2.0
Message-ID: <20140306161718.GB9823@kroah.com>
References: <1393960599-21379-1-git-send-email-valentina.manea.m@gmail.com>
 <20140304192014.GA28665@kroah.com>
 <CABdoFFdXzRE7wnkmwFo7Dt6vzM8KtunGo-vtOTTszekDfAOMVA@mail.gmail.com>
 <CABwEGXhH6AHO+qcNkq7qsMncJLUhS8YoK4koN9oJKeoF4uXuGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABwEGXhH6AHO+qcNkq7qsMncJLUhS8YoK4koN9oJKeoF4uXuGw@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 11:30:06PM -0800, Andrew Grover wrote:
> On Wed, Mar 5, 2014 at 10:14 PM, Valentina Manea
> <valentina.manea.m@gmail.com> wrote:
> > On Tue, Mar 4, 2014 at 9:20 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> >> On Tue, Mar 04, 2014 at 09:16:39PM +0200, Valentina Manea wrote:
> >>> -AC_INIT([usbip-utils], [1.1.1], [linux-usb@vger.kernel.org])
> >>> +AC_INIT([usbip-utils], [2.0], [linux-usb@vger.kernel.org])
> >>
> >> Why?
> >>
> >> What does this mean?  What warrents the version change?  Why have a
> >> version at all?
> >
> > This was part of an effort to "refresh" USB/IP by moving userspace out
> > of kernel.git.
> > Since some major changes have been made (libudev migration), Andy (cc'ed) and me
> > thought it was worth to be promoted to version 2.0.
> 
> (sorry, resending in plain text mode so vger doesn't bounce (curse you
> gmail :-))
> 
> Valentina did considerable work in moving usbip-utils from using the
> defunct libsysfs to libudev (well, part of systemd now it seems.) so
> some version bump seems appropriate, why not to 2.0? esp. as a
> heads-up to pkg maintainers - btw usbip-utils is already packaged for
> Debian, and I could probably see it in Fedora too, why not.
> 
> As to why have a version at all, this is of course tied to whether
> usbip-utils will ever emerge from the belly of the whale and return to
> its own home. I think it should someday, if the concerns about
> long-term maintenance and interface stability can be addressed to your
> satisfaction. It would be considerable work to integrate it into the
> kernel build, and would need to be undone if it ever left kernel.git.

One big confusion this patch caused, is that it showed up "on its own"
before the "libudev rewrite" in my inbox.  So all I see is this patch
incrementing the version for no real reason.

Valentina, please always order all of your patches so I know which order
in which to apply them in.  I see a bunch of follow-on patches after
your larger series, what order should they be applied in?  Can you just
resend _all_ of these, and number them in the correct order in which
they need to be applied in, so I know exactly what to do here?

thanks,

greg k-h
