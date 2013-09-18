Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182Ab3IRJUb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 05:20:31 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45173 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab3IRJU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 05:20:29 -0400
Date: Wed, 18 Sep 2013 11:20:27 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Felipe Balbi <balbi@ti.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: Fix style in s3c-hsotg.c
Message-ID: <20130918092027.GA8325@amd.pavel.ucw.cz>
References: <20130902135832.GA22300@amd.pavel.ucw.cz>
 <20130917154229.GI15645@radagast>
 <20130917220427.GC23937@amd.pavel.ucw.cz>
 <20130918014539.GB19817@radagast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130918014539.GB19817@radagast>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2013-09-17 20:45:39, Felipe Balbi wrote:
> On Wed, Sep 18, 2013 at 12:04:27AM +0200, Pavel Machek wrote:
> > On Tue 2013-09-17 10:42:30, Felipe Balbi wrote:
> > > Hi,
> > > 
> > > On Mon, Sep 02, 2013 at 03:58:32PM +0200, Pavel Machek wrote:
> > > > Hi!
> > > > 
> > > > checkpatch.pl has some valid complaints about style in s3c-hsotg.c :
> > > > macro with if should be really enclosed in do {} while, and puts is
> > > > going to be slightly faster.
> > > > 
> > > > Here's suggested patch. I don't have the hardware, so it is completely
> > > > untested.
> > > > 
> > > > Signed-off-by: Pavel Machek, <pavel@denx.de>
> > > 
> > > this is not how you send a patch, please read
> > > Documentation/SubmittingPatches
> > 
> > Have you considered possibility that this is how you nudge maintainer
> > into fix their coding style?
> 
> cute...
> 
> Seriously though, read that file, you're commit log has garbage in it
> which shouldn't go to git history.

Run git log on SubmittingPatches.

Then, instead of telling me what to read, run checkpatch on your
files. You can either fix them yourself, or use my patch as a
basis. Note there's missing } or something, so it probably will not
compile, see the other mail. So you actually will have to modify that
patch. Stripping "Hi!" from it should not be that hard, neither should
be stripping note that patch is untested when you actually test
it. And as you are the maintainer, it is your job.

No, I'll not polish patch for hardware I don't have and have little
interest in.  wanted to help you, but according to your first reply,
you do not really want help.

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
