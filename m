Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583Ab3C0QVG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 12:21:06 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:48612 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529Ab3C0QVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 12:21:04 -0400
MIME-Version: 1.0
In-Reply-To: <20130327161905.GN16579@dhcp22.suse.cz>
References: <1364373399-17397-1-git-send-email-mhocko@suse.cz>
	<20130327161527.GA7395@htj.dyndns.org>
	<20130327161905.GN16579@dhcp22.suse.cz>
Date: Wed, 27 Mar 2013 09:21:02 -0700
X-Google-Sender-Auth: pIQgVd7VibEaB_TJK7PXPz2y3kI
Message-ID: <CAOS58YPsrZNU9qDeMgJG3-Hkn0cBaigz16eTS5M57G95E8fxUQ@mail.gmail.com>
Subject: Re: [PATCH] memcg: fix memcg_cache_name() to use cgroup_name()
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Glauber Costa <glommer@parallels.com>, Li Zefan <lizefan@huawei.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 9:19 AM, Michal Hocko <mhocko@suse.cz> wrote:
>> Maybe the name could signify it's part of memcg?
>
> kmem_ prefix is used for all CONFIG_MEMCG_KMEM functions. I understand
> it clashes with sl?b naming but this is out of scope of this patch IMO.

Oh, it's not using kmemcg? I see. Maybe we can rename later.

Thanks.

-- 
tejun
