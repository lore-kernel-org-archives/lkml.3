Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657AbaKLBQn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:16:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58292 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381AbaKLBQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:16:42 -0500
Date: Wed, 12 Nov 2014 10:14:38 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: "Sean O. Stalley" <sean.stalley@intel.com>
Cc: devel@driverdev.osuosl.org, linux-usb@vger.kernel.org,
        Stephanie Wallick <stephanie.s.wallick@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [V2 PATCH 03/10] added media agnostic (MA) data structures and
 handling
Message-ID: <20141112011438.GA7216@kroah.com>
References: <1415671781-11351-1-git-send-email-stephanie.s.wallick@intel.com>
 <1415671781-11351-3-git-send-email-stephanie.s.wallick@intel.com>
 <20141111043821.GD22068@kroah.com>
 <20141111224222.GB3415@sean.stalley.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141111224222.GB3415@sean.stalley.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 02:42:22PM -0800, Sean O. Stalley wrote:
> On Tue, Nov 11, 2014 at 01:38:21PM +0900, Greg KH wrote:
> > On Mon, Nov 10, 2014 at 06:09:34PM -0800, Stephanie Wallick wrote:
> > Intel has a whole group of very experienced Linux kernel developers who
> > will review code before you sent it out publicly.  Please take advantage
> > of them and run this all through them before resending this out again.
> > 
> > If you did run this code through that group, please let me know who it
> > was specifically that allowed this stuff to get through, and why they
> > didn't want their name on this code submission.  I need to have a strong
> > word with them...
> 
> We submitted the patches for internal review and got no objections to
> release. We will be more aggressive in seeking out feedback (and approval)
> before resubmitting any code.

Fair enough, it seems you took the only available path and submitted it
to the community, which was a good idea, sorry for the rant.  Thanks for
submitting it publicly and not just "waiting forever" like I have seen
some people do in the past.

> > Yes, I am holding you to a higher standard than staging code normally
> > is, and yes, it is purely because of the company you work for.  But I
> > only do that because your company knows how to do this stuff right, and
> > you have access to the resources and talent to help make this code
> > right.  Other people and companies do not have the kind of advantage
> > that you do.
> 
> We know we are fortunate to work for a company with so much talent and
> resources and we don't mind being held to a higher standard. We have been
> receiving multiple requests for our host driver and wanted to make it
> available as soon as possible for others to use. We thought putting our
> host driver into staging would be a good way to release it, but realize now
> that it was premature. 

Does the code even work?  The number of basic mistakes in it seems to
imply that it doesn't, but I could be mistaken.

> We won't resubmit the driver until a senior kernel developer has signed off on it.

Good, go kick some of them and get them to review the code, _after_ at
least addressing the issues that the community has raised, you don't
want to waste their time finding the same things we just did :)

thanks,

greg k-h
