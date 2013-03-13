Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933884Ab3CMQ7H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 12:59:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:35418 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933656Ab3CMQ7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 12:59:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,838,1355126400"; 
   d="scan'208";a="305672340"
Date: Wed, 13 Mar 2013 09:59:04 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/hugetlb: fix total hugetlbfs pages count when memory
 overcommit accouting
Message-ID: <20130313165904.GB19692@tassilo.jf.intel.com>
References: <1363158511-21272-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <CAJd=RBBVU8uvHZ3AHkBqOWe-hEqFQ5-5Mf5dGXYuGczvM6EpUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJd=RBBVU8uvHZ3AHkBqOWe-hEqFQ5-5Mf5dGXYuGczvM6EpUw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Can we enrich the output of hugetlb_report_meminfo() ?

The data is reported separately in sysfs. It was originally decided
to not extend meminfo for them.

-Andi
