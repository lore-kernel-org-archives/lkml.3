Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab3H0RgF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 13:36:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38719 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab3H0RgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 13:36:01 -0400
Date: Tue, 27 Aug 2013 10:38:19 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Kevin Hilman <khilman@linaro.org>
Cc: Alexander Savchenko <oleksandr.savchenko@ti.com>, jslaby@suse.cz,
        linux-serial@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        balbi@ti.com, linux-omap <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] serial: omap: Fix IRQ handling return value
Message-ID: <20130827173819.GD21564@kroah.com>
References: <1374067753-29560-1-git-send-email-oleksandr.savchenko@ti.com>
 <CAGa+x84dE_RwN2G1y_9OJFxnq3JKq5g0YZd+mFueOjjvMzyyew@mail.gmail.com>
 <CAGa+x859+7H3pjZfTFcECe4qMt4=SE_kmToZBt9zoVt0=sUcvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGa+x859+7H3pjZfTFcECe4qMt4=SE_kmToZBt9zoVt0=sUcvA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 07:30:19AM -0700, Kevin Hilman wrote:
> Greg,
> 
> 
> On Tue, Aug 20, 2013 at 8:44 AM, Kevin Hilman <khilman@linaro.org> wrote:
> > +Felipe
> >
> > On Wed, Jul 17, 2013 at 6:29 AM, Alexander Savchenko
> > <oleksandr.savchenko@ti.com> wrote:
> >> From: Ruchika Kharwar <ruchika@ti.com>
> >>
> >> Ensure the Interrupt handling routine return IRQ_HANDLED vs
> >> IRQ_NONE.
> >
> > Why?
> >
> > By unconditionally returning IRQ_HANDLED, this patch will surely break
> > systems where the UART IRQ is shared with other platforms.
> >
> > I just noticed this patch when bisecting a related problem.  Why
> > wasn't this Cc'd to linux-omap where OMAP users might have been more
> > likely to see it?
> >
> > Greg, without a better justification in the changelog, I think this
> > patch should be dropped from tty-next.
> 
> Can you drop this from tty-next please?
> 
> The authors aren't responding (one of the ti.com addresses bounced)
> and this "fix" is most is not correct.

Yes, sorry, behind on my pending tty patch queue.  I'll try to get to it
this week.

greg k-h
