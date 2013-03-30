Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757081Ab3C3R4c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 13:56:32 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33492 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757009Ab3C3R4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 13:56:31 -0400
Date: Sat, 30 Mar 2013 18:56:28 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Marc MERLIN <marc@merlins.org>
Cc: Linux Kernel mailing List <linux-kernel@vger.kernel.org>,
        edvx1@systemanalysen.net
Subject: Re: Supporting SYSRQ on broken laptops like the thinkpad T530
Message-ID: <20130330175628.GA28947@amd.pavel.ucw.cz>
References: <20130108230954.GN2044@merlins.org>
 <20130109023643.GA7066@mobil.systemanalysen.net>
 <20130322223141.GQ12428@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130322223141.GQ12428@merlins.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2013-03-22 15:31:41, Marc MERLIN wrote:
> On Wed, Jan 09, 2013 at 03:36:44AM +0100, Roland Eggner wrote:
> > On 2013-01-08 Tuesday at 15:09 -0800 Marc MERLIN wrote:
> > > In its infinite wisdom, lenovo has removed the sysrq key on the latest
> > > thinkpads, and replaced it with a stupid ALT+FN+S key combination, which
> > > doesn't really work for doing sysrq from the console (nor do I know how the
> > > genius who did that intended for SYSRQ-S to work).
> > > http://forums.lenovo.com/t5/T400-T500-and-newer-T-series/T430-s-T530-Where-are-the-shortcut-function-keys-break-Pause-etc/ta-p/781749
> > > 
> > > I realize that one solution is to throw my laptop window at a suitable high
> > > floorand replace it with one from a vendor that doesn't randomly remove keys
> > > from the keyboard.
> > > That said, I was wondering if there were other solutions, especially
> > > considering that thinkpads used to be the better linux laptops.
> > 
> > My Dell “Precision M4500” notebook suffers similar (same?) problem.  So far 
> > I could not find a solution better than this:  e.g. Alt-Fn-SysRq-s
> > 
> > press and hold Alt
> > press and hold Fn
> > press and leave F10|SysRq
> > leave Fn
> > press and leave s
> > leave Alt
> 
> Just for the sake of the archives, turns out that on the lenovo T430 and T530 
> you should ignore the Lenovo documentation I quoted above, and you can 
> indeed use the PrtSc key between Right Alt and Right Ctrl, that key works
> just fine for Sysrq.
> 
> I have no idea why Lenovo felt they had to document some complicated
> alternate software sysrq with Fn+S

Well... I feel resposible for sysrq stuff... I wanted it to be
non-intrusive. But it might have been bad choice - sysrq was not meant
to be used as a shift.

Sometimes it works, sometimes it does not. Don't blame lenovo for
that.

Maybe it should be modified to take sysrq and _then_ key?

Or maybe we should use something like lshift+rshift+lalt+ralt+key?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
