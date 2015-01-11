Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546AbbAKKNG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 05:13:06 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40068 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbbAKKNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 05:13:01 -0500
Date: Sun, 11 Jan 2015 11:12:58 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Greg KH <greg@kroah.com>,
        pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        khilman@kernel.org, aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com
Subject: Re: Getting new udev to run with 2.6.28
Message-ID: <20150111101258.GA11391@amd>
References: <20150110173920.GA31847@amd>
 <7348917.heGelKEtgq@merkaba>
 <20150110230653.GB22149@ZenIV.linux.org.uk>
 <2200602.Xp3g1GYm9A@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2200602.Xp3g1GYm9A@merkaba>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2015-01-11 10:04:26, Martin Steigerwald wrote:
> Am Samstag, 10. Januar 2015, 23:06:53 schrieb Al Viro:
> > On Sat, Jan 10, 2015 at 11:25:39PM +0100, Martin Steigerwald wrote:
> > > > ... and this, boys and girls, is why quite a few of us have loathed udev
> > > > way before it got merged into even nastier shitpile.  Still do, for that
> > > > matter.
> > > 
> > > You mean systemd by that?
> > 
> > Yes, I do.  Has it been merged into any other?
> 
> Not that I am aware of.
> 
> I was just surprised to read such clear words about systemd from a kernel 
> developer – now I wonder why tough. I think I thought most were in support for 
> it.

I wonder where you got that impression. Anyway, this discussion is
slightly offtopic on lkml.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
