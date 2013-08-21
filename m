Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751541Ab3HUAkM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 20:40:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40663 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab3HUAkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 20:40:11 -0400
Date: Tue, 20 Aug 2013 17:42:01 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, lwn@lwn.net,
        Hugh Dickins <hughd@google.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Borislav Petkov <bp@alien8.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Proposed stable release changes
Message-ID: <20130821004201.GA5461@kroah.com>
References: <20130820224032.GA20491@kroah.com>
 <20130820231117.GA24702@roeck-us.net>
 <20130820231743.GA992@kroah.com>
 <20130821001111.GB5441@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130821001111.GB5441@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 05:11:11PM -0700, Guenter Roeck wrote:
> On Tue, Aug 20, 2013 at 04:17:43PM -0700, Greg KH wrote:
> > On Tue, Aug 20, 2013 at 04:11:17PM -0700, Guenter Roeck wrote:
> > > It would be even better if you could find the time to push -rc releases
> > > into the stable repository before you accept patches into a stable branch.
> > 
> > What do you mean by this?
> >
> > The git tree?  I could do that, but when I have to drop a patch, it
> > would cause a mess if I had to always go forwards.
> > 
> That is not what I mean. I referred to the master branch of the stable
> repository, which you normally update to the most recent -rc when you
> publish a new -stable release.

Ah, ok, that makes sense.  I've updated it to 3.11-rc6 now.  Sorry for
the confusion.

greg k-h
