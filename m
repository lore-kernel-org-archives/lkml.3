Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750982AbaH3Woe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 18:44:34 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57019 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbaH3Wod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 18:44:33 -0400
Date: Sun, 31 Aug 2014 00:44:30 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: cmroliv@gmail.com, marcel@holtmann.org, pali.rohar@gmail.com,
        kernel list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: patch "staging: remove nokia_hp4p driver
Message-ID: <20140830224430.GA19622@amd>
References: <14094295422869@kroah.com>
 <20140830213022.GA17147@amd>
 <20140830220417.GA15000@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140830220417.GA15000@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > 
> > What is going on here? I get flamed for not cleaning up the driver,
> > because I cleaned it up before merging to -staging. Ok, so I did more
> > cleanups, sent 3 cleanup patches, no reaction on those, and now I got
> > a note that you are going to remove the driver...?
> 
> For the 3 "cleanup" patches, the first one was rejected and you said to
> not include it, so I couldn't apply the others.

That was different series. I'm talking about:

[PATCH 1/3] staging: nokia_h4: switch to right types and use bdaddr_t
[PATCH 2/3] staging: nokia_h4: avoid __uX types
[PATCH 3/3] staging: use inlines where it makes sense

That is still valid and received no comments at all.

> > Please don't, I'd still like to clean the driver up and get included,
> > as n900's are still under active use.
> 
> As the Bluetooth maintainer has said a number of times, he doesn't want
> the driver in the tree as it is not doing the correct things.  It's been
> a long time in the tree with no work on it at all, and I follow the
> suggestions of the maintainers of the subsystems that staging drivers
> follow.

You asked for more work and explained how easy it is to revert the
removal.

I did more work, you ignored it, and are removing the driver, anyway.

> I suggest cleaning this up  in your own tree, and then just submitting it
> for inclusion in the "normal" part of the kernel.  That way I'm not

...creating a mess in the history, and fun merge problems for
people actually using the driver :-(. And yes, n900 people actually
are using it and have their own changes on top of it.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
