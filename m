Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543AbaIXNGd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 09:06:33 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:43138 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbaIXNGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 09:06:32 -0400
Date: Wed, 24 Sep 2014 09:06:20 -0400
From: Tejun Heo <tj@kernel.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: lizefan@huawei.com, peterz@infradead.org, mingo@kernel.org,
        miaox@cn.fujitsu.com, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, keescook@chromium.org
Subject: Re: [PATCH v2 3/3] cpuset: PF_SPREAD_PAGE and PF_SPREAD_SLAB should
 be atomic flags
Message-ID: <20140924130620.GB16555@htj.dyndns.org>
References: <54210D3F.2090409@huawei.com>
 <54210DA5.4040606@huawei.com>
 <201409231955.FDB73406.FOOJLOVQMHFSFt@I-love.SAKURA.ne.jp>
 <542233F0.1080402@huawei.com>
 <201409242044.GFJ81269.FJFVQOLSHtFMOO@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201409242044.GFJ81269.FJFVQOLSHtFMOO@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 08:44:43PM +0900, Tetsuo Handa wrote:
> Tejun Heo wrote:
> > All the patches look good to me.  I can't say I'm a big fan of
> > function defining macros but I don't have prettier alternatives
> > either.  Once Peter/Ingo acks the patches, I'll route them through
> > cgroup/for-3.17-fixes.
> 
> Peter and Ingo, are these patches OK for you?

Peter acked.  I'll apply the patches to cgroup/for-3.17-fixes.

Thanks.

-- 
tejun
