Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282Ab3HBCog (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 22:44:36 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:20318 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752966Ab3HBCoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 22:44:34 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgIFAMQc+1F5LPxHgWdsb2JhbABbgzuCd7Z1hTCBGxcOAQEWJiiCJAEBAgM6HCMQCAMOCgklDwUlAyETiA8NuTIWjRmCWAeEDAOXXoojilUq
Date: Fri, 2 Aug 2013 12:44:31 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Namjae Jeon <linkinjeon@gmail.com>, tytso@mit.edu,
        adilger.kernel@dilger.ca, bpm@sgi.com, elder@kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, xfs@oss.sgi.com, a.sangwan@samsung.com,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: Re: [PATCH 2/3] xfs: Implement FALLOC_FL_COLLAPSE_RANGE
Message-ID: <20130802024431.GT13468@dastard>
References: <1375281734-15874-1-git-send-email-linkinjeon@gmail.com>
 <20130801011812.GJ7118@dastard>
 <20130801082402.GA23414@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130801082402.GA23414@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 01:24:02AM -0700, Christoph Hellwig wrote:
> Instead of adding more mess to change_file_space it might be a good idea
> to pull my
> 
>   "refactor the preallocation and hole punching code"
> 
> series from December in first.

You mean this one:

http://oss.sgi.com/archives/xfs/2012-12/msg00124.html

Yeah, probably makes sense to do this. I'll have a look at porting
it forwards to my current tree as xfs_vnodeops.c has gone away in
that series...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
