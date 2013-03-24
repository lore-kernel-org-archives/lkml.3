Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991Ab3CXKaY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 06:30:24 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41873 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781Ab3CXKaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 06:30:20 -0400
Date: Sun, 24 Mar 2013 11:30:18 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alan Cox <alan@linux.intel.com>, linux-input@vger.kernel.org,
        jkosina@suse.cz
Cc: George Spelvin <linux@horizon.com>, chris@the-brannons.com,
        gregkh@linuxfoundation.org, jslaby@suse.cz,
        linux-kernel@vger.kernel.org, samuel.thibault@ens-lyon.org
Subject: Re: Caps lock XOR on multiple keyboards?
Message-ID: <20130324103018.GA4156@amd.pavel.ucw.cz>
References: <20121203211911.20156.qmail@science.horizon.com>
 <20121203235848.04228689@bob.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121203235848.04228689@bob.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
On Mon 2012-12-03 23:58:48, Alan Cox wrote:
> On 3 Dec 2012 16:19:11 -0500
> "George Spelvin" <linux@horizon.com> wrote:
> 
> > (Not sure who owns this; Cc: to the last few people to touch
> > drivers/tty/vt/keyboard.c.)
> 
> linux-input is probably the best place to discuss this

Added few more ccs. Yes, I see that too, in kernels such as debian
2.6.32. It may be even older than that, but I was not using docking
heavily in the old days.

Symptoms for me are that pretty often capslock LED will start show
opposite of true capslock state. I normally use X these days.

(Other problem seems to be that keyboard LEDs are not updated on
keyboard hotplug.)

There is patch to drive keyboard LEDs through LED subsystem, perhaps
that would be good idea?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
