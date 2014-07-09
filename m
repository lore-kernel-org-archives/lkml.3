Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912AbaGIR2f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 13:28:35 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:60987 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbaGIR2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 13:28:33 -0400
MIME-Version: 1.0
In-Reply-To: <20140709171930.GA11527@kroah.com>
References: <1404924948-3298-1-git-send-email-xerofoify@gmail.com>
	<20140709171930.GA11527@kroah.com>
Date: Wed, 9 Jul 2014 13:28:32 -0400
Message-ID: <CAPDOMVgZGWm=A89DdXiTmt+1qKNKxc+UpbupqCW52_+abfWAYw@mail.gmail.com>
Subject: Re: [PATCH] Removes FIXME message in usb.c
From: Nick Krause <xerofoify@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: balbi@ti.com, Tony Lindgren <tony@atomide.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote on July 9th at 1:19 P.M.
Ok, this has been fun to watch on lkml for a while now, but really,
please, just stop doing this.  Randomly searching the kernel source for
FIXME lines and just commenting them out, isn't ok.  Almost always,
those lines are there because the original developer really doesn't know
how else to resolve the issue.

So, if the domain-specific-author doesn't have an idea of what to do,
how does someone who is brand-new to the code know better?

If you are looking for a task to do in the kernel, try
drivers/staging/*/TODO for a list.  Or look at the kernel janitor's list
on kernelnewbies.org.  Or try running the kernel and finding something
that is broken for you and fixing that.  Any of those would be better
than randomly deleting FIXME lines.  By doing that, you are just wasting
maintainer's time.  Which is the resource we have the least of at the
moment.

thanks,

greg k-h



Greg ,

I sent in another patch which enables omap_cfg_reg(USB2_SPEED) as
stated in the fix me.
The maintainers of this file stated to me this was dangerous due to
the wires perhaps being
shared with other parts of the board and we should depend on the boot
loader to set this.
The maintainers decided to remove this fix me not me based on their
better understanding
of this file.

Cheers Nick

On Wed, Jul 9, 2014 at 1:19 PM, Greg KH <greg@kroah.com> wrote:
> Ok, this has been fun to watch on lkml for a while now, but really,
> please, just stop doing this.  Randomly searching the kernel source for
> FIXME lines and just commenting them out, isn't ok.  Almost always,
> those lines are there because the original developer really doesn't know
> how else to resolve the issue.
>
> So, if the domain-specific-author doesn't have an idea of what to do,
> how does someone who is brand-new to the code know better?
>
> If you are looking for a task to do in the kernel, try
> drivers/staging/*/TODO for a list.  Or look at the kernel janitor's list
> on kernelnewbies.org.  Or try running the kernel and finding something
> that is broken for you and fixing that.  Any of those would be better
> than randomly deleting FIXME lines.  By doing that, you are just wasting
> maintainer's time.  Which is the resource we have the least of at the
> moment.
>
> thanks,
>
> greg k-h
