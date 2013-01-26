Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185Ab3AZPny (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 10:43:54 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:45582 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086Ab3AZPnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 10:43:52 -0500
Date: Sat, 26 Jan 2013 10:43:40 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: paul.szabo@sydney.edu.au, 695182@bugs.debian.org, ben@decadent.org.uk,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, minchan@kernel.org
Subject: Re: [PATCH] Subtract min_free_kbytes from dirtyable memory
Message-ID: <20130126154340.GC5887@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Jonathan Nieder <jrnieder@gmail.com>, paul.szabo@sydney.edu.au,
	695182@bugs.debian.org, ben@decadent.org.uk,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	minchan@kernel.org
References: <1359118913.3146.3.camel@deadeye.wl.decadent.org.uk>
 <201301252349.r0PNnFYF024399@como.maths.usyd.edu.au>
 <20130126001419.GG3341@elie.Belkin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130126001419.GG3341@elie.Belkin>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(In the teach a person to fish category...)

If you know the file and line number where a bug/regression was
introduced, the "git blame" command is a great tool for identifying
the commit which changed a given line of code.  Then use "git tag
--contains <commit it>" to see when a particular commit was introduced
into the mainline kernel.

					- Ted
