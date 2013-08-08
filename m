Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934102Ab3HHCxs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 22:53:48 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:40885 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933868Ab3HHCxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 22:53:46 -0400
Message-ID: <5203081C.8050403@huawei.com>
Date: Thu, 8 Aug 2013 10:53:16 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Michal Hocko <mhocko@suse.cz>, <hannes@cmpxchg.org>,
        <bsingharora@gmail.com>, <kamezawa.hiroyu@jp.fujitsu.com>,
        <cgroups@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHSET cgroup/for-3.12] cgroup: make cgroup_event specific
 to memcg
References: <1375632446-2581-1-git-send-email-tj@kernel.org> <20130805160107.GM10146@dhcp22.suse.cz> <20130805162958.GF19631@mtj.dyndns.org> <20130805191641.GA24003@dhcp22.suse.cz> <20130805194431.GD23751@mtj.dyndns.org> <20130806155804.GC31138@dhcp22.suse.cz> <20130806161509.GB10779@mtj.dyndns.org> <20130807121836.GF8184@dhcp22.suse.cz> <20130807124321.GA27006@htj.dyndns.org> <20130807132613.GH8184@dhcp22.suse.cz> <20130807133645.GE27006@htj.dyndns.org>
In-Reply-To: <20130807133645.GE27006@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> If somebody needs a notification interface (and there is no one available
>> right now) then you cannot prevent from such a pointless work anyway...
> 
> I'm gonna add one for freezer state transitions.  It'll be simple
> "this file changed" thing and will probably apply that to at least oom
> and vmpressure.  I'm relatively confident that it's gonna be pretty
> simple and that's gonna be the cgroup event mechanism.
> 

I would like to see this happen. I have a feeling that we're deprecating
features a bit aggressively without providing alternatives.

