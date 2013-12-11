Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503Ab3LKNEx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 08:04:53 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:41554 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab3LKNEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 08:04:52 -0500
Date: Wed, 11 Dec 2013 14:04:48 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH v0 00/71] perf: Add support for Intel Processor Trace
Message-ID: <20131211130448.GA2480@gmail.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexander Shishkin <alexander.shishkin@linux.intel.com> wrote:

> Hi,
> 
> This patchset adds support for Intel Processor Trace (PT) extension 
> [1] of Intel Architecture that allows the capture of information 
> about software execution flow, to the perf kernel and userspace 
> infrastructure. We provide an abstraction for it called "itrace" for 
> "instruction trace" ([2]).

Ok, this feature looks rather interesting.

On the hardware side this is essentially BTS (Branch Trace Store) on 
steroids (with many extensions), right?

Thanks,

	Ingo
