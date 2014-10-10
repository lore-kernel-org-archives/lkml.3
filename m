Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963AbaJJMkX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 08:40:23 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56560 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbaJJMkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 08:40:19 -0400
Date: Fri, 10 Oct 2014 14:40:12 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Norbert Preining <preining@logic.at>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: /dev/root changes with 3.17-rc
Message-ID: <20141010124012.GA27653@amd>
References: <20140911144510.GK22037@auth.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140911144510.GK22037@auth.logic.tuwien.ac.at>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> (please cc)

Rafael, as he tracks regressions.

> I am not sure whether this is a kernel bug, but:
> - booting with 3.16 I get
> 	/ mounted on /dev/sda6
> - booting with 3.17-rc* I get
> 	/ mounted on /dev/root

Where do you see the this? /proc/mounts?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
