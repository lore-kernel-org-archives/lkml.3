Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbaCNM1S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 08:27:18 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:35065 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024AbaCNM1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 08:27:16 -0400
Date: Fri, 14 Mar 2014 16:27:14 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Dave Jones <davej@redhat.com>, Sasha Levin <sasha.levin@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, Bob Liu <bob.liu@oracle.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: bad rss-counter message in 3.14rc5
Message-ID: <20140314122714.GR13448@moon>
References: <20140310220158.7e8b7f2a.akpm@linux-foundation.org>
 <20140311053017.GB14329@redhat.com>
 <20140311132024.GC32390@moon>
 <531F0E39.9020100@oracle.com>
 <20140311134158.GD32390@moon>
 <20140311142817.GA26517@redhat.com>
 <20140311143750.GE32390@moon>
 <20140311171045.GA4693@redhat.com>
 <20140311173603.GG32390@moon>
 <20140311173917.GB4693@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140311173917.GB4693@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 01:39:17PM -0400, Dave Jones wrote:
>  > 
>  > Sasha already gave a link to the syscalls sequence, so no rush.
> 
> It'd be nice to get a more concise reproducer, his list had a little of everything in there.

Dave, could you please send me your config privately so I would try to reproduce
the issue locally maybe it shed some light on the problem.

	Cyrill
