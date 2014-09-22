Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751039AbaIVECT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 00:02:19 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:57813 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbaIVECS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 00:02:18 -0400
Date: Mon, 22 Sep 2014 00:02:14 -0400
From: Tejun Heo <tj@kernel.org>
To: Zefan Li <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        keescook@chromium.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: [PATCH 1/3] sched: fix confusing PFA_NO_NEW_PRIVS constant
Message-ID: <20140922040214.GE23583@htj.dyndns.org>
References: <541F9C96.10705@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <541F9C96.10705@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 11:50:46AM +0800, Zefan Li wrote:
> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> 
> Commit 1d4457f99928 ("sched: move no_new_privs into new atomic flags")
> defined PFA_NO_NEW_PRIVS as hexadecimal value, but it is confusing
> because it is used as bit number. Redefine it as decimal bit number.

It's also changing the bit position, which is fine but should be
mentioned in the description.

Thanks.

-- 
tejun
