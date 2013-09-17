Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939Ab3IQWEa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 18:04:30 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57310 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448Ab3IQWE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 18:04:29 -0400
Date: Wed, 18 Sep 2013 00:04:27 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Felipe Balbi <balbi@ti.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: Fix style in s3c-hsotg.c
Message-ID: <20130917220427.GC23937@amd.pavel.ucw.cz>
References: <20130902135832.GA22300@amd.pavel.ucw.cz>
 <20130917154229.GI15645@radagast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130917154229.GI15645@radagast>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2013-09-17 10:42:30, Felipe Balbi wrote:
> Hi,
> 
> On Mon, Sep 02, 2013 at 03:58:32PM +0200, Pavel Machek wrote:
> > Hi!
> > 
> > checkpatch.pl has some valid complaints about style in s3c-hsotg.c :
> > macro with if should be really enclosed in do {} while, and puts is
> > going to be slightly faster.
> > 
> > Here's suggested patch. I don't have the hardware, so it is completely
> > untested.
> > 
> > Signed-off-by: Pavel Machek, <pavel@denx.de>
> 
> this is not how you send a patch, please read
> Documentation/SubmittingPatches

Have you considered possibility that this is how you nudge maintainer
into fix their coding style?

Thanks,
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
