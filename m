Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836Ab3HTXRq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 19:17:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38749 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab3HTXRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 19:17:44 -0400
Date: Tue, 20 Aug 2013 16:17:43 -0700
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
Message-ID: <20130820231743.GA992@kroah.com>
References: <20130820224032.GA20491@kroah.com>
 <20130820231117.GA24702@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130820231117.GA24702@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 04:11:17PM -0700, Guenter Roeck wrote:
> It would be even better if you could find the time to push -rc releases
> into the stable repository before you accept patches into a stable branch.

What do you mean by this?

The git tree?  I could do that, but when I have to drop a patch, it
would cause a mess if I had to always go forwards.

I could do branches for -rc releases, that end up as the
"end-of-the-line", and I create the next .y release on top of the
previous one, not the -rc release.

That's kind of what I do "internally" when I create the -rc releases in
the first place, but I just delete those throw-away trees, and never
push them publicly anywhere.

Does it really help anyone to do this, except for some automated
testing?  Doesn't the -rc patch work good enough for that?

> I am now running my test suite on stable/master, so that would give it
> some time to catch new problems before they make their way into a stable
> branch.

I don't understand what you mean here.

thanks,

greg k-h
