Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175AbaKWJsx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 04:48:53 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35678 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129AbaKWJsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 04:48:51 -0500
Date: Sun, 23 Nov 2014 10:48:43 +0100
From: Pavel Machek <pavel@ucw.cz>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Martin Tournoij <martin@arp242.net>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] The SIGINFO signal from BSD
Message-ID: <20141123094843.GA26434@Nokia-N900>
References: <1415200663.3247743.187387481.75CE9317@webmail.messagingengine.com>
 <545A7B00.1040309@gmail.com>
 <20141105201404.GH27083@thunk.org>
 <20141110142200.676b5d04@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141110142200.676b5d04@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2014-11-10 14:22:00, One Thousand Gnomes wrote:
> > wouldn't be accepted.  (BTW, if you're going to do this, note that ^T
> > could be remapped to any control character via stty; so to do this we
> > would need to define an extra index in c_cc[] array in the struct
> > termios.)
> 
> We have 19 entries in the array and no platforms that byte pack so that
> would actually be doable I think.
> 
> I'm really dubious about its value in the Linux world. You could do far
> better teaching the GUI desktop to walk the process tree of clients and
> dump the window owners process subtrees in a nice pop up window.

I use ssh way too much, so yes, I'd like to see SIGINFO.

Forgetting to add -v to cp command line is too common.

I can help testing patches :-).

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
