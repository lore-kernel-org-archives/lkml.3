Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab3AXTmR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 14:42:17 -0500
Received: from mail-qe0-f48.google.com ([209.85.128.48]:34017 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab3AXTmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 14:42:11 -0500
Date: Thu, 24 Jan 2013 11:42:05 -0800
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH v2 2/6] sched: split out css_online/css_offline from tg
 creation/destruction
Message-ID: <20130124194205.GS2373@mtj.dyndns.org>
References: <5100D4FE.9080205@huawei.com>
 <5100D518.8000103@huawei.com>
 <20130124100134.GC26351@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130124100134.GC26351@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 11:01:34AM +0100, Ingo Molnar wrote:
> Acked-by: Ingo Molnar <mingo@kernel.org>

Ingo, if you don't objecdt, I'll take these through cgroup/for-3.9
branch with other cgroup changes.  Pleaes holler if you object.

Thanks.

-- 
tejun
