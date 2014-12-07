Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030AbaLGJze (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 04:55:34 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40538 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928AbaLGJzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 04:55:32 -0500
Date: Sun, 7 Dec 2014 10:55:29 +0100
From: Pavel Machek <pavel@ucw.cz>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Alex Dubov <alex.dubov@gmail.com>, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, corbet@lwn.net, richardcochran@gmail.com
Subject: Re: syscall: introduce sendfd() syscall (v.2)
Message-ID: <20141207095529.GA18733@amd>
References: <1417597255-32530-1-git-send-email-oakad@yahoo.com>
 <20141205132250.6f2f9ec1@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141205132250.6f2f9ec1@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-12-05 13:22:50, One Thousand Gnomes wrote:
> 
> > 2.a. If task A has sufficient capabilities to send signals to task B, then
> > task A is already in position to do anything it wants with task B, including
> > killing it outright.
> 
> Not entirely true.
> 
> - We have securirty models like SELinux
> - We have namespaces and being able to send an fd between namespaces is
>   not quite as flexible as you would make it
> 
> I suspect therefore it needs security hooks but otherwise looks more sane
> than the current AF_UNIX approach.

The right test for "can do anything" is "can_ptrace()"...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
