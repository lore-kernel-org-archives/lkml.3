Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760735Ab3GSPUa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 11:20:30 -0400
Received: from www.sr71.net ([198.145.64.142]:42657 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760253Ab3GSPU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 11:20:29 -0400
Message-ID: <51E95932.5030902@sr71.net>
Date: Fri, 19 Jul 2013 08:20:18 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Raghavendra KT <raghavendra.kt.linux@gmail.com>
CC: linux-kernel@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>
Subject: Re: [RESEND][PATCH] mm: vmstats: tlb flush counters
References: <20130716234438.C792C316@viggo.jf.intel.com> <CAC4Lta1mHixqfRSJKpydH3X9M_nQPCY3QSD86Tm=cnQ+KxpGYw@mail.gmail.com>
In-Reply-To: <CAC4Lta1mHixqfRSJKpydH3X9M_nQPCY3QSD86Tm=cnQ+KxpGYw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2013 04:38 AM, Raghavendra KT wrote:
> While measuring non - PLE performance, one of the bottleneck, I am seeing is
> flush tlbs.
> perf had helped in alaysing a bit there, but this patch would help
> in precise calculation. It will aslo help in tuning the PLE window
> experiments (larger PLE window
> would affect remote flush TLBs)

Interesting.  What workload is that?  I've been having problems finding
workloads that are too consumed with TLB flushes.


