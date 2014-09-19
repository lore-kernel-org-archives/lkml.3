Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802AbaISNST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 09:18:19 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:38633 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756595AbaISNSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 09:18:17 -0400
Date: Fri, 19 Sep 2014 09:18:13 -0400
From: Tejun Heo <tj@kernel.org>
To: Zefan Li <lizefan@huawei.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH] perf/cgroup: Remove perf_put_cgroup()
Message-ID: <20140919131813.GB30493@mtj.dyndns.org>
References: <541BEEFA.1020800@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <541BEEFA.1020800@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 04:53:14PM +0800, Zefan Li wrote:
> Commit 5a17f543ed68 ("cgroup: improve css_from_dir() into css_tryget_from_dir()")
> removed perf_tryget_cgroup(), so let's also remove perf_put_cgroup().
> 
> Signed-off-by: Zefan Li <lizefan@huawei.com>

Applied to cgroup/for-3.18.

Thanks.

-- 
tejun
