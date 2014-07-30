Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025AbaG3NCl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 09:02:41 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43982 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbaG3NCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 09:02:40 -0400
Date: Wed, 30 Jul 2014 15:02:38 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sergey Oboguev <oboguev.public@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] sched: deferred set priority (dprio)
Message-ID: <20140730130238.GE13965@amd.pavel.ucw.cz>
References: <CA+80gGYVjprinWEJWbVq4VxjOLjQri8EvGAJ+sx+ihcOxdstCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+80gGYVjprinWEJWbVq4VxjOLjQri8EvGAJ+sx+ihcOxdstCA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> One of the intended purposes of this facility (but its not sole purpose) is to
> render a lightweight mechanism for priority protection of lock-holding critical
> sections that would be an adequate match for lightweight locking primitives
> such as futex, with both featuring a fast path completing within the
> userspace.

Do we get a manpage describing the interface...?

Would it make sense to make set_priority a "vsyscall" so it is fast
enough, and delayed_set_priority does not need to be exposed to
userspace?
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
