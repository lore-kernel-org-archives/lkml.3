Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758331AbaCSCGX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 22:06:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26294 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497AbaCSCGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 22:06:21 -0400
Date: Tue, 18 Mar 2014 22:06:02 -0400
From: Dave Jones <davej@redhat.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Hugh Dickins <hughd@google.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, Bob Liu <bob.liu@oracle.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: bad rss-counter message in 3.14rc5
Message-ID: <20140319020602.GA29787@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	Hugh Dickins <hughd@google.com>,
	Cyrill Gorcunov <gorcunov@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>, Bob Liu <bob.liu@oracle.com>,
	Konstantin Khlebnikov <koct9i@gmail.com>
References: <20140311132024.GC32390@moon>
 <531F0E39.9020100@oracle.com>
 <20140311134158.GD32390@moon>
 <20140311142817.GA26517@redhat.com>
 <20140311143750.GE32390@moon>
 <20140311171045.GA4693@redhat.com>
 <20140311173603.GG32390@moon>
 <20140311173917.GB4693@redhat.com>
 <alpine.LSU.2.11.1403181703470.7055@eggly.anvils>
 <5328F3B4.1080208@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5328F3B4.1080208@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 09:32:36PM -0400, Sasha Levin wrote:
 
 > > Untested patch below: I can't quite say Reported-by, because it may
 > > not even be one that you and Sasha have been seeing; but I'm hopeful,
 > > remap_file_pages is in the list.
 > >
 > > Please give this a try, preferably on 3.14-rc or earlier: I've never
 > > seen "Bad rss-counter"s there myself (trinity uses remap_file_pages
 > > a lot more than most of us); but have seen them on mmotm/next, so
 > > some other trigger is coming up there, I'll worry about that once
 > > it reaches 3.15-rc.
 > 
 > The patch fixed the "Bad rss-counter" errors I've been seeing both in
 > 3.14-rc7 and -next.
 
It's looking good here too so far. I'll leave it running overnight to be sure.

	Dave

