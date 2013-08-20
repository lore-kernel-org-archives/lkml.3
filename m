Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876Ab3HTQnq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 12:43:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34968 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441Ab3HTQno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 12:43:44 -0400
Date: Tue, 20 Aug 2013 09:43:43 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, Johannes Berg <johannes@sipsolutions.net>,
        Borislav Petkov <bp@alien8.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, lwn@lwn.net,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 3.0.92
Message-ID: <20130820164343.GA3958@kroah.com>
References: <20130820155735.GA2805@kroah.com>
 <CA+55aFxrPP8=xPWuRVy0HPyiFkT8Mc03zWGKosg+WrEQfqNDfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxrPP8=xPWuRVy0HPyiFkT8Mc03zWGKosg+WrEQfqNDfQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 09:33:30AM -0700, Linus Torvalds wrote:
> On Tue, Aug 20, 2013 at 8:57 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > Johannes Berg (1):
> >       genetlink: fix family dump race
> 
> This one turns out to be buggy, see thread called "3.11-rc6 genetlink
> locking fix offends lockdep".

Yeah, I messed up in keeping it here, I'll go revert it and push out a
new 3.0 release.

> I really think there should be delay before stable picks up stuff from
> mainline, unless it's something particularly critical and
> well-discussed.. Maybe a week or so.

I can do that, it's just hard to tell from my end what is "well
discussed" all the time.

> Now it's both in 3.0 and 3.10, so the revert (unless we find a better
> fix - and the first two patches have already failed) will have to go
> there too.

I thought that there was a fix already for this...  Ah, no, that was for
another reported regression in an older 3.10-stable release, my bad.

Johannes, what do you want to do here?  Just revert it in Linus's tree
for now, given the late -rc cycle?

thanks,

greg k-h
