Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbaCGBzK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 20:55:10 -0500
Received: from g5t1625.atlanta.hp.com ([15.192.137.8]:41602 "EHLO
	g5t1625.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbaCGBzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 20:55:09 -0500
Message-ID: <1394157304.2555.21.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 6/7] x86: mm: set TLB flush tunable to sane value
From: Davidlohr Bueso <davidlohr@hp.com>
To: Dave Hansen <dave@sr71.net>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        ak@linux.intel.com, kirill.shutemov@linux.intel.com, mgorman@suse.de,
        alex.shi@linaro.org, x86@kernel.org, linux-mm@kvack.org,
        dave.hansen@linux.intel.com
Date: Thu, 06 Mar 2014 17:55:04 -0800
In-Reply-To: <20140306004529.5510B23D@viggo.jf.intel.com>
References: <20140306004519.BBD70A1A@viggo.jf.intel.com>
	 <20140306004529.5510B23D@viggo.jf.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-05 at 16:45 -0800, Dave Hansen wrote:
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> Now that we have some shiny new tracepoints, we can actually
> figure out what the heck is going on.
> 
> During a kernel compile, 60% of the flush_tlb_mm_range() calls
> are for a single page.  It breaks down like this:

It would be interesting to see similar data for opposite workloads with
more random access patterns. That's normally when things start getting
fun in the tlb world.

Thanks,
Davidlohr

