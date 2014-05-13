Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751576AbaEMQho (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 12:37:44 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34050 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbaEMQhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 12:37:37 -0400
Date: Tue, 13 May 2014 18:37:35 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux-pm mailing list <linux-pm@lists.osdl.org>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 3.15-rc: regression in suspend
Message-ID: <20140513163734.GA4602@amd.pavel.ucw.cz>
References: <20140513160926.GA3621@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140513160926.GA3621@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> There seems to be regression in 3.15 w.r.t. suspend to ram and suspend
> to disk.
> 
> Resume sometiems works, but often, system is half-usable, with "what
> do you want to do suspend/hibernate" dialog staying on screen.
> 
> I did echo disk > /sys/power/state, and echo never returned to the
> shell prompt. (X was not really working, either.)
> 
> It is still there on 3.15.0-rc3+. I'll update to rc5 now.

3.15.0-rc5+ seems to behave a bit better. Lets see if it reappears.

Thanks,
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
