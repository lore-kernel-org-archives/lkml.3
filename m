Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751196AbaLQFHx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 00:07:53 -0500
Received: from imap.thunk.org ([74.207.234.97]:60115 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbaLQFHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 00:07:51 -0500
Date: Wed, 17 Dec 2014 00:07:46 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: nick <xerofoify@gmail.com>, akpm@linux-foundation.org, fabf@skynet.be,
        sasha.levin@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: Remove cramfs source code from mainline kernel?
Message-ID: <20141217050746.GY17575@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Al Viro <viro@ZenIV.linux.org.uk>, nick <xerofoify@gmail.com>,
	akpm@linux-foundation.org, fabf@skynet.be, sasha.levin@oracle.com,
	linux-kernel@vger.kernel.org
References: <5490E6F8.4030207@gmail.com>
 <20141217024602.GG22149@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141217024602.GG22149@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 02:46:02AM +0000, Al Viro wrote:
> 
> a) learn to use line breaks
> b) what do we win from removing it?  If it starts becoming inconvenient to
> maintain, it might make sense to consider removal, but as it is...  What,
> somebody has slapped a couple of F-words in there?  "FIXME", that is...
> 
> Al, seriously tempted to add
> 
> /* FIXME.  FIXME.  FIXME.  DO NOT remove that comment - it serves
> a very important purpose by tormenting a certain fetishist */
> 
> on top of a bunch of files in fs/*.c, just to see what effect will it have...

Al, in case you didn't know, Nick Krause has been banned from LKML for
being a troll[1][2][3].  A common troll tactic is to cc a few people
plus the mailing list from which he is banned, in the hopes that
people will get tricked into replying and quoting his original
message, thus evading the ban.

						- Ted

[1] https://lkml.org/lkml/2014/8/4/206
[2] http://lists.kernelnewbies.org/pipermail/kernelnewbies/2014-December/012934.html
[3] http://lists.kernelnewbies.org/pipermail/kernelnewbies/2014-December/012938.html

						- Ted
