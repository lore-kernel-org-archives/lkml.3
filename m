Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534Ab3DOCyS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 22:54:18 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:54468 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754678Ab3DOCyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 22:54:16 -0400
Date: Sun, 14 Apr 2013 19:54:04 -0700
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com,
        linux-kernel@vger.kernel.org, glommer@parallels.com, vgoyal@redhat.com
Subject: Re: [PATCH 3/4] cgroup: introduce sane_behavior mount option
Message-ID: <20130415025404.GF3050@htj.dyndns.org>
References: <1365808259-31073-1-git-send-email-tj@kernel.org>
 <1365808259-31073-4-git-send-email-tj@kernel.org>
 <516B6AAB.8010507@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <516B6AAB.8010507@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 10:49:15AM +0800, Li Zefan wrote:
> >  	{
> > +		.name = "cgroup.sane_behavior",
> > +		.flags = CFTYPE_ONLY_ON_ROOT,
> > +		.read_seq_string = cgroup_sane_behavior_show,
> > +		.mode = S_IRUGO,
> > +	},
> 
> We don't have to set .mode explicitly.

Right, dropping.

Thanks.

-- 
tejun
