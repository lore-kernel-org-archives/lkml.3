Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399AbaHVOS0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 10:18:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:27472 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932099AbaHVOSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 10:18:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,381,1406617200"; 
   d="scan'208";a="591912670"
Date: Fri, 22 Aug 2014 07:18:07 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Wanpeng Li <wanpeng.li@linux.intel.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Michal Hocko <mhocko@suse.cz>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Hillf Danton <dhillf@gmail.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] mm/hugetlb: gigantic hugetlb page pools shrink
 supporting
Message-ID: <20140822141807.GA5803@tassilo.jf.intel.com>
References: <1365066554-29195-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <20130411232907.GC29398@hacker.(null)>
 <20130412152237.GM16732@two.firstfloor.org>
 <20140821233729.GB2420@kernel>
 <53F69E26.1090408@cn.fujitsu.com>
 <20140822040420.GA4756@kernel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140822040420.GA4756@kernel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >commit 944d9fec8d7aee3f2e16573e9b6a16634b33f403
> >Author: Luiz Capitulino <lcapitulino@redhat.com>
> >Date:   Wed Jun 4 16:07:13 2014 -0700
> >
> >    hugetlb: add support for gigantic page allocation at runtime
> >
> >
> 
> Ah, thanks for your pointing out.

I should add the CMA allocation would still make sense, as CMA would do
compaction and better pre-allocation while this does not. Should probably
revisit the issue. But it's at least partially solved now.


-Andi
