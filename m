Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758875AbaDVVeP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 17:34:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13343 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757352AbaDVVeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 17:34:09 -0400
Message-ID: <5356E041.3060709@redhat.com>
Date: Tue, 22 Apr 2014 17:33:53 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Dave Hansen <dave@sr71.net>, x86@kernel.org
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        mgorman@suse.de, ak@linux.intel.com, alex.shi@linaro.org,
        dave.hansen@linux.intel.com
Subject: Re: [PATCH 6/6] x86: mm: set TLB flush tunable to sane value (33)
References: <20140421182418.81CF7519@viggo.jf.intel.com> <20140421182428.FC2104C1@viggo.jf.intel.com>
In-Reply-To: <20140421182428.FC2104C1@viggo.jf.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2014 02:24 PM, Dave Hansen wrote:
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> This has been run through Intel's LKP tests across a wide range
> of modern sytems and workloads and it wasn't shown to make a
> measurable performance difference positive or negative.
> 
> Now that we have some shiny new tracepoints, we can actually
> figure out what the heck is going on.
> 
> During a kernel compile, 60% of the flush_tlb_mm_range() calls
> are for a single page.  It breaks down like this:

> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
