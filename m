Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357Ab3BUIeT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 03:34:19 -0500
Received: from mx0.parallels.com ([199.115.104.20]:40712 "EHLO
	mx0.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243Ab3BUIeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 03:34:18 -0500
Message-ID: <5125DC11.7060106@parallels.com>
Date: Thu, 21 Feb 2013 12:34:25 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Steffen Michalke <StMichalke@web.de>, <linux-kernel@vger.kernel.org>,
        "Li Zefan" <lizefan@huawei.com>,
        <containers@lists.linux-foundation.org>,
        "Johannes Weiner" <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: PROBLEM: Crash cgdeleting empty memory cgroups with memory.kmem.limit_in_bytes
 set
References: <1361375371.7786.5.camel@michalke-online.eu> <20130220230019.GJ3570@htj.dyndns.org>
In-Reply-To: <20130220230019.GJ3570@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2013 03:00 AM, Tejun Heo wrote:
> (cc'ing cgroup / memcg people and quoting whole body)
> 
> Looks like something is going wrong with memcg cache destruction.
> Glauber, any ideas?  Also, can we please not use names as generic as
> kmem_cache_destroy_work_func for something specific to memcg?  How
> about something like memcg_destroy_cache_workfn?
> 

I will take a look. Thanks for the report for the reportee: I tested
cgroup deletion quite extensively (quite important feature for me) so it
is nice to have an uncaught case.

About naming, I can change, no problem.
