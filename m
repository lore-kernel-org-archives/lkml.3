Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914Ab3LLUdd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 15:33:33 -0500
Received: from relay3.sgi.com ([192.48.152.1]:46722 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751566Ab3LLUdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 15:33:32 -0500
Date: Thu, 12 Dec 2013 14:33:27 -0600
From: Alex Thorlton <athorlton@sgi.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rik van Riel <riel@redhat.com>, Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, Michel Lespinasse <walken@google.com>,
        Benjamin LaHaise <bcrl@kvack.org>, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        David Rientjes <rientjes@google.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Jiang Liu <jiang.liu@huawei.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Glauber Costa <glommer@parallels.com>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] Change how we determine when to hand out THPs
Message-ID: <20131212203327.GB5548@sgi.com>
References: <20131212180037.GA134240@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131212180037.GA134240@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ugggh.  Looks like mutt clobbered the message ID on the cover letter,
screwing up the reply chain.  Sorry about that :/

- Alex
