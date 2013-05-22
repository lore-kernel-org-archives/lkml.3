Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812Ab3EVHm7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 03:42:59 -0400
Received: from relay.parallels.com ([195.214.232.42]:38600 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab3EVHm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 03:42:56 -0400
Date: Wed, 22 May 2013 11:40:56 +0400
From: Andrew Vagin <avagin@parallels.com>
To: Michal Hocko <mhocko@suse.cz>
CC: Andrey Vagin <avagin@openvz.org>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <cgroups@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Glauber Costa <glommer@parallels.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] memcg: don't initialize kmem-cache destroying work for
 root caches
Message-ID: <20130522074055.GA16207@paralelels.com>
References: <1368535118-27369-1-git-send-email-avagin@openvz.org>
 <20130514160859.GC5055@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="koi8-r"
Content-Disposition: inline
In-Reply-To: <20130514160859.GC5055@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [10.24.21.118]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 06:08:59PM +0200, Michal Hocko wrote:
> 
> Forgot to add
> Reviewed-by: Michal Hocko <mhocko@suse.cz>
> +
> Cc: stable # 3.9
> 
> Thanks

Who usually picks up such patches?
