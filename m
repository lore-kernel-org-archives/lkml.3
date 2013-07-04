Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884Ab3GDRBo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 13:01:44 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:41766 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756593Ab3GDRBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 13:01:41 -0400
Date: Thu, 4 Jul 2013 10:01:35 -0700
From: Tejun Heo <tj@kernel.org>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Li Zefan <lizefan@huawei.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v3 23/25] cgroup: Change how dentry's d_lock field is
 accessed
Message-ID: <20130704170135.GB23904@htj.dyndns.org>
References: <1372882926-23239-1-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372882926-23239-1-git-send-email-Waiman.Long@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 03, 2013 at 04:22:06PM -0400, Waiman Long wrote:
> Because of the changes made in dcache.h header file, files that
> use the d_lock field of the dentry structure need to be changed
> accordingly. All the d_lock's spin_lock() and spin_unlock() calls
> are replaced by the corresponding d_lock() and d_unlock() calls.
> There is no change in logic and everything should just work.
> 
> Signed-off-by: Waiman Long <Waiman.Long@hp.com>

Acked-by: Tejun Heo <tj@kernel.org>

Please feel free to route the patch as you see fit.

Thanks.

-- 
tejun
