Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122AbaHGUQF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 16:16:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47810 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbaHGUQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 16:16:02 -0400
Date: Thu, 7 Aug 2014 13:16:00 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Valentina Manea <valentina.manea.m@gmail.com>
Cc: =?utf-8?B?VMO8bGluIMSwemVy?= <tulinizer@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, mail@beyermatthias.de,
        hdegoede@redhat.com, Federico Manzan <f.manzan@gmail.com>,
        Kurt Garloff <kurt@garloff.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Linux Kernel Community @ ROSEdu" <firefly@lists.rosedu.org>,
        Andy Grover <andy.grover@gmail.com>, max@vozeler.com
Subject: Re: [PATCH 0/3] usbip: move usbip out of staging
Message-ID: <20140807201600.GA5720@kroah.com>
References: <1407388229-31807-1-git-send-email-valentina.manea.m@gmail.com>
 <20140807053344.GA5754@kroah.com>
 <CABdoFFd9ZuikFyaSfOyn-babECtno50_GGNHofK1-LmhLCqeTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABdoFFd9ZuikFyaSfOyn-babECtno50_GGNHofK1-LmhLCqeTw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2014 at 12:36:06PM -0700, Valentina Manea wrote:
> On Wed, Aug 6, 2014 at 10:33 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Thu, Aug 07, 2014 at 08:10:25AM +0300, Valentina Manea wrote:
> >> This is a resend of the patch series from March.
> >>
> >> After migrating userspace code to libudev, converting usbip-host
> >> to a device driver and various bug fixes and enhancements, USB/IP
> >> is fully functional and can be moved out of staging.
> >>
> >> This patch series moves it as following:
> >> * userspace code to tools/usb/usbip
> >> * kernel code to drivers/usb/usbip
> >>
> >> Besides this, a warning generated in the kernel code is solved.
> >
> > What kernel version is this against?
> >
> 
> I rebased my tree against master in the staging tree.

Great, thanks.

> > And can we get a maintainer for this code?  I don't want to see it sit
> > "ownerless" in the kernel tree.  Will you be willing to do this?
> >
> 
> Yes. But I should be briefed about that responsibilities will this involve.

The top of the MAINTAINERS should have this information, look in the S:
Status section about what type of category you are in.

Basically I'd like you to be the one to handle patches that are sent in
for the code, just by reviewing them, you don't have to send them on to
me if you don't want to (some usb subsystem maintainers do do this, like
for usb-serial and xhci), it's up to you.

Also, any bug reports or questions about the code would come to you
first, along with the rest of the linux-usb@vger developers, you aren't
alone in this at all.

Does that help explain things better?

greg k-h
