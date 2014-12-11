Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933691AbaLKK0a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 05:26:30 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:62387 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417AbaLKK00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 05:26:26 -0500
Date: Thu, 11 Dec 2014 11:26:22 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Vince Weaver <vince@deater.net>,
        "Yan, Zheng" <zheng.z.yan@intel.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCHSET/RFC 0/2] perf: Fix issues reported by perf fuzzer
Message-ID: <20141211102622.GA7997@gmail.com>
References: <1418243031-20367-1-git-send-email-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418243031-20367-1-git-send-email-jolsa@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Olsa <jolsa@kernel.org> wrote:

> hi,
> Vince reported several issues with perf code hit by perf fuzzer,
> in here:
>   http://marc.info/?l=linux-kernel&m=141806390822670&w=2
> 
> I run the fuzzer, but wasn't able to hit issues reported
> by Vince. But.. I was lucky enough to hit other 2 issues
> described in following patches ;-)
> 
> As I dont follow the uncore code much, it is sort of RFC
> patchset. However I'm running the fuzzer now for several
> hours and can't hit any other issue.

The changes are looking good to me so I've applied them to 
tip:perf/urgent to give them more testing.

If they break anything in the uncore code's expectations the 
uncore people should chime in. In any case, stability comes 
first.

Thanks,

	Ingo
