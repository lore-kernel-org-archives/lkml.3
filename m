Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760312Ab3EXKBR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 06:01:17 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38998 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760017Ab3EXKBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 06:01:16 -0400
Date: Fri, 24 May 2013 12:01:14 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Eric Blake <eblake@redhat.com>
Cc: =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>,
        linux-kernel@vger.kernel.org
Subject: Re: RFC: allow empty symlink targets
Message-ID: <20130524100114.GB14554@amd.pavel.ucw.cz>
References: <1358427833-3847-1-git-send-email-P@draigBrady.com>
 <50F8252C.2060404@draigBrady.com>
 <519381D8.5080206@draigBrady.com>
 <51939E49.1040209@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51939E49.1040209@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Following up from http://austingroupbugs.net/view.php?id=649
> > It seems POSIX will now allow the current Linux behavior of returning ENOENT,
> 
> Huh?  Linux currently doesn't allow the creation of an empty symlink.
> That link mentions the current BSD behavior of returning ENOENT when
> resolving such a symlink (that is, what stat() does when chasing through
> an empty symlink, provided such a symlink is first created).
> 
> > or the Solaris behavior of allowing empty symlink targets.
> 
> The point made in that bug report is that Linux is buggy for not
> allowing symlink() to create an empty symlink in the first place; once
> you allow the creation of an empty symlink, then how to handle such a
> symlink in stat() is up to you whether to copy Solaris' or BSD's example.

What happens when Linux tries to follow symlink created by
BSD/Solaris? I'm sure BSDs can write ext2 and we can read some BSD
filesystems...
									Pavel
									
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
