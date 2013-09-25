Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab3IYTak (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 15:30:40 -0400
Received: from imap.thunk.org ([74.207.234.97]:37974 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753365Ab3IYTai (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 15:30:38 -0400
Date: Wed, 25 Sep 2013 15:30:35 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Joe Perches <joe@perches.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@shadowen.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] checkpatch: Find CamelCase definitions of
 struct/union/enum
Message-ID: <20130925193035.GA11905@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Joe Perches <joe@perches.com>, Al Viro <viro@ZenIV.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Whitcroft <apw@shadowen.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <1380047934.3575.100.camel@joe-AO722>
 <20130925152432.GY13318@ZenIV.linux.org.uk>
 <1380123344.17366.5.camel@joe-AO722>
 <20130925161949.GZ13318@ZenIV.linux.org.uk>
 <1380136920.17366.15.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380136920.17366.15.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 12:22:00PM -0700, Joe Perches wrote:
> 
> > 	* labels a-la Enomem, etc.  I've been using those and I will
> > keep doing so, checkpatch.pl and its users be damned.
> 
> Good on you.

I'm with Al.  This is just silly to add to checkpatch.

> Fine by me.  Don't use checkpatch.  No stress from me.

I still get some of your minions sending patches asking to "fix" ext4
from time to time.  It wastes everyone's time.

BTW, checkpatch barfs on pretty much everything in
linux/trace/events/*.h

						- Ted
