Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692Ab3FQT6y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 15:58:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40433 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242Ab3FQT6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 15:58:52 -0400
Date: Mon, 17 Jun 2013 12:58:51 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH 0/4] [resend] n_tty fixes
Message-ID: <20130617195851.GA31669@kroah.com>
References: <20130319141017.GB24900@kroah.com>
 <1371295711-3963-1-git-send-email-peter@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371295711-3963-1-git-send-email-peter@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 15, 2013 at 07:28:27AM -0400, Peter Hurley wrote:
> On 03/19/2013 10:10 AM, Greg Kroah-Hartman wrote:> On Tue, Mar 19, 2013 at 09:57:09AM -0400, Peter Hurley wrote:
> >> On Mon, 2013-03-18 at 16:15 -0700, Greg Kroah-Hartman wrote:
> >>> On Wed, Mar 06, 2013 at 08:38:22AM -0500, Peter Hurley wrote:
> >>>> minimum_to_wake is unique to N_TTY processing, and belongs in
> >>>> per-ldisc data.
> >>>>
> >>>> Add the ldisc method, ldisc_ops::fasync(), to notify line disciplines
> >>>> when signal-driven I/O is enabled or disabled. When enabled for N_TTY
> >>>> (by fcntl(F_SETFL, O_ASYNC)), blocking reader/polls will be woken
> >>>> for any readable input. When disabled, blocking reader/polls are not
> >>>> woken until the read buffer is full.
> >>>>
> >>>> Canonical mode (L_ICANON(tty), n_tty_data::icanon) is not affected by
> >>>> the minimum_to_wake setting.
> >>>>
> >>>> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> >>>
> >>> For some reason, this patch doesn't apply.  Care to refresh this one,
> >>> and the rest in this series, and resend?
> >>
> >> Sorry. There was probably some accidental dependency on one of the other
> >> patchsets of mine you did apply.
> >>
> >> This and patch 5 now apply without error to tty-next.
> > 
> > Ok, but they are now long gone from my queue.  Can you please resend
> > what I haven't applied?
> 
> Greg,
> 
> I resent these back on 19 Mar but they never got applied. (maybe because
> I resent them as 4,5,6 & 7/7 ??)

Yes, they were burried, sorry about that :)

> Anyway, these apply cleanly to tty-next.

Now applied, thanks.

greg k-h
