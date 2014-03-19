Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933892AbaCSME2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 08:04:28 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:58484 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755166AbaCSME0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 08:04:26 -0400
Date: Wed, 19 Mar 2014 16:04:24 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Hugh Dickins <hughd@google.com>
Cc: Dave Jones <davej@redhat.com>, Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, Bob Liu <bob.liu@oracle.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: bad rss-counter message in 3.14rc5
Message-ID: <20140319120424.GD1728@moon>
References: <20140311053017.GB14329@redhat.com>
 <20140311132024.GC32390@moon>
 <531F0E39.9020100@oracle.com>
 <20140311134158.GD32390@moon>
 <20140311142817.GA26517@redhat.com>
 <20140311143750.GE32390@moon>
 <20140311171045.GA4693@redhat.com>
 <20140311173603.GG32390@moon>
 <20140311173917.GB4693@redhat.com>
 <alpine.LSU.2.11.1403181703470.7055@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1403181703470.7055@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 05:38:38PM -0700, Hugh Dickins wrote:
> 
> (Cyrill, entirely unrelated, but in preparing this patch I noticed
> your soft_dirty work in install_file_pte(): which looked good at
> first, until I realized that it's propagating the soft_dirty of a
> pte it's about to zap completely, to the unrelated entry it's about
> to insert in its place.  Which seems very odd to me.)
> 

Thanks a lot Hugh for pointing! I'll revisit all file-softdirty cases.
(btw, I've grabbed Dave's config to run trinity and somehow help in
 testing and attempt to figure out what causes it but didn't yet
 find hardware node to run, hopefully i'll get a spare machine for
 testing in a couple of days).
