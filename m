Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087Ab3IMXDu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 19:03:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39500 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497Ab3IMXDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 19:03:48 -0400
Date: Fri, 13 Sep 2013 16:03:47 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [ 00/16] 3.11.1-stable review
Message-ID: <20130913230347.GA5211@kroah.com>
References: <20130912181156.173326121@linuxfoundation.org>
 <CA+55aFwN78n92A_mnOve0RsBgHh+o_1KOBvn9d+a2gorXEP6QQ@mail.gmail.com>
 <CA+55aFyiR8ugfFsy3dmofD_G+sPkEqYEQbg2wh7hgXnt-H_Uag@mail.gmail.com>
 <20130912182240.GA10404@kroah.com>
 <20130912182730.GA11890@kroah.com>
 <523398D1.1070106@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <523398D1.1070106@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 04:59:29PM -0600, Shuah Khan wrote:
> On 09/12/2013 12:27 PM, Greg Kroah-Hartman wrote:
> >On Thu, Sep 12, 2013 at 11:22:40AM -0700, Greg Kroah-Hartman wrote:
> >>On Thu, Sep 12, 2013 at 11:18:40AM -0700, Linus Torvalds wrote:
> >>>On Thu, Sep 12, 2013 at 11:17 AM, Linus Torvalds
> >>><torvalds@linux-foundation.org> wrote:
> >>>>Your script may be a bit buggered...
> >>>
> >>>Or maybe I should take that as a sign that 3.11 is doing really well?
> >>>
> >>>I'll be optimistic.
> >>
> >>Hm, something went wrong here, let me track it down...
> >
> >Ok, that was my fault, was working off of a 'master' branch in a repo
> >that expected it to be on the linux-3.11.y branch.  Here's the real
> >pseudo-shortlog below.
> >
> >And it is short for now, as I've been holding off on applying patches
> >that are in your tree until 3.12-rc1 comes out.  The patches here are
> >ones that people have pointed out to me that should go in specifically
> >for various reasons.  So yes, I do think 3.11 is doing really well, I
> >have not heard of anything "major" being wrong with it yet.
> >
> >thanks,
> >
> >greg k-h
> >
> >
> 
> 3.11.1-rc1 applied cleanly to 3.11
> 
> Compiled and booted on the following systems:
> 
> Samsung Series 9 900X4C Intel Corei5
> HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics
> 
> dmesgs look good. No regressions compared to the previous dmesgs for
> this release. dmesg emerg, crit, alert, err are clean. No
> regressions in warn.

Great, thanks for testing and letting me know.

greg k-h
