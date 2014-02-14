Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720AbaBNPas (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 10:30:48 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:60798 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752641AbaBNPap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 10:30:45 -0500
Date: Fri, 14 Feb 2014 10:30:35 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: [patch 00/10] mm: thrash detection-based file cache sizing v9
Message-ID: <20140214153035.GQ6963@cmpxchg.org>
References: <1391475222-1169-1-git-send-email-hannes@cmpxchg.org>
 <201402130321.s1D3LH41073563@www262.sakura.ne.jp>
 <20140213221126.GP6963@cmpxchg.org>
 <20140213142407.f2c41f5c6561e708f2453e93@linux-foundation.org>
 <20140214112935.4df6f8ace56725331614556a@canb.auug.org.au>
 <201402140605.s1E65fBl044127@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201402140605.s1E65fBl044127@www262.sakura.ne.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 03:05:41PM +0900, Tetsuo Handa wrote:
> Johannes Weiner wrote:
> > Thanks for the report.  There is already a fix for this in -mm:
> > http://marc.info/?l=linux-mm-commits&m=139180637114625&w=2
> > 
> > It was merged on the 7th, so it should show up in -next... any day
> > now?
> 
> That patch solved this bproblem but breaks build instead.
> 
>   ERROR: \"list_lru_init_key\" [fs/xfs/xfs.ko] undefined!
>   ERROR: \"list_lru_init_key\" [fs/gfs2/gfs2.ko] undefined!
>   make[1]: *** [__modpost] Error 1

There is a follow-up fix in -mm:

http://marc.info/?l=linux-mm-commits&m=139180636814624&w=2
