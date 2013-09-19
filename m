Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070Ab3ISIYM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 04:24:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:65349 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751606Ab3ISIYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 04:24:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,935,1371106800"; 
   d="scan'208";a="405709140"
From: Andi Kleen <andi@firstfloor.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Dave Jones <davej@redhat.com>
Subject: Re: perf-related lockup on 3.11
References: <alpine.DEB.2.10.1309111130410.31828@vincent-weaver-1.um.maine.edu>
	<alpine.DEB.2.10.1309171710130.15599@vincent-weaver-1.um.maine.edu>
Date: Thu, 19 Sep 2013 01:24:05 -0700
In-Reply-To: <alpine.DEB.2.10.1309171710130.15599@vincent-weaver-1.um.maine.edu>
	(Vince Weaver's message of "Tue, 17 Sep 2013 17:15:27 -0400 (EDT)")
Message-ID: <8761tx5ie2.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vince Weaver <vincent.weaver@maine.edu> writes:

> On Wed, 11 Sep 2013, Vince Weaver wrote:
>
>> 
>> I got this hard lockup running my perf_fuzzer on 3.11 on a core2.
>> I guess I should try to reproduce it on linus-git but was hoping
>> I could wait until -rc1 before trying that.
>
> OK, I can also lock up 3.12-rc1 using the perf_fuzzer.  Last message
> logged is below.

If it's easily reproducible and a regression, could you perhaps bisect it?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
