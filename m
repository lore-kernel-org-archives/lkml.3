Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751362AbaLEKcw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 05:32:52 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49358 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbaLEKcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 05:32:50 -0500
Date: Fri, 5 Dec 2014 11:32:48 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Joe Perches <joe@perches.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>, cocci <cocci@systeme.lip6.fr>,
        LKML <linux-kernel@vger.kernel.org>
Subject: printf vs. printk (was Re: Side-effect free printk?)
Message-ID: <20141205103248.GA6945@amd>
References: <1417629003.2902.14.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417629003.2902.14.camel@perches.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

BTW... All the time I'm programming in kernel, I use printf(), and
when hacking userspace, I use printk().

Nasty.

Given that printf() and printk() have exactly the same behaviour,
could we allow printf() in kernel? Now... printk()s are usually
removed before merging the driver, so code will not see much change,
but it will certainly result in less 4-letter words while developing.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
