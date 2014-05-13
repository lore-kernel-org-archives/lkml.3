Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085AbaEMQuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 12:50:20 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34453 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbaEMQuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 12:50:07 -0400
Date: Tue, 13 May 2014 18:50:04 +0200
From: Pavel Machek <pavel@ucw.cz>
To: =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux-pm mailing list <linux-pm@lists.osdl.org>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 3.15-rc: regression in suspend
Message-ID: <20140513165004.GA5662@amd.pavel.ucw.cz>
References: <20140513160926.GA3621@amd.pavel.ucw.cz>
 <87wqdpy7l9.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87wqdpy7l9.fsf@nemi.mork.no>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-05-13 18:19:30, Bjørn Mork wrote:
> Pavel Machek <pavel@ucw.cz> writes:
> 
> > There seems to be regression in 3.15 w.r.t. suspend to ram and suspend
> > to disk.
> >
> > Resume sometiems works, but often, system is half-usable, with "what
> > do you want to do suspend/hibernate" dialog staying on screen.
> >
> > I did echo disk > /sys/power/state, and echo never returned to the
> > shell prompt. (X was not really working, either.)
> >
> > It is still there on 3.15.0-rc3+. I'll update to rc5 now.
> >
> > Any ideas?
> 
> This maybe? https://bugs.freedesktop.org/show_bug.cgi?id=76554

I seen that one before. I debugged situation where only top 20% of
screen was usable. But I believe that should be fixed.

Now... it seems that rc5 behaves ok... lets see if it happens again.

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
