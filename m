Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529AbaFEVi1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 17:38:27 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:63581 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbaFEVi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 17:38:26 -0400
MIME-Version: 1.0
In-Reply-To: <20140605213354.GD16855@tassilo.jf.intel.com>
References: <1401917658-26065-1-git-send-email-eranian@google.com>
	<1401917658-26065-5-git-send-email-eranian@google.com>
	<20140605082935.GI3213@twins.programming.kicks-ass.net>
	<20140605213354.GD16855@tassilo.jf.intel.com>
Date: Thu, 5 Jun 2014 23:38:26 +0200
Message-ID: <CABPqkBTbt+ro+G0JLQEjLSubWZC7pz1X=qTQetK-i_KBp_D6Gg@mail.gmail.com>
Subject: Re: [PATCH 4/9] perf/x86: add cross-HT counter exclusion infrastructure
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>, Jiri Olsa <jolsa@redhat.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>,
        Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 5, 2014 at 11:33 PM, Andi Kleen <ak@linux.intel.com> wrote:
>> This hard assumes theres only ever 2 threads, which is true and I
>> suppose more in arch/x86 will come apart the moment Intel makes a chip
>> with more, still, do we have topology_thread_id() or so to cure this?
>
>
> Xeon Phi already has 4 threads today.
>
Yes, but it does not have that bug (hopefully). This code is just for
the impacted processors.

> -Andi
>
> --
> ak@linux.intel.com -- Speaking for myself only
