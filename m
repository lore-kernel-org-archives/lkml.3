Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284Ab3IILNq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 07:13:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41636 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721Ab3IILNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 07:13:44 -0400
Date: Mon, 9 Sep 2013 13:13:42 +0200
From: Michal Hocko <mhocko@suse.cz>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch] mm, memcg: store memcg name for oom kill log consistency
Message-ID: <20130909111342.GA22212@dhcp22.suse.cz>
References: <alpine.DEB.2.02.1308282302450.14291@chino.kir.corp.google.com>
 <20130829133032.GB12077@dhcp22.suse.cz>
 <20130905135219.GE13666@dhcp22.suse.cz>
 <alpine.DEB.2.02.1309090200110.1935@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1309090200110.1935@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 09-09-13 02:00:26, David Rientjes wrote:
> On Thu, 5 Sep 2013, Michal Hocko wrote:
[...]
> > Reported-by: David Rientjes <rientjes@google.com>
> 
> Remove this.

OK. Is there any other way how to give you a credit for
discovering/reporting this issue?

-- 
Michal Hocko
SUSE Labs
