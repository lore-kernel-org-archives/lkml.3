Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933298AbaDVQy6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 12:54:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63784 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932504AbaDVQy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 12:54:56 -0400
Message-ID: <53569EA4.2000308@redhat.com>
Date: Tue, 22 Apr 2014 12:53:56 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Dave Hansen <dave@sr71.net>, x86@kernel.org
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        mgorman@suse.de, ak@linux.intel.com, alex.shi@linaro.org,
        dave.hansen@linux.intel.com
Subject: Re: [PATCH 1/6] x86: mm: clean up tlb flushing code
References: <20140421182418.81CF7519@viggo.jf.intel.com> <20140421182420.307A0C57@viggo.jf.intel.com>
In-Reply-To: <20140421182420.307A0C57@viggo.jf.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2014 02:24 PM, Dave Hansen wrote:
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> The
> 
> 	if (cpumask_any_but(mm_cpumask(mm), smp_processor_id()) < nr_cpu_ids)
> 
> line of code is not exactly the easiest to audit, especially when
> it ends up at two different indentation levels.  This eliminates
> one of the the copy-n-paste versions.  It also gives us a unified
> exit point for each path through this function.  We need this in
> a minute for our tracepoint.
> 
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>

Acked-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
