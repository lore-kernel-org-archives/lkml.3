Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502AbaGKNvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 09:51:19 -0400
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:45492 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932099AbaGKNvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 09:51:15 -0400
Date: Fri, 11 Jul 2014 08:51:10 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Jiang Liu <jiang.liu@linux.intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov@parallels.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jianyu Zhan <nasa4836@gmail.com>, malc <av1474@comtv.ru>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Fabian Frederick <fabf@skynet.be>, Tony Luck <tony.luck@intel.com>,
        linux-mm@kvack.org, linux-hotplug@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC Patch V1 07/30] mm: Use cpu_to_mem()/numa_mem_id() to
 support memoryless node
In-Reply-To: <1405064267-11678-8-git-send-email-jiang.liu@linux.intel.com>
Message-ID: <alpine.DEB.2.11.1407110850540.21073@gentwo.org>
References: <1405064267-11678-1-git-send-email-jiang.liu@linux.intel.com> <1405064267-11678-8-git-send-email-jiang.liu@linux.intel.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2014, Jiang Liu wrote:

> If CONFIG_HAVE_MEMORYLESS_NODES is disabled, cpu_to_mem()/numa_mem_id()
> is the same as cpu_to_node()/numa_node_id().

Reviewed-by: Christoph Lameter <cl@linux.com>
