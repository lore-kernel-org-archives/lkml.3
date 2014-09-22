Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023AbaIVEpp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 00:45:45 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:59155 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbaIVEpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 00:45:42 -0400
Date: Mon, 22 Sep 2014 00:45:38 -0400
From: Tejun Heo <tj@kernel.org>
To: Zefan Li <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        keescook@chromium.org
Subject: Re: [PATCH v2 1/3] sched: fix confusing PFA_NO_NEW_PRIVS constant
Message-ID: <20140922044538.GH23583@htj.dyndns.org>
References: <541FA8F4.90703@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <541FA8F4.90703@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 12:43:32PM +0800, Zefan Li wrote:
> Commit 1d4457f99928 ("sched: move no_new_privs into new atomic flags")
> defined PFA_NO_NEW_PRIVS as hexadecimal value, but it is confusing
> because it is used as bit number. Redefine it as decimal bit number.
> 
> Note this changes the bit position of PFA_NOW_NEW_PRIVS from 1 to 0.
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Acked-by: Kees Cook <keescook@chromium.org>
> [ lizf: slightly modified subject and changelog ]
> Signed-off-by: Zefan Li <lizefan@huawei.com>

All the patches look good to me.  I can't say I'm a big fan of
function defining macros but I don't have prettier alternatives
either.  Once Peter/Ingo acks the patches, I'll route them through
cgroup/for-3.17-fixes.

Thanks.

-- 
tejun
