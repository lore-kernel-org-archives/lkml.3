Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026Ab3CXKl6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 06:41:58 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43009 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896Ab3CXKlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 06:41:55 -0400
Date: Sun, 24 Mar 2013 11:41:53 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alan Cox <alan@linux.intel.com>, linux-input@vger.kernel.org,
        jkosina@suse.cz
Cc: George Spelvin <linux@horizon.com>, chris@the-brannons.com,
        gregkh@linuxfoundation.org, jslaby@suse.cz,
        linux-kernel@vger.kernel.org, samuel.thibault@ens-lyon.org
Subject: Re: Caps lock XOR on multiple keyboards?
Message-ID: <20130324104153.GA4586@amd.pavel.ucw.cz>
References: <20121203211911.20156.qmail@science.horizon.com>
 <20121203235848.04228689@bob.linux.org.uk>
 <20130324103018.GA4156@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130324103018.GA4156@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2013-03-24 11:30:18, Pavel Machek wrote:
> Hi!
> On Mon 2012-12-03 23:58:48, Alan Cox wrote:
> > On 3 Dec 2012 16:19:11 -0500
> > "George Spelvin" <linux@horizon.com> wrote:
> > 
> > > (Not sure who owns this; Cc: to the last few people to touch
> > > drivers/tty/vt/keyboard.c.)
> > 
> > linux-input is probably the best place to discuss this
> 
> Added few more ccs. Yes, I see that too, in kernels such as debian
> 2.6.32. It may be even older than that, but I was not using docking
> heavily in the old days.
> 
> Symptoms for me are that pretty often capslock LED will start show
> opposite of true capslock state. I normally use X these days.

Ok... so it is:

Each capslock key only controls the local LED, but affects global
state.

So I turn on capslock on PS/2 keyboard its led is on. But I type on
USB keyboard, its capslock led is off, but I type in all caps. Oops.

								Pavel 
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
