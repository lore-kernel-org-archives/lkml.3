Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbaDCWbS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 18:31:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:61515 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753330AbaDCWbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 18:31:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,791,1389772800"; 
   d="scan'208";a="514417090"
Message-ID: <533DE12C.9030203@intel.com>
Date: Thu, 03 Apr 2014 15:31:08 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr@hp.com>, linux-mm@kvack.org
CC: linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] mm,tracing: improve current situation
References: <1396561440.4661.33.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1396561440.4661.33.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2014 02:44 PM, Davidlohr Bueso wrote:
> Now, on a more general scenario, I basically would like to know, 1) is
> this actually useful... I'm hoping that, if in fact something like this
> gets merged, it won't just sit there. 2) What other general data would
> be useful for debugging purposes? I'm happy to collect feedback and send
> out something we can all benefit from.

One thing that would be nice, specifically for the VM, would be to turn
all of the things that touch the /proc/vmstat counters
(count_vm_event(), etc...) in to tracepoints.

I started on it once, but ran in to some header dependency hell and gave
up before I got anything useful.
