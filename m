Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932269AbaA1V4i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 16:56:38 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:54742 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755432AbaA1V4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 16:56:37 -0500
Date: Tue, 28 Jan 2014 16:56:32 -0500
From: Tejun Heo <tj@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Li Zefan <lizefan@huawei.com>, Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, gong.chen@linux.intel.com
Subject: Re: Please revert 4fd466eb46a6 ("HWPOISON: add memory cgroup filter")
Message-ID: <20140128215632.GB16060@mtj.dyndns.org>
References: <20140128214524.GA16060@mtj.dyndns.org>
 <20140128215317.GC11821@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140128215317.GC11821@two.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 10:53:17PM +0100, Andi Kleen wrote:
> On Tue, Jan 28, 2014 at 04:45:24PM -0500, Tejun Heo wrote:
> > Hello, Andi, Wu.
> > 
> > Can you guys please revert 4fd466eb46a6 ("HWPOISON: add memory cgroup
> > filter"), which reaches into cgroup to extract the inode number and
> > uses that for filtering?  Nobody outside cgroup proper should be
> 
> Our test suite relies on it.

Hmmm?  Ooh, I thought this just went in during this -rc1 window.  This
was way back in 2009.  I suppose cgroup should expose an interface to
query inode then.  inos changing across remounts should be okay,
right?

Thanks.

-- 
tejun
