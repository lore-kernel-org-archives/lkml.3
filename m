Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbaBLI1V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:27:21 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:64142 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbaBLI1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:27:17 -0500
Date: Wed, 12 Feb 2014 03:27:13 -0500
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 6/8] cgroup: remove cgroup->name
Message-ID: <20140212082713.GD7984@mtj.dyndns.org>
References: <1391877509-10855-1-git-send-email-tj@kernel.org>
 <1391877509-10855-7-git-send-email-tj@kernel.org>
 <52FB2834.3090408@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52FB2834.3090408@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 03:52:20PM +0800, Li Zefan wrote:
> The caller won't check the return value but pass it to printk/seq_printf,
> but now cgroup_path() might return -ENAMETOOLONG..

cgroup_path() returns NULL on overflow which printk handles fine, no?

Thanks.

-- 
tejun
