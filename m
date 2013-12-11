Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691Ab3LKNwe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 08:52:34 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:46621 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab3LKNwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 08:52:33 -0500
Date: Wed, 11 Dec 2013 10:52:25 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH v0 00/71] perf: Add support for Intel Processor Trace
Message-ID: <20131211135225.GA1458@ghostprotocols.net>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Dec 11, 2013 at 02:36:12PM +0200, Alexander Shishkin escreveu:
> Hi,
> 
> This patchset adds support for Intel Processor Trace (PT) extension [1] of
> Intel Architecture that allows the capture of information about software
> execution flow, to the perf kernel and userspace infrastructure. We
> provide an abstraction for it called "itrace" for "instruction
> trace" ([2]).

Nice stuff! And big patchset, I'll start by cherry picking the tooling
chunks that I find OK, will then comment on whatever is left.

While that happens I'm sure the new kernel bits will be discussed.

- Arnaldo
