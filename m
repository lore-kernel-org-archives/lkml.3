Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751428AbaG0BCD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 21:02:03 -0400
Received: from imap.thunk.org ([74.207.234.97]:58937 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184AbaG0BCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 21:02:00 -0400
Date: Sat, 26 Jul 2014 21:01:44 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Peter Zijlstra <peterz@infradead.org>, Gioh Kim <gioh.kim@lge.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 0/2] new API to allocate buffer-cache for superblock in
 non-movable area
Message-ID: <20140727010144.GA13438@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Peter Zijlstra <peterz@infradead.org>, Gioh Kim <gioh.kim@lge.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
References: <53CDF437.4090306@lge.com>
 <20140722073005.GT3935@laptop>
 <20140722081440.GA5137@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140722081440.GA5137@thunk.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gioh,

As follow up, if you want some further discussions about why these
patches should be accepted, it would be good to get some hard data
about why the keeping the ext4 superblock pinned is causing such a
problem for page migation.  Can you give us more details about what
the impact is of not having these patches?  And how it compres to
other data structures which are currently allocated in the moveable
area and tend to be pinned effectively indefinitely?

Thanks,

						- Ted
