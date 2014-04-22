Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933286AbaDVQkp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 12:40:45 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:59479 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933261AbaDVQkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 12:40:40 -0400
Date: Tue, 22 Apr 2014 12:39:44 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Chiang <pchiang@nvidia.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>,
        "ccross@android.com" <ccross@android.com>,
        "lizefan@huawei.com" <lizefan@huawei.com>,
        "tj@kernel.org" <tj@kernel.org>, "pavel@ucw.cz" <pavel@ucw.cz>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "guillaume@morinfr.org" <guillaume@morinfr.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] memcg: kill CONFIG_MM_OWNER
Message-ID: <20140422163944.GB29866@cmpxchg.org>
References: <20140416135741.GA9407@redhat.com>
 <80341664FB79C2419999599F48F7384102273279C3@HKMAIL01.nvidia.com>
 <20140418162359.GA4398@redhat.com>
 <20140418172631.GA13323@redhat.com>
 <20140418182444.GB22235@dhcp22.suse.cz>
 <20140418184441.GA26046@redhat.com>
 <20140418191259.GA7413@redhat.com>
 <20140422132355.GO29311@dhcp22.suse.cz>
 <20140422161513.GA6644@redhat.com>
 <20140422161532.GB6644@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140422161532.GB6644@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 06:15:32PM +0200, Oleg Nesterov wrote:
> CONFIG_MM_OWNER makes no sense. It is not user-selectable, it is only
> selected by CONFIG_MEMCG automatically. So we can kill this option in
> init/Kconfig and do s/CONFIG_MM_OWNER/CONFIG_MEMCG/ globally.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Acked-by: Michal Hocko <mhocko@suse.cz>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
