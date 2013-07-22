Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301Ab3GVKGM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 06:06:12 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:57204 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839Ab3GVKGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 06:06:10 -0400
Date: Mon, 22 Jul 2013 12:06:06 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Dave Hansen <dave@sr71.net>
Cc: Raghavendra KT <raghavendra.kt.linux@gmail.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>
Subject: Re: [RESEND][PATCH] mm: vmstats: tlb flush counters
Message-ID: <20130722100605.GA1148@gmail.com>
References: <20130716234438.C792C316@viggo.jf.intel.com>
 <CAC4Lta1mHixqfRSJKpydH3X9M_nQPCY3QSD86Tm=cnQ+KxpGYw@mail.gmail.com>
 <51E95932.5030902@sr71.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E95932.5030902@sr71.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Hansen <dave@sr71.net> wrote:

> On 07/19/2013 04:38 AM, Raghavendra KT wrote:
> > While measuring non - PLE performance, one of the bottleneck, I am seeing is
> > flush tlbs.
> > perf had helped in alaysing a bit there, but this patch would help
> > in precise calculation. It will aslo help in tuning the PLE window
> > experiments (larger PLE window
> > would affect remote flush TLBs)
> 
> Interesting.  What workload is that?  I've been having problems finding
> workloads that are too consumed with TLB flushes.

Btw., would be nice to also integrate these VM counters into perf as well, 
as an instrumentation variant/option.

It could be done in an almost zero overhead fashion using jump-labels I 
think.

[ Just in case someone is bored to death and is looking for an interesting 
  side project ;-) ]

Thanks,

	Ingo
