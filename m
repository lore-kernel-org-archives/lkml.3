Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210AbaA1VxU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 16:53:20 -0500
Received: from one.firstfloor.org ([193.170.194.197]:35516 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932174AbaA1VxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 16:53:19 -0500
Date: Tue, 28 Jan 2014 22:53:17 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Tejun Heo <tj@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, Li Zefan <lizefan@huawei.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, gong.chen@linux.intel.com
Subject: Re: Please revert 4fd466eb46a6 ("HWPOISON: add memory cgroup
 filter")
Message-ID: <20140128215317.GC11821@two.firstfloor.org>
References: <20140128214524.GA16060@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140128214524.GA16060@mtj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 04:45:24PM -0500, Tejun Heo wrote:
> Hello, Andi, Wu.
> 
> Can you guys please revert 4fd466eb46a6 ("HWPOISON: add memory cgroup
> filter"), which reaches into cgroup to extract the inode number and
> uses that for filtering?  Nobody outside cgroup proper should be

Our test suite relies on it.

-Andi
