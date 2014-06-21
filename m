Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657AbaFUU3G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 16:29:06 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47593 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007AbaFUU3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 16:29:04 -0400
Date: Sat, 21 Jun 2014 22:29:01 +0200
From: Pavel Machek <pavel@ucw.cz>
To: pavel@ucw.cz
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        kernel list <linux-kernel@vger.kernel.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Subject: 3.16, i915: less colors in X?
Message-ID: <20140621202901.GA3840@amd.pavel.ucw.cz>
References: <alpine.LRH.2.00.1405141435510.30793@twin.jikos.cz>
 <20140514155759.GB9723@amd.pavel.ucw.cz>
 <20140514182046.GA13342@amd.pavel.ucw.cz>
 <alpine.LNX.2.00.1405151727380.16459@pobox.suse.cz>
 <CAKMK7uFEjDGSpdB0xDPL09GZ8N7aFrNA530HbRLyfTPx5SkLQw@mail.gmail.com>
 <20140607120614.GB5309@amd.pavel.ucw.cz>
 <20140607231124.GA3611@amd.pavel.ucw.cz>
 <CAKMK7uEALofLiEA3m-QKjygC=YZNjaEtUMfbpbXinMoim1ygkw@mail.gmail.com>
 <20140609102328.GA25332@amd.pavel.ucw.cz>
 <alpine.LNX.2.00.1406091302560.20782@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1406091302560.20782@pobox.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I just test-booted 3.16-rc1, and background in X looked just wrong --
very noticeable bands on the background gradient. I thought that maybe
it is just my eyes, but I went back to older kernel, and background is
ok now.

I'm trying to figure out how to ask X what color depth it is using...?

This is thinkpad x60 with Debian 6.0.9.

Any ideas?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
