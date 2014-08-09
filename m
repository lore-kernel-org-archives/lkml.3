Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805AbaHIOTs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 10:19:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37481 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbaHIOTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 10:19:30 -0400
Date: Sat, 9 Aug 2014 07:17:16 -0700
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
Message-ID: <20140809141716.GB21639@kroah.com>
References: <1407388229-31807-1-git-send-email-valentina.manea.m@gmail.com>
 <20140807053344.GA5754@kroah.com>
 <CABdoFFd9ZuikFyaSfOyn-babECtno50_GGNHofK1-LmhLCqeTw@mail.gmail.com>
 <20140807201600.GA5720@kroah.com>
 <CABdoFFebQmW+r2zyvcN4TXHgkcg9L1XZd06Za_T7TvXZDxQ_-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABdoFFebQmW+r2zyvcN4TXHgkcg9L1XZd06Za_T7TvXZDxQ_-A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2014 at 09:41:48PM -0700, Valentina Manea wrote:
> On Thu, Aug 7, 2014 at 1:16 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > The top of the MAINTAINERS should have this information, look in the S:
> > Status section about what type of category you are in.
> >
> > Basically I'd like you to be the one to handle patches that are sent in
> > for the code, just by reviewing them, you don't have to send them on to
> > me if you don't want to (some usb subsystem maintainers do do this, like
> > for usb-serial and xhci), it's up to you.
> >
> > Also, any bug reports or questions about the code would come to you
> > first, along with the rest of the linux-usb@vger developers, you aren't
> > alone in this at all.
> >
> 
> Ok, this sounds good. I suppose sending you the patches involves
> picking them up from the email, batching them and sending with
> send-email.

Yes, that would be ideal, but you don't have to do that if you don't
want to.  A simple "Acked-by:" line added to an email that you cc: me on
with the patch should suffice if that is easier (it's how other
developers do it to let me know they have reviewed it.)

Which ever works best / easiest for you.

thanks,

greg k-h
