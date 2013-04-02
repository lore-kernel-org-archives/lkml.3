Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761469Ab3DBLv7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 07:51:59 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43968 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761453Ab3DBLvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 07:51:53 -0400
Date: Tue, 2 Apr 2013 13:51:51 +0200
From: Pavel Machek <pavel@denx.de>
To: Guenter Roeck <linux@roeck-us.net>
Cc: sr@denx.de, w.sang@pengutronix.de, magnus.damm@gmail.com,
        hjk@linutronix.de, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, dzu@denx.de
Subject: Re: UIO device tree bindings.
Message-ID: <20130402115151.GA9052@amd.pavel.ucw.cz>
References: <20130401142336.GA18034@amd.pavel.ucw.cz>
 <20130401154008.GA20963@amd.pavel.ucw.cz>
 <20130402024212.GA19431@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130402024212.GA19431@roeck-us.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2013-04-01 19:42:12, Guenter Roeck wrote:
> On Mon, Apr 01, 2013 at 05:40:08PM +0200, Pavel Machek wrote:
> > On Mon 2013-04-01 16:23:36, Pavel Machek wrote:
> > > Hi!
> > > 
> > > I'd like to get uio device tree bindings to work -- with recent FPGA
> > > parts it will be important. Latest version I see is 
> > > 
> > > https://lists.ozlabs.org/pipermail/linuxppc-dev/2009-June/073087.html
> > > 
> > > ... Is there anything newer?
> > > 
> > > I red the discussion, and main problem seems to be the "tell kernel to
> > > drive this device tree device", right?
> > 
> Problem seems to be the notion that the proposed devicetree entry would not
> describe the hardware, but its use. Not really sure I understand the problem,
> as I would see the hardware description to be "A hardware device which is
> compatible to and managed by the generic-uio driver". I would argue that
> this _is_ a hardware description (if not, what is ?), but I am not the one
> to make the call.

Well... one could argue that having "generic-uio" in board's device
tree _is_ wrong, but having driver that binds to "generic-uio" is
not. Hmm?

Or maybe we can do some magic with module parameter. That should be
enough for expected use.

> > So... here's the port to recent kernels. Not for mainline.
> > 
> > Signed-off-by: Pavel Machek <pavel@denx.de>
> > 
> Turns out this is exactly what I need, and your post saves me the time
> I would have spent writing essentially the same code and submitting it,
> only to have it rejected.
> 
> Thanks a lot for digging this up!

You are welcome :-). Thanks for helping with testing ;-).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
