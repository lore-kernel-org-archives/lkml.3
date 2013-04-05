Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161746Ab3DENlc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 09:41:32 -0400
Received: from mx2.parallels.com ([199.115.105.18]:44939 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161611Ab3DENlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 09:41:31 -0400
Message-ID: <515ED4B4.2030101@parallels.com>
Date: Fri, 5 Apr 2013 17:42:12 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Li Zefan <lizefan@huawei.com>, <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [RFC][PATCH 1/7] memcg: use css_get in sock_update_memcg()
References: <515BF233.6070308@huawei.com> <515BF249.50607@huawei.com> <515C2788.90907@parallels.com> <20130403152934.GL16471@dhcp22.suse.cz> <515E8688.3000504@parallels.com> <20130405133815.GE31132@dhcp22.suse.cz>
In-Reply-To: <20130405133815.GE31132@dhcp22.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> OK, I guess I understand.
> 
> Thanks for the clarification, Galuber!

You're welcome Mihcal!

