Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314AbbAGTJa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 14:09:30 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:36769 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753672AbbAGTJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 14:09:28 -0500
X-Sasl-enc: RBKNo1DuG+DWIsA1hhaswugtT5rIUGJlZ47uxDZ0VcGh 1420657767
Date: Wed, 7 Jan 2015 11:09:26 -0800
From: Greg KH <greg@kroah.com>
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Sasha Levin <sasha.levin@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        stable <stable@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 1/2] time: settimeofday: Validate the values of tv from
 user
Message-ID: <20150107190926.GA4364@kroah.com>
References: <1420654340-3009-1-git-send-email-john.stultz@linaro.org>
 <1420654340-3009-2-git-send-email-john.stultz@linaro.org>
 <20150107182845.GA7699@kroah.com>
 <CALAqxLUSzc8yePiQS=5=C6q73eWm87yPfp_ZjXh8Nh=ydE592Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALAqxLUSzc8yePiQS=5=C6q73eWm87yPfp_ZjXh8Nh=ydE592Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2015 at 11:02:01AM -0800, John Stultz wrote:
> On Wed, Jan 7, 2015 at 10:28 AM, Greg KH <greg@kroah.com> wrote:
> > On Wed, Jan 07, 2015 at 10:12:19AM -0800, John Stultz wrote:
> >> From: Sasha Levin <sasha.levin@oracle.com>
> >>
> >> An unvalidated user input is multiplied by a constant, which can result in
> >> an undefined behaviour for large values. While this is validated later,
> >> we should avoid triggering undefined behaviour.
> >>
> >> Cc: Thomas Gleixner <tglx@linutronix.de>
> >> Cc: Ingo Molnar <mingo@kernel.org>
> >> Cc: stable <stable@vger.kernel.org>
> >> Cc: Andy Lutomirski <luto@amacapital.net>
> >> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> >> [jstultz: include trivial milisecond->microsecond correction noticed
> >> by Andy]
> >> Signed-off-by: John Stultz <john.stultz@linaro.org>
> >> ---
> >>  include/linux/time.h | 13 +++++++++++++
> >>  kernel/time/time.c   |  4 ++++
> >>  2 files changed, 17 insertions(+)
> >
> > <formletter>
> >
> > This is not the correct way to submit patches for inclusion in the
> > stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
> > for how to do this properly.
> >
> > </formletter>
> 
> Hrm. I'm not quite sure which rule I'm running afoul here.
> 
> Does this seem too much like a theoretical issue and not like enough
> of a "oh, that's not good" issue?

No, crap, my fault, I messed up on these, you are doing this just fine,
I'm not awake this morning...

/me goes off to get more coffee.

greg k-h
