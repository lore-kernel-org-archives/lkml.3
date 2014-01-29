Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbaA2PZT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 10:25:19 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:51991 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbaA2PZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 10:25:17 -0500
Date: Wed, 29 Jan 2014 10:25:13 -0500
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 6/8] cgroup: remove cgroup->name
Message-ID: <20140129152513.GB30842@htj.dyndns.org>
References: <1390953585-16554-1-git-send-email-tj@kernel.org>
 <1390953585-16554-7-git-send-email-tj@kernel.org>
 <20140129120907.GA22183@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140129120907.GA22183@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 29, 2014 at 01:09:07PM +0100, Michal Hocko wrote:
> Btw. after this change we should drop part of the comment above
> oom_info_lock:

Updated the comment to

 /* oom_info_lock ensures that parallel ooms do not interleave */

Thanks!

-- 
tejun
