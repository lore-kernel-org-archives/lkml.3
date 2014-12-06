Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659AbaLFSEd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 13:04:33 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55269 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbaLFSEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 13:04:31 -0500
Date: Sat, 6 Dec 2014 19:04:29 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: sre@debian.org, sre@ring0.de, kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, freemangordon@abv.bg
Subject: Re: N900: fixing MMC at boot
Message-ID: <20141206180429.GA312@amd>
References: <20141206173526.GA7964@amd>
 <201412061840.16157@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201412061840.16157@pali>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2014-12-06 18:40:16, Pali Rohár wrote:
> On Saturday 06 December 2014 18:35:27 Pavel Machek wrote:
> > Hi!
> > 
> > For a long time, MMC was not working during boot... (making
> > the box unusable without nfsroot). It seems problem is in the
> > regulators, because with diff below, I was able to mount root
> > on SD card for a first time ... in a long time.
> > 
> 
> Hi, do you mean external SD card or internal eMMC (MyDocs)?

I mean u-SD card. But it is strange. I reverted the patch now, and it
still works. Not sure why or what I've done differently.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
