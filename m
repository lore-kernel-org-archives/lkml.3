Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbaIPSOA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 14:14:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40545 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000AbaIPSN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 14:13:58 -0400
Date: Tue, 16 Sep 2014 11:13:10 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tim Gardner <tim.gardner@canonical.com>, hpa@zytor.com
Cc: Kamal Mostafa <kamal@canonical.com>, kernel-team@lists.ubuntu.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [3.13.y.z extended stable] Linux 3.13.11.7 stable review
Message-ID: <20140916181310.GB24080@kroah.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
 <20140916000309.GA8853@kroah.com>
 <54178FEB.3000606@canonical.com>
 <20140916012609.GB29475@kroah.com>
 <5418548B.9080609@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5418548B.9080609@canonical.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding in hpa as he has objected to the current naming scheme as well.

On Tue, Sep 16, 2014 at 09:17:31AM -0600, Tim Gardner wrote:
> On 09/15/2014 07:26 PM, Greg KH wrote:
> > On Mon, Sep 15, 2014 at 07:18:35PM -0600, Tim Gardner wrote:
> >> On 09/15/2014 06:03 PM, Greg KH wrote:
> >>> On Mon, Sep 15, 2014 at 03:06:50PM -0700, Kamal Mostafa wrote:
> >>>> This is the start of the review cycle for the Linux 3.13.11.7 stable kernel.
> >>>>
> >>>> This version contains 187 new patches, summarized below.  The new patches are
> >>>> posted as replies to this message and also available in this git branch:
> >>>>
> >>>> http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=linux-3.13.y-review;a=shortlog
> >>>>
> >>>> git://kernel.ubuntu.com/ubuntu/linux.git  linux-3.13.y-review
> >>>>
> >>>> The review period for version 3.13.11.7 will be open for the next three days.
> >>>> To report a problem, please reply to the relevant follow-up patch message.
> >>>
> >>> As I asked before, please change the name to not be x.y, it is confusing
> >>> for lots of people.
> >>>
> >>> Use the "normal" way of naming kernel releases, pick a few character
> >>> naming scheme please.
> >>>
> >>
> >> I think what Kamal said is that he would consider your request. I,
> >> however, don't think it wise to change version schemes mid-stream in an
> >> established series.
> > 
> > Even if that "established series" is the thing that is causing
> > complaints?
> > 
> >> Can you provide hard evidence that this version scheme is confusing lots
> >> of people ? I'm only aware of one complaint voiced by Peter Anvin at the
> >> kernel summit (http://lwn.net/Articles/608917/).
> > 
> > Peter's complaint is one that I know of that is in the public record.
> > 
> > So is mine.
> > 
> > How many others do you need?
> > 
> 
> This is a seriously silly argument over an _opinion_ of what is
> "confusing", and so far I am not feeling moved by the number of contrary
> opinions.

So, what would it take to "move" you?

People have expressed the fact that the naming by your team of these
kernels is confusing.  Users are thinking these are being done on the
kernel.org infrastructure, due to a lack of any non "numeric" digit in
the kernel version.  Adding a 4th number, while great, seems to not be
enough to be able to easily determine the difference here.

> Our version scheme makes sense from a Debian perspective in that it
> indicates exactly when the Canonical branch was started.

I agree, but it does not convey it is a "Canonical branch" at all on
its own.  Which is causing the confusion here.

> It also has the
> advantage of being distinguishable from the kernel.org version.

By the "trailing digit", i.e. ".y", only.  It's just an aditional
number, not a "vendor version mark", like most packaging systems all
incorporate to show obviously that there is a difference from the
"upstream" release here.

> I _want_ the consumer to be aware of where they have acquired their
> kernel sources (as if the git URL is insufficient). Frankly, if the
> version is an _enduring_ source of confusion, then perhaps the
> consumer should seek other endeavors.

You are really trying to use the "if the user is so dumb to understand,
they should just go away" argument here?  I value our users more than
that, they are the only reason we will survive over time.  You will not
succeed by going around calling them names.

greg k-h
