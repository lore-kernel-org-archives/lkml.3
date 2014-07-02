Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243AbaGBOtH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 10:49:07 -0400
Received: from mail-qg0-f46.google.com ([209.85.192.46]:45271 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbaGBOtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 10:49:06 -0400
Date: Wed, 2 Jul 2014 10:49:01 -0400
From: Tejun Heo <tj@kernel.org>
To: Binder Makin <merimus@google.com>
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        Daniel Jacobowitz <dmj@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org
Subject: Re: [RFC] cgroups: Resource controller for open files.
Message-ID: <20140702144901.GC23275@htj.dyndns.org>
References: <1404311407-4851-1-git-send-email-merimus@google.com>
 <20140702143300.GB23275@htj.dyndns.org>
 <CAANmLtwwbKBi+zZ01ywbeMnzu5a0UvqEz-_zHJLNtBVso2=ibg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAANmLtwwbKBi+zZ01ywbeMnzu5a0UvqEz-_zHJLNtBVso2=ibg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jul 02, 2014 at 10:46:59AM -0400, Binder Makin wrote:
> kmem keeps the cgroup from DOSing the machine but then you can get a ENOMEM
> out of some call which is trying to allocate kernel memory.
> People are used to limiting file handles from rlimits and the EMFILE is
> easier for them to debug/fix.

EMFILE instead of ENOMEM seems really thin as the sole rationale for a
whole new controller, doesn't it?

Thanks.

-- 
tejun
